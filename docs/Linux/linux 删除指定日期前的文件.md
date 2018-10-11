

>[参考 1](https://blog.csdn.net/superbfly/article/details/25000693)
>  
>[参考 2](https://www.2cto.com/os/201208/149552.html)

　　比如：删除 30 天前（等效于：最后 30 天访问）：
```shell
find . -mtime +30 -type f | xargs rm -rf
```

　　完整的可选项列表：
- `-amin n`  
　　查找系统中最后 N 分钟访问的文件 
<br><br>
- `atime n`  
　　查找系统中最后 n\*24 小时访问的文件 
<br><br>
- `cmin n`  
　　查找系统中最后 N 分钟被改变状态的文件 
<br><br>
- `ctime n`  
　　查找系统中最后 n\*24 小时被改变状态的文件 
<br><br>
- `mtime n`  
　　查找系统中最后 n\*24 小时被修改的文件
