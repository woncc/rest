#!/bin/sh
mkdir -p /opt
cp -R ubuntu14.04/opt/* /opt/
cd cJSON
gcc cJSON.c -o /opt/http/lualib/libcjson.so -shared -fPIC
