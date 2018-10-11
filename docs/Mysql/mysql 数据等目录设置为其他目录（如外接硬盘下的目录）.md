
　　**1. 首先查看数据目录等的位置**
    
```shell
mysql -uUSER -p -e 'SHOW VARIABLES WHERE Variable_Name LIKE "%dir"'
```

　　结果示例：
    
```shell
+---------------------------+----------------------------+
| Variable_name             | Value                      |
+---------------------------+----------------------------+
| basedir                   | /usr/                      |
| character_sets_dir        | /usr/share/mysql/charsets/ |
| datadir                   | /var/lib/mysql/            |
| innodb_data_home_dir      |                            |
| innodb_log_group_home_dir | ./                         |
| innodb_tmpdir             |                            |
| lc_messages_dir           | /usr/share/mysql/          |
| plugin_dir                | /usr/lib/mysql/plugin/     |
| slave_load_tmpdir         | /tmp                       |
| tmpdir                    | /tmp                       |
+---------------------------+----------------------------+

```

　　**2. 停止 mysql 服务**

```shell
sudo /etc/init.d/mysql stop
```

　　结果应为 `[ ok ] ...` ，示例：

```shell
[ ok ] Stopping mysql (via systemctl): mysql.service.
```

　　**3. 备份数据目录和运行配置**
  
```shell
mv /var/lib/mysql /var/lib/mysql_bkup

mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bkup
```

　　**4. 修改 `/etc/mysql/my.cnf` **

```shell
MYSQL_CNF=/etc/mysql/my.cnf
NEW_VAR_RUN_DIR=/path/to/new/var/run
NEW_VAR_LIB_MYSQL_DIR=/path/to/new/var/lib/mysql

sed -i "s/\/var\/run/\$NEW_VAR_RUN_DIR/g" $MYSQL_CNF
sed -i "s/\/var\/run/\$NEW_VAR_LIB_MYSQL_DIR/g" $MYSQL_CNF
```

　　**5. 还原数据目录：（否则 mysql 无法启动）**
  
```shell
sudo cp -r -p /var/lib/mysql_bkup/* /path/to/new/var/lib/mysql
```

　　注：
  
- `-r`: 递归文件夹（ recursively ）
- `-p`: 权限亦复制（ with privilege ）

　　**7. 启动 mysql 服务**
  
```shell
sudo /etc/init.d/mysql start
```

　　结果应为 `[ ok ] ...` ，示例：

```shell
[ ok ] Starting mysql (via systemctl): mysql.service.
```

　　如果不行，可改为用：

```shell
sudo mysqld --user=mysql &
```

　　来启动。

　　**6. 检查**

```shell
mysql -uUSER -p -e 'SHOW VARIABLES WHERE Variable_Name LIKE "%dir"'
```

　　结果示例：
    
```shell
+---------------------------+----------------------------+
| Variable_name             | Value                      |
+---------------------------+----------------------------+
| basedir                   | /usr                       |
| character_sets_dir        | /usr/share/mysql/charsets/ |
| datadir                   | /home/pi/src/data/mysql/   |
| innodb_data_home_dir      |                            |
| innodb_log_group_home_dir | ./                         |
| lc_messages_dir           | /usr/share/mysql/          |
| plugin_dir                | /usr/lib/mysql/plugin/     |
| slave_load_tmpdir         | /home/pi/src/data/tmp      |
| tmpdir                    | /home/pi/src/data/tmp      |
+---------------------------+----------------------------+

```
