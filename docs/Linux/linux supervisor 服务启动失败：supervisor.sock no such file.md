

> [参考](https://github.com/Supervisor/supervisor/issues/480)

　　supervisor 服务启动失败：
```shell
unix:///var/run/supervisor.sock no such file
```

　　解决方法：
```shell
sudo touch /var/run/supervisor.sock
sudo chmod 777 /var/run/supervisor.sock
sudo service supervisor restart  # 先直接这个，不行再全套
```
