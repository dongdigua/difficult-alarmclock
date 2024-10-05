FROM alpine
EXPOSE 80
RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN apk --no-cache --update add apache2 apache2-ctl py3-pip mpg123 cronie
RUN pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --break-system-packages python-crontab
COPY httpd.conf /etc/apache2/httpd.conf
CMD "apachectl ; crond"
