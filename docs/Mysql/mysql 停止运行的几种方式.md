

　　1. `sudo /etc/init.d/mysql stop`
 
 
　　2. `sudo service mysql stop`


　　3. `ps aux | grep mysqld | awk '{print$2}' | xargs kill -TERM`
  
　　注：第 3 种方式是安全的，不会导致数据损坏（data corruption），[参考](https://stackoverflow.com/questions/11091414/how-to-stop-mysqld)。
