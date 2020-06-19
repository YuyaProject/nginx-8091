# production stage
FROM nginx:1.18.0-alpine as production-stage
ENV TZ=Europe/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /usr/share/nginx/html

# NGinX Config
RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 777 /var
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN set -x \
	&& chmod go+w /var/cache/nginx \
	&& sed -i "s/80/8091/g" /etc/nginx/conf.d/default.conf \
	&& sed -i -e '/user/!b' -e '/nginx/!b' -e '/nginx/d' /etc/nginx/nginx.conf \
	&& sed -i 's!/var/run/nginx.pid!/var/cache/nginx/nginx.pid!g' /etc/nginx/nginx.conf

EXPOSE 8091
CMD ["nginx", "-g", "daemon off;"]
