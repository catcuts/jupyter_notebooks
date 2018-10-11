

**系统：**

Linux -- Deepin 15.5

不知道为什么搜狗拼音开始无法切换中文，但是在极个别软件中是可以正常切换和输入中文的，比如有道词典。

**解决方案：**
```shell
cd ~/.config
```

删除config中文搜狗拼音的配置文件
```shell
rm -r SogouPY SogouPY.users sogou-qimpanel
```

卸载 搜狗拼音
```shell
sudo apt-get remove sogoupinyin  或者 sudo apt-get remove sogoupinyin --purge
```

重新安装搜狗拼音
```shell
sudo dpkg -i (搜狗拼音XXX).deb
```
重启就行了。

