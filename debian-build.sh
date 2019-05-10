#!/bin/bash

apt-get update
apt-get source nginx-light
tar xvf nginx_*.debian.tar.xz

echo -e "print-%:\n\t@echo" '$($*)' > printvar.mk
configure_flags=$(make -f printvar.mk -f debian/rules print-light_configure_flags)

cd nginx-*/
./configure $(configure_flags) --add-dynamic-module=/opt/nginx-dogstatsd/
make modules

mv objs/ngx_http_dogstatsd_module.so /opt/nginx-dogstatsd/
