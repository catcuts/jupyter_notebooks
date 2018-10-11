


　　**备份**（前提：系统盘（或小型系统的 SD 卡）挂载到其他 linux 系统，设备为：`/dev/sdx`）

```shell
sudo dd if=/dev/sdx | gzip>/path/to/bkupfile.gz
```

　　**还原**（前提：空卡格式化后，挂载到存储着备份的 linux 系统，设备为：`/dev/sdy`）

```shell
sudo gzip -dc /path/to/bkupfile.gz | sudo dd of=/dev/sdy
```
