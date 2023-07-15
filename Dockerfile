FROM alpine:latest

# 创建非root用户
RUN addgroup -S myusergroup && adduser -S -G myusergroup myuser -u 10014

# 设置工作目录和文件权限
COPY ./content /workdir/
RUN chown -R myuser:myusergroup /workdir && chmod +x /workdir/*.sh /workdir/service/*/run

# 安装依赖和配置服务
RUN apk add --no-cache runit curl redis gcompat \
    && /workdir/install.sh \
    && rm /workdir/install.sh \
    && ln -s /workdir/service/* /etc/service/

# 设置环境变量和暴露端口
ENV PORT=3000
EXPOSE 3000

# 以非root用户运行服务
USER myuser

# 设置入口点
ENTRYPOINT ["runsvdir","-P","/etc/service"]
