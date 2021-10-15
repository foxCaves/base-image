FROM openresty/openresty:alpine-fat

RUN apk update && apk add s6 imagemagick git argon2-libs argon2-dev argon2 runuser libuuid openssl-dev
RUN mkdir -p /usr/local/share/lua/5.1
RUN /usr/local/openresty/bin/opm get openresty/lua-resty-redis openresty/lua-resty-websocket thibaultcha/lua-argon2-ffi GUI/lua-resty-mail
RUN /usr/local/openresty/luajit/bin/luarocks install luasocket
RUN /usr/local/openresty/luajit/bin/luarocks install luafilesystem
RUN /usr/local/openresty/luajit/bin/luarocks install pgmoon
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-uuid
RUN /usr/local/openresty/luajit/bin/luarocks install lpath
RUN /usr/local/openresty/luajit/bin/luarocks install luaossl
RUN git clone --depth 1 --branch v1.0.0 https://github.com/foxCaves/raven-lua.git /tmp/raven-lua && mv /tmp/raven-lua/raven /usr/local/share/lua/5.1/ && rm -rf /tmp/raven-lua
RUN git clone --depth 1 --branch v0.1.1 https://github.com/foxCaves/lua-resty-cookie.git /tmp/lua-resty-cookie && cp -r /tmp/lua-resty-cookie/lib/* /usr/local/share/lua/5.1/ && rm -rf /tmp/lua-resty-cookie
RUN adduser -u 1337 --disabled-password foxcaves

COPY etc/cfips.sh /etc/nginx/cfips.sh
COPY etc/s6 /etc/s6

RUN /etc/nginx/cfips.sh

EXPOSE 80 443

ENTRYPOINT ["s6-svscan", "/etc/s6"]
