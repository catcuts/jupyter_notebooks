

> [参考](https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script)

　　示例：

```shell
echo -e "[ info ] 创建新分区 ..."
    (
    echo p # show current partition table
    echo n # Add a new partition
    echo p # Primary partition
    echo   # Partition number (Accept default: 3)
    echo   # First sector (Accept default: 1)
    echo   # Last sector (Accept default: varies)
    echo w # Write changes
    ) | sudo fdisk
echo -e "[ info ] 创建新分区 完毕 ."
```

