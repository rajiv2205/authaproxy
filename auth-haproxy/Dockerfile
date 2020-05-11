FROM haproxy:1.9

RUN apt-get update -y  

RUN apt-get install curl lua5.3 wget unzip liblua5.3 make -y  

RUN cd ~ ; wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz ; \
        tar zxpf luarocks-3.3.1.tar.gz ; \
        cd luarocks-3.3.1 ; \
        ./configure; \
        make; make install ; \
        cp luarocks /usr/bin/luarocks

RUN luarocks install luasocket; \
        luarocks install lua-cjson 2.1.0-1; \
        luarocks install lbase64

RUN mkdir -p /var/lib/haproxy/

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

COPY auth-request.lua /usr/local/etc/haproxy/auth-request.lua
