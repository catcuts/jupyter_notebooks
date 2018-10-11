

> [参考](https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor)

```shell
# 把配置内容都导出到 mycron 临时文件
crontab -l > mycron

# 追加你的新任务
echo "00 09 * * 1-5 echo hello" >> mycron

# 应用新的配置
crontab mycron

# 移除临时文件
rm mycron
```

