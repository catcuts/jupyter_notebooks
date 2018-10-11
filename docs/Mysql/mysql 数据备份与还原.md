

　　导出：
  
```shell
mysqldump -u用户名 -p密码 数据库名 > 数据库名.sql
#（注意：-d 参数只导出表结构）
```

　　导入：

```shell
mysql -u用户名 -p密码 数据库名 < 数据库名.sql
```
