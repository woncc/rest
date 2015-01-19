
OPENRESTY_VER=1.7.7.1
GITHUB="git clone git://github.com"
RESTY="lua-resty"
RTMP="/tmp/resty"
LUALIB="/opt/http/lualib"
WGET="wget --no-check-certificate"
UNTAR="tar zxf"
#preinstall
#
#

function preinstall {
	mkdir -p $RTMP
	locale-gen zh_CN.UTF-8
	touch /var/lib/cloud/instance/locale-check.skip
	apt-get update
	apt-get install -q -y curl dnsutils git nano perl wget
}

function install_zsh {
	apt-get update
	apt-get install -q -y zsh
	rm -rf ~/.oh-my-zsh
	$GITHUB/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cat > ~/.zshrc <<END
export ZSH=\$HOME/.oh-my-zsh
ZSH_THEME="clean"
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(debian encode64 git gitfast git-extras npm redis-cli pip sudo supervisor)
export PATH="/opt/http/nginx/sbin:/opt/http/bin:/opt/local/sbin:/opt/local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
source \$ZSH/oh-my-zsh.sh
END
	mkdir -p /opt/http/nginx/sbin /opt/http/bin /opt/local/sbin /opt/local/bin
	chsh -s /bin/zsh && zsh
}
#source ~/.zshrc
function install_dropbear {
	apt-get install -q -y dropbear
	touch /etc/ssh/sshd_not_to_be_run
	invoke-rc.d ssh stop
	cat > /etc/default/dropbear <<END
NO_START=0
DROPBEAR_PORT=8066
DROPBEAR_EXTRA_ARGS=
DROPBEAR_BANNER=""
#DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
#DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_RECEIVE_WINDOW=65536
END
	invoke-rc.d dropbear start
	#update-rc.d -f dropbear defaults
}

function install_openresty {
	apt-get install -y build-essential \
	libreadline-dev libncurses5-dev libpcre3-dev libssl-dev
	apt-get -q -y autoremove


	#compile openresty to /opt/http
	cd $RTMP
	$WGET "http://openresty.org/download/ngx_openresty-$OPENRESTY_VER.tar.gz" && \
	$UNTAR ngx_openresty-*.tar.gz && \
	rm -f ngx_openresty-*.tar.gz && \
	cd ngx_openresty-* && \
	./configure --prefix=/opt/http \
	--http-log-path=/opt/logs/access.log \
	--error-log-path=/opt/logs/error.log \
	--with-ipv6 \
	--with-http_realip_module \
	--with-http_iconv_module \
	--without-http_fastcgi_module \
	--without-http_uwsgi_module \
	--without-http_scgi_module && \
	make && make install && make clean && \
	cd .. && \
	rm -rf ngx_openresty-* && \
	ln -s /opt/http/nginx/sbin/nginx /usr/local/bin/nginx && \
	ln -s /opt/http/bin/resty /usr/local/bin/resty && \
	ldconfig && \
	mkdir -p /opt/www /opt/lua /opt/template /opt/logs
}

function install_redis {
	#redis
	$WGET http://download.redis.io/redis-stable.tar.gz && \
	$UNTAR redis-stable.tar.gz && \
	cd redis-stable && \
	make && make install && \
	cd .. && \
	rm -rf redis-stable*
}


function install_libs {
	rm -rf $RTMP/*
	$GITHUB/bungle/$RESTY-template.git $RTMP/template
	cp -R $RTMP/template/lib/* $LUALIB/
	$GITHUB/bungle/$RESTY-session.git $RTMP/session
	cp -R $RTMP/session/lib/* $LUALIB/
	$GITHUB/bungle/$RESTY-random.git $RTMP/random
	cp $RTMP/random/lib/resty/random.lua $LUALIB/resty/rand.lua
}


case "$1" in
zsh)
	install_zsh
	;;
openresty)
	install_openresty
	;;
libs)
	install_libs
	;;
redis)
	install_redis
	;;
dropbear)
	install_dropbear
	;;
system)
	install_openresty
	install_libs
	install_redis
	;;
nozsh)
	preinstall
	install_dropbear
	install_openresty
	install_libs
	install_redis
	;;
*)
	preinstall
	install_dropbear
	install_openresty
	install_libs
	install_redis
	install_zsh
	;;
esac
