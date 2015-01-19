local site_config = {}

site_config.LUAROCKS_PREFIX=[[/opt/local/]]
site_config.LUA_INCDIR=[[/opt/local/include]]
site_config.LUA_LIBDIR=[[/opt/local/lib]]
site_config.LUA_BINDIR=[[/opt/local/bin]]
site_config.LUA_INTERPRETER = [[luajit]]
site_config.LUAROCKS_SYSCONFDIR=[[/opt/local/etc/luarocks]]
site_config.LUAROCKS_ROCKS_TREE=[[/opt/local/]]
site_config.LUAROCKS_ROCKS_SUBDIR=[[lib/luarocks/rocks]]
site_config.LUA_DIR_SET = true
site_config.LUAROCKS_UNAME_S=[[Linux]]
site_config.LUAROCKS_UNAME_M=[[x86_64]]
site_config.LUAROCKS_DOWNLOADER=[[wget]]
site_config.LUAROCKS_MD5CHECKER=[[md5sum]]

return site_config
