FROM yidadaa/chatgpt-next-web as base

# download openresty and lua-resty-feishu-auth
FROM base as buildauth

RUN apk add openresty git
RUN cd /tmp \
  && git clone https://github.com/jkeys089/lua-resty-hmac.git\
  && git clone https://github.com/k8scat/lua-resty-jwt.git\
  && git clone https://github.com/k8scat/lua-resty-http.git\
  && git clone https://github.com/k8scat/lua-resty-feishu-auth.git\
  && cd /usr/lib/nginx/lualib/resty\
  && cp -r /tmp/lua-resty-jwt/lib/resty/* ./ \
  && cp -r /tmp/lua-resty-hmac/lib/resty/hmac.lua ./ \
  && cp -r /tmp/lua-resty-http/lib/resty/* ./ \
  && cp -r /tmp/lua-resty-feishu-auth/lib/resty/* ./


FROM base as runner

ENV PROXY_URL=""
ENV OPENAI_API_KEY=""
ENV GOOGLE_API_KEY=""
ENV CODE=""

ENV DOMAIN="d.nextchat.dev"
ENV APP_ID=""
ENV APP_SECRET=""
ENV JWT_SECRET="jwtsecret"

COPY --from=buildauth /etc/nginx /etc/nginx
COPY --from=buildauth /usr/lib/nginx /usr/lib/nginx
COPY --from=buildauth /usr/sbin/nginx /usr/sbin/nginx
COPY --from=buildauth /usr/lib/libluajit-5.1.so.2 /usr/lib/libluajit-5.1.so.2
COPY --from=buildauth /usr/lib/libpcre.so.1 /usr/lib/libpcre.so.1
ADD nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/tmp/nginx && mkdir -p /var/log/nginx

EXPOSE 80
EXPOSE 3000

CMD nginx && HOSTNAME=127.0.0.1 node server.js

