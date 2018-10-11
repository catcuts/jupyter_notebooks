

>[参考 1](https://blog.csdn.net/qinxiandiqi/article/details/39475209)
>
>[参考 2](https://www.cnblogs.com/b028/archive/2011/01/07/1930243.html)

```shell
contrab -e
```

```shell
# m h  dom mon dow   command
 
# * * * * *  command to execute
# ┬ ┬ ┬ ┬ ┬
# │ │ │ │ │
# │ │ │ │ │
# │ │ │ │ └───── 星期中的哪一天(0-7)(从0到6代表星期日到星期六,也可以使用名字;7是星期天,等同于0)
# │ │ │ └────────── 月份 (1 - 12)
# │ │ └─────────────── 月份中的日 (1 - 31)
# │ └──────────────────── 小时 (0 - 23)
# └───────────────────────── 分钟 (0 - 59)
```

　　比如：
```shell
# 每天 00:10 执行
10 0 * * *  /home/pi/backup.sh

# 每天早上 6 点 10 分
10 6 * * *  /home/pi/backup.sh

# 每 2 个小时
0 */2 * * *  /home/pi/backup.sh

# 晚上 11 点到早上 8 点之间每两个小时，早上 8 点
0 23-7/2，8 * * *  /home/pi/backup.sh

# 每个月的 4 号和每个礼拜的礼拜一到礼拜三的早上 11 点
0 11 4 * mon-wed  /home/pi/backup.sh

# 1 月份日早上 4 点
0 4 1 jan *  /home/pi/backup.sh

# 应用
# 每 2 天清理一次（清理 1 天前的备份）
0 0 */2 * *  /home/pi/sweep_old_iptalk_database_bkups.sh
# 每 1 小时备份一次
0 */1 * * *  /home/pi/backup_iptalk_database.sh 

```
