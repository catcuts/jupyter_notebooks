

>[参考](https://askubuntu.com/questions/216692/where-is-the-user-crontab-stored)

　　用户（如 `root`）对定时任务的配置，其文件放在：

```shell
/var/spool/cron/crontabs
```

　　当系统部署为只读的时候，可以将这个目录链接到读写的目录上。

　　可以使用符号链接，或 `bind` 方式挂接。
  
　　实践是：

1. 使用符号链接时，每次重启都要重新链接，所以可以加到系统启动项中：

　　示例：

```shell
# in /etc/rc.local

# ...

ln -s /path/to/rw/dir /var/spool/cron/crontabs

exit 0
```

2. 使用 `bind` 方式挂接时，似乎没有效果，挂是挂上去了（umount 能成功），但是没有用（`mount` 和 `df -h` 都没有显示该挂接）：

　　示例：
  
```shell
# in /etc/fstab

# ...

/dev/mmcblk0p3       /home/pi/hd              ext4 defaults,     0 1
/home/pi/hd/crontabs /var/spool/cron/crontabs none defaults,bind 0 1

```
