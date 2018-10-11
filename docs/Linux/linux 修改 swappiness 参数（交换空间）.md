

　　**临时修改**
  
```shell
catcuts@catcuts-PC:~$ sudo sysctl vm.swappiness=10
vm.swappiness = 10
```

　　检查：

```shell
catcuts@catcuts-PC:~$ cat /proc/sys/vm/swappiness
10
```
 
　　**永久修改**

```shell
catcuts@catcuts-PC:~$ sudo echo 'vm.swappiness=10' >> /etc/sysctl.conf
```
