

> 参考：
> - [apt一键下载所有依赖的包](https://blog.csdn.net/junbujianwpl/article/details/52811153)
> - [Change an apt cache folder location](https://abz89.wordpress.com/2010/02/11/change-an-apt-cache-folder-location/)
> - [Where do packages installed/upgraded with APT get stored?](https://askubuntu.com/questions/178806/where-do-packages-installed-upgraded-with-apt-get-stored)

示例代码：
```shell
#!/bin/bash

download_dir=/media/catcuts/0001C44100083553/Documents/catcuts/project/test/download

logfile=./download_pkg_deps.log
ret=""

echo '' > $logfile

function getDepends()
{
   echo "fileName is" $1>>$logfile
   # use tr to del < >
   ret=`apt-cache depends $1|grep 依赖|cut -d: -f2 |tr -d "<>"`
   echo $ret|tee  -a $logfile
}
# 需要获取其所依赖包的包
libs="resolvconf"                  # 或者用$1，从命令行输入库名字

# download libs dependen. deep in 3
i=0
while [ $i -lt 3 ] ;
do
    let i++
    echo $i
    # download libs
    newlist=" "
    for j in $libs
    do
        added="$(getDepends $j)"
        newlist="$newlist $added"
        sudo apt-get install -o dir::cache::archives=$download_dir $added --reinstall -d -y
        #sudo apt-get install $added --reinstall -d -y
    done

    libs=$newlist
done

```

