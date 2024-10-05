#!/bin/sh

docker run -v $(pwd)/cgi-bin:/var/www/localhost/cgi-bin -v $(pwd)/data:/data -p 8081:80 -it dongdigua/cgi-test sh