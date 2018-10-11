
>参考：[linux 终端设置代理访问](http://aiezu.com/article/linux_bash_set_proxy.html)

举例：

　　现在我们要设置http、https网站都使用socks5代理10.0.0.52:1080，下面为完整设置方法：

1、vim ~/.bashrc，在文件尾部添加下面内容：
```shell
export http_proxy=socks5://10.0.0.52:1080
export https_proxy=socks5://10.0.0.52:1080
export no_proxy="<你的代理服务器地址，避免循环代理>,10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1"
```

2、加载设置:
```shell
[root@aiezu.com ~]# . ~/.bashrc
[root@aiezu.com ~]# echo $http_proxy
socks5://10.0.0.52:1080
[root@aiezu.com ~]# echo $https_proxy
socks5://10.0.0.52:1080
```

3、测试代理：
```shell
[root@aiezu.com ~]# curl -I http://www.google.com
HTTP/1.1 200 OK
Content-Length: 2423
Content-Type: text/html
Last-Modified: Mon, 14 Nov 2016 22:03:32 GMT
Accept-Ranges: bytes
ETag: "0521af0c23ed21:0"
Server: Microsoft-IIS/7.5
X-Powered-By: ASP.NET
Date: Sun, 11 Dec 2016 13:21:33 GMT
```
