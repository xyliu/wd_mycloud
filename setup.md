# [量级建站 Nginx+php-fpm+sqlite 并安装wordpress](https://jose.scjtqs.cn/2015/10/20/4)
  By scjtqs | 2015年10月20日 | WD mycloud
首先 `sudo apt-get remove *apache*`

再 `sudo rm *apache*`

手动删除配置

```
sudo find /usr -name “*apache*” -exec rm -rf {} ;
sudo find /etc -name “*apache*” -exec rm -rf {} ;
sudo find /var -name “*apache*” -exec rm -rf {} ;
```

总之就是干掉所有apche及其相关的东西 (保留/var/www/htdocs

具体步骤:

1 安装:

```
apt-get install nginx
/etc/init.d/nginx start
apt-get install php5-fpm php5-sqlite sqlite sqlite3
```

2 修改配置文件

`vi /etc/nginx/sites-available/default`

修改端口：

`listen 80; ## listen for ipv4.`

修改index:

`index index.php index.html index.htm`

修改root:

`root /var/www/htdocs;`

修改php

```
location ~ \.php$ {
　fastcgi_pass unix:/var/run/php5-fpm.sock;
　fastcgi_index index.php;
　include fastcgi_params;
}
```

最后重载:

`/etc/init.d/nginx reload`

然后登陆mycloud的ip地址,就能看到nginx的提示信息了
三  安装wordpress

安装wordpress比较简单,关键是要使它支持sqlite

首先到官网下载wordpress安装包解压到MC的/var/www/htdocs目录下

http://cn.wordpress.org/

然后是下载sqlite插件

http://wordpress.org/plugins/sqlite-integration/

安装sqlite插件到wordpress

进入wordpress的根目录,把wp-config-sample.php重命名为wp-config.php

编辑wp-config.php添加:

define('USE_MYSQL', false);
然后解压刚才下载的插件包

把解压后的包放到wp-content/plugin/目录下

再把包里面的db.php复制到wp-content目录下,然后就完成了.

然后访问MC的ip,比如http://192.168.2.188/wordpress/

这里我把MC设置成可以外网访问,设置了域名:

https://jose.scjtqs.cn

欢迎访问,不过确实很慢,访问量过大也不行.

