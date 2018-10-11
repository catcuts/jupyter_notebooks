
# Orange Pi GPIO 串口通讯
## ——安装并使用 Linux 原生工具测试 与 Nodejs SerialPort 开发的过程


## 目录

　　**[1. 安装 gcc 4.8 和 g++ 4.8](#1.-安装-gcc-4.8-和-g++-4.8)**

　　**[2. 启用 GPIO 串口](#2.-启用-GPIO-串口)**

　　**[3. 测试 GPIO 串口](#3.-测试-GPIO-串口)**

　　**[4. 安装 nodejs](#4.-安装-nodejs)**

　　**[5. 安装 serialport ](#5.-安装-serialport)**

　　**[6. 开发示例](#6.-开发示例)**


### 准备工作

- 创建一个用户：`add user`

- 切换到用户文件夹：`cd /home/catcuts`

- 编辑：`nano /etc/sudoers` 并保存

> 在如下地方的下一行，添加 `catcuts ALL=(ALL:ALL) ALL` 并换行
> ```shell
> # User privilege specification
root    ALL=(ALL:ALL) ALL
> ```

- 修改系统参数：`echo "vm.mmap_min_addr = 4096" >  /etc/sysctl.d/mmap_min_addr.conf`

- 重启：`reboot`


### 1. 安装 gcc 4.8 和 g++ 4.8

- 请按照这个步骤：[GCC 4.8 ON RASPBERRY PI WHEEZY](https://somewideopenspace.wordpress.com/2014/02/28/gcc-4-8-on-raspberry-pi-wheezy/)

　　**注意**：最后一步不用做：
> If you want to change it, you can ...

- 检查 `gcc -v && g++ -v`

>```shell
>root@orangepi:/home/catcuts# gcc -v && g++ -v
...（略）
gcc version 4.8.4 (Raspbian 4.8.4-1) 
...（略）
gcc version 4.8.4 (Raspbian 4.8.4-1) 
>```

- 还原软件源
  - `sudo mv /etc/apt/preferences /etc/apt/preferences.bkup`
  - `sudo nano /etc/apt/sources.list` 修改全部内容为：  

```shell
deb http://mirrors.aliyun.com/raspbian/raspbian/ jessie main non-free contrib rpi
deb-src http://mirrors.aliyun.com/raspbian/raspbian/ jessie main non-free contrib rpi
```
  - `sudo apt-get udpate`


### 2. 启用 GPIO 串口

- 查看是否已启用：`ls /dev/ttyS*` 是否有 `/dev/ttyS1` 如果有则已启用，跳到第 2 步。否则：

- 安装编译依赖：`apt-get install -y libusb-1.0-0-dev`；

- 安装工具链：`git clone git://github.com/linux-sunxi/sunxi-tools.git`；

- 编译工具链：`cd sunxi-tools` 然后 `make`；完后：`cd ..`；

- 复制：`cp /boot/script.bin ./script.bin`，不要影响源文件即可；

- 备份：`cp ./script.bin ./script.bin.bkup`，保险起见；

- 转换格式：`./sunxi-tools/bin2fex ./script.bin > ./script.fex` （出现 warning 可以忽略）

- 编辑：`nano ./script.fex` 找到如下：

```bash
[uart1]
uart_used = 0
uart_port = 1
uart_type = 4
uart_tx = port:PG06<2><1><default><default>
uart_rx = port:PG07<2><1><default><default>
uart_rts = port:PG08<2><1><default><default>
uart_cts = port:PG09<2><1><default><default>
```
改为：
（注：其中 uart_type 指的是 串口通讯的线制。这里采用的是 2 线制度，所以删掉了后面两行。如果你用的是 4 线制，则保留。）
```bash
[uart1]
uart_used = 1
uart_port = 1
uart_type = 2
uart_tx = port:PG06<2><1><default><default>
uart_rx = port:PG07<2><1><default><default>
```
保存；

- 转回格式：`./sunxi-tools/fex2bin ./script.fex > ./script.bin`（出现 warning 可以忽略）‘

- 覆盖原文：`cp ./script.bin /boot/script.bin`；

- 重启：`reboot`；

- 查看是否已启用：`ls /dev/ttyS*` 是否有 `/dev/ttyS1` 如果有则已启用，跳到第 2 步。否则：异常。

- 切换到用户文件夹：`cd /home/catcuts`


### 3. 测试 GPIO 串口

- 安装：`sudo apt-get install -y minicom screen`

- `mimicom -s` 设置串口

- `screen /dev/ttyS1 <波特率 与对方匹配>` 以接收来自串口 S1 的数据（注：串口数据一旦被取走，就没有了，意味着一个串口只能分给一个程序接收，先到先得）

- `echo '要发送的数据' > /dev/ttyS1` 以发送数据到串口 S1

注：可以开两个窗口，便于观察。注意：出现全 0 或 <break\> 都是异常。


### 4. 安装 nodejs

注：版本以 10.5.0 为例。

- 下载：`wget https://nodejs.org/dist/latest-v10.x/node-v10.5.0-linux-armv7l.tar.gz`；

- 解压：`tar xvzf node*`；

- 切换用户：`su catcuts`；

- 创建文件夹：`sudo mkdir /opt/node`；

- 安装：`sudo cp -a /home/catcuts/node*/* /opt/node`；

- 退出：`exit`；

- 设置 root 用户的路径：

```bash
echo "PATH=$PATH:/opt/node/bin" >> /root/.profile
echo "export PATH" >> /root/.profile
PATH=$PATH:/opt/node/bin
export PATH
```

- 检验：`node -v` 无异常 然后 `npm -v` 也无异常；则成功，否则：异常。

- 切换用户：`su catcuts`；

- 设置 catcuts 用户的路径：

```bash
echo "PATH=$PATH:/opt/node/bin" >> /home/catcuts/.profile
echo "export PATH" >> /home/catcuts/.profile
PATH=$PATH:/opt/node/bin
export PATH
```

- 检验：`node -v` 无异常 然后 `npm -v` 也无异常；则成功，否则：异常。

---
注：环境部署到此位置，后面为开发。

### 5. 安装 serialport 

- 创建 `mkdir /home/catcuts/serialport_demo` 并进入 `cd /home/catcuts/serialport_demo`；

- 初始化：`npm init`；

- 安装：`npm install serialport` （注意，最好不要以 root 身份安装）。


### 6. 开发示例

- 官方网站：[node-serialport Github](https://github.com/node-serialport/node-serialport#opening-a-port) 和 [node-serialport Document](https://node-serialport.github.io/node-serialport/)


- 开发示例：（另一方可以用 `cutecom` 进行相应的收发数据）

```javascript
function startSending() {
  var time = 0;

  console.log('started')

  setTimeout(function again() {
    console.log('again');
    port.write(String(time)+'\n', function(err) {
      console.log('sent')
      if (err) {
        return console.log('Error on write: ', err.message);
      }
      console.log('message written' + time);
      time++;
      setTimeout(again, 1000);
    });
  }, 1000);
};

var SerialPort = require('serialport');
var port = new SerialPort('/dev/ttyS1', {
  baudRate: 115200
});

port.on('data', function (data) {
  console.log('Data:', data.toString("hex"));
});

// Read data that is available but keep the stream from entering "flowing mode"
port.on('readable', function () {
  console.log('Data:', port.read());
});

startSending();

```

`*END*`

### 其它事项

- [扩容](https://blog.csdn.net/hirvonen/article/details/50899985)

- [安装 python3.6](https://liftcodeplay.com/2017/06/30/how-to-install-python-3-6-on-raspbian-linux-for-raspberry-pi/)

[TOP](#Orange-Pi-GPIO-串口通讯)
