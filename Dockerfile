# 基于nginx:1.20镜像
FROM nginx
# 将dist文件中的内容复制到 /usr/share/nginx/html/ 这个目录下面
COPY dist/ /usr/share/nginx/html/
# 用本地的 nginx.conf 配置来替换nginx镜像里的默认配置 1
COPY nginx.conf /etc/nginx/nginx.conf
# 用本地的 default.conf 配置来替换nginx镜像里的默认配置 2 3
COPY default.conf /etc/nginx/conf.d/default.conf