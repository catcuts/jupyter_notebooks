

　　设置

```shell
git config --global http.proxy 'socks5://127.0.0.1:1080'
git config --global https.proxy 'socks5://127.0.0.1:1080'
```

　　确认
  
```shell
git config -l
```

　　取消

```shell
git config --global --unset http.proxy
git config --global --unset https.proxy
```

　　[参考](https://gist.github.com/laispace/666dd7b27e9116faece6)

　　备忘：如果要在 win 上使用，记得将 shadowsocks 代理设置为 git 代理，或设置为全局代理。
