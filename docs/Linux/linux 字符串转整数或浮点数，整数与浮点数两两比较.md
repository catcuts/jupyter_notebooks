

>参考：
>1. [字符串转数值](https://www.cnblogs.com/chengmo/archive/2010/09/30/1839556.html)
>2. [字符串数值比较](https://blog.csdn.net/timo1160139211/article/details/74078931)

　　示例：（硬盘检查）

```shell
echo -e "[ info ] 检查硬盘 ..."

    selected_hd=

    sddevlist=`ls /dev/sd*`

    for dev in $sddevlist; do
        sddevsize=`fdisk -l $dev | sed -n "s|Disk $dev: \([^,]*\) GiB, .*|\1|p"`
        
        # 字符串转整数或浮点数
        sddevsize=`awk "BEGIN{print $sddevsize+0 }"`
        
        # 数值比较（不论整数或浮点数）
        if [ `echo $sddevsize 900 | awk '{if($1>=$2){printf"ge"}else{printf"lt"}}'` == "ge" ]; then
            echo -ne "上面这个是你的硬盘吗（大小: $sddevsize） ? [y/n] "
            read confirmed
            if [ "$confirmed" == "y" ]; then
                echo -e "用户选择了硬盘: $dev"
                selected_hd=$dev
            fi
        fi
    done 

    if [ -z $selected_hd ]; then
        echo -e "[ erro ] 没有可用的硬盘 . 中止 ."
        exit 1
    fi

echo -e "[ info ] 检查硬盘 正常 ."
```

