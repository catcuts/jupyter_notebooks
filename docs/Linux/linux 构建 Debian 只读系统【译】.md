

> [原文](https://wiki.debian.org/ReadonlyRoot#Enable_readonly_root)

# 构建 Debian 只读系统

　　文件层级结构标准（[FHS](https://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86)）允许用户将部分文件系统挂接为只读。这样做带来了一些好处，比如系统启动时对文件系统所做的检查会更少，以及在系统崩溃时无需对整个文件系统进行检查。
  
## 前提条件

　　FHS 允许将 `/bin`、`/lib`、`/sbin` 和 `/usr` 目录下所有子目录挂载为只读。但是你也可以对此做更进一步的扩展，即对各个子目录使用不同的文件系统，同时对一些特殊的文件予以特别的关照。
  
　　我们的只读系统中，有些目录是必须为可写的，它们是 `/etc`、`/home`、`/srv`、`/tmp`、`var`。而 `/dev` 目录下的子目录、`/proc`、`/selinux` 和 `/sys` 已经挂载为特殊的文件系统了。（译注：`/etc` 应该是部分可写，否则也不会有特别关照了）
  
　　对于 `/tmp`，你可以使用 tmpfs 文件系统，或者它自身的文件系统。而对于 `/var` 则应优先使用它自身的文件系统。下面是一个例子：
  
```shell
Device file      Filesystem     Mount point     RO/RW ?
/dev/sda1        ext2           /               RO 
/dev/sda2        ext3           /var            RW
...              tmpfs          /tmp            RW
/var/local/home  bind mount     /home           RW
/var/local/srv   bind mount     /srv            RW
```

　　对根目录 `/` 你可以挂载为不带日志（journal）的文件系统，这是因为你不会往上面写东西，所以你也不需要日志。也可以将其挂载为 ext4，这样你就能充分利用 ext4 的改良特性。创建这样的文件系统可以使用 `mke2fs -t ext4 -0 ^has_journal /dev/sda1`，或者通过 `tune2fs -O ^has_journal /dev/sda1` 来为此文件系统移除日志。（译注：两个命令可以参考 [google-search: tune2fs and mke2fs](https://www.google.com/search?ei=3FFYW5y5Kona8APSlKo4&q=tune2fs+and+mke2fs&oq=tune2fs+and+mke2fs&gs_l=psy-ab.3...7610.15719.0.16972.12.12.0.0.0.0.642.2135.3-1j0j3.4.0....0...1c.1.64.psy-ab..8.2.990...0i203k1j0i30k1j0i8i30k1.0.9gCSlG1tgb8)。另外，你应该将系统盘挂载到其他 linux 系统上，运行上述两条指令中的一个，并且注意，第一个是格式化，第二个是调整参数）

　　（译注：[使用 bind mount](https://unix.stackexchange.com/questions/198590/what-is-a-bind-mount)；[在 `/etc/fstab` 中使用 bind mount](https://serverfault.com/questions/613179/how-do-i-do-mount-bind-in-etc-fstab)）
  
## `/etc` 目录下的特殊文件

　　在 `/etc` 目录下有些文件你必须特别关注。它们是：
  
### adjtime

　　系统启动时会对它进行修改。见 bug ~~[156489](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=156489)~~

　　解决方法：创建从 `/etc/adjtime` 到 `/var/local/adjtime` 的符号连接；同时：

1. 在 `/etc/init.d/hwclockfirst.sh` 和 `/etc/init.d/hwclock.sh` 中，将 `HWCLOCKPARS` 变量设置为 `--noadjfile`；或者
<br><br>
2. 修改 `/etc/init.d/hwclockfirst.sh`，将语句 `if [ -w /etc ] && [ ! -f /etc/adjtime ] && [ ! -e /etc/adjtime ]; then` 中的 `-f` 改为 `-L`，见 ~~[520606](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=520606)~~。

### init.d/alsa-utils

　　[alsa-utils](https://packages.debian.org/alsa-utils) 在 alsa-utils/1.0.27.2-1 (@2013-10-25 兼容 wheezy) 之前的所有版本的启动脚本都会创建一个 `/.pulse` 文件，这就会导致当安装了 pulseaudio 时会多次出现错误信息 “Failed to create secure directory”。相关 bug [712980](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=712980)。
  
### blkid.tab

　　系统运行时会通过[libblkid1](https://packages.debian.org/search?keywords=libblkid1)对它进行修改。
  
　　解决方法：你不能创建一个从 `tc/blkid.tab` 到 `/var/local/blkid.tab` 的符号连接就了事，这是因为，很不幸的是，[libblkid1](https://packages.debian.org/search?keywords=libblkid1) 会忽视这个符号连接。因为 libblkid1 在每次需要写入时，都会用一个文件将这个符号连接给替换掉，当然前提是文件系统挂载为可写（比如在 `apt-get install` 的时候）。绕过这个设定的办法是：将环境变量 `BLKID_FILE` 设置为 `/var/local/blkid.tab`。你应该到 `/etc/environment` 里面，为所有可能进行挂载操作的用户设置这个环境变量。
  
### courier imap

　　Courier IMAP（译注：一种邮件系统，支持 IMAP 交互邮件访问协议）会使用一个文本文件（`/etc/courier/shared/index`）来提供快速的用户的检索，特别是作为一个邮件服务器提供虚拟邮箱服务时（不过针对 pam 的认证，其默认配置不受此影响）。
  
　　当通过共享账户使用虚拟邮箱时，这个文件就会被移动到其他地方，而目录 `/var/cache/courier/shared/` 就会被启用，但前提是你必须手动创建。
  
　　做完这个后，更新一下 `/etc/courier/imapd` 的内容，将 `IMAP_SHAREDINDEXFILE` 的值改为 `/etc/courier/shared/index`。
  
　　详见 [http://www.courier-mta.org/imap/README.sharedfolders.html](http://www.courier-mta.org/imap/README.sharedfolders.html) 获取更多关于该设置的信息。

### cups

　　[CUPS](https://zh.wikipedia.org/wiki/CUPS)（译注：Common Unix Printing System，UNIX通用打印系统）将各种类型的状态文件存储在 `/etc` 目录下（如 `classes.conf`, `cupsd.conf`, `printers.conf` 和 `subscriptions.conf` 等），这种设定毫无改变的余地（译注：原文是 *and upstream is against any modification*，其中 *upstream* 指的应该是软件——即 CUPS——的开发组。参考：[Wiki: Upstream](https://en.wikipedia.org/wiki/Upstream_(software_development))）。

　　相关 bug：[549673](https://bugs.debian.org/549673)
  
### lvm

　　lvm 分别在 `/etc/lvm/backup` 和 `/etc/lvm/archive` 存储文件系统中当前元数据的备份和历史元数据的归档（译注：元数据可以理解成等效于视窗操作系统下的文件属性。参考：[google-search: lvm 元数据](https://www.google.com/search?q=lvm+%E5%85%83%E6%95%B0%E6%8D%AE&oq=lvm+%E5%85%83%E6%95%B0%E6%8D%AE&aqs=chrome..69i57.3286j0j1&sourceid=chrome&ie=UTF-8)）。这就造成任何试图更改元数据的操作（vgreduce，vgextend，lvcreate，lvremove，lvresize，等等）都会失败，这就是因为在操作过程中系统的根目录 `/` 没有挂载为读写。
  
　　解决方法：备份和归档的位置是在 `/etc/lvm/lvm.conf` 中指定的。所以：设置 `backup_dir = "/var/backups/lvm/backup"`，以及 `archive_dir = "/var/backups/lvm/archive"`，然后创建目录 `/var/backups/lvm` 并把 `/etc/lvm/backup` 和 `/etc/lvm/archive` 移动到这边来。
  
　　注意：lvm 通常会在系统启动时创建备份。但这样的事情不会再发生了，因为它很机智地意识到 `/var` 还没被挂载（或挂载成了只读）。虽然如此，但是除非你使用的是[集群 lvm](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/lvm_cluster_overview)，否则 lvm 就肯定会给你做当前的备份，而这个备份，正是从你上一次对元数据做出修改开始的。所以，不会有事的。
  
　　相关 bug：[372207](https://bugs.debian.org/372207)、[562234](https://bugs.debian.org/562234) (关于 [etckeeper](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/lvm_cluster_overview) 涉及到 LVM 文件的行为详见 [462355](https://bugs.debian.org/462355))
  
### mtab

　　mount 用到这个文件。

　　解决方法：创建从 `/etc/mtab` 到 `/proc/self/mounts` 的符号连接。
  
　　注意，mount.cifs（从 smbfs 2:3.4.3-1 开始）会无视这个符号连接，并将其替换为一个真实的文件，详见 ~~[408394](https://bugs.debian.org/408394)~~。
  
　　另外，每一个 FHS 2.3 文件系统的 `mtab` 都位于 `/etc` 底下主要是出于历史遗留的原因。
  
### network/run

　　Debian Squeeze 及以下版本的 ifupdown 会用到这个文件。
  
　　解决方法：利用 ifupdown 的特性，即：当 `/etc/network/run` 不是一个目录时，就将 `/etc/network/run` 链接到 `/run/network`。所以：

```shell
rm -rf /etc/network/run
dpkg-reconfigure ifupdown
```

　　还可以：创建一个从 `/etc/network/run` 到 `/lib/init/rw/etc-network-run` 的符号连接（不论 `/var` 是否已经被挂载，ifupdown 的初始化脚本都会访问 `network/run`，所以我们用到了 `/lib/init/rw`，[虽然这么做有点滥用这个目录](https://via.hypothes.is/https://serverfault.com/questions/30819/what-is-the-use-of-lib-init-rw-in-debian)）。
  
　　Wheezy 版本会自动使用 `/network/run`，它不会在意实际的配置存放在哪里（译注：不论配置是存放在一个符号连接里，还是存放在一个文件里）。
  
　　相关 bug：[389996](https://bugs.debian.org/389996)
  
### nologin

　　系统启动过程中，初始化脚本 `bootmisc.sh` 和 `rmnologin` 会对该文件进行修改。

　　所以应该为它创建符号连接到 `/var/lib/initscripts/nologin`。
  
　　不过，Wheezy 版本直接修改的已经是 `/var/lib/initscripts/nologin` 了。
  
### resolv.conf

　　如果你使用的是静态的域名服务器配置（译注：也就是说，不会动态更改），那么不必关注。否则的话，你就需要使用 [resolvconf](https://packages.debian.org/search?keywords=resolvconf) 来进行动态配置。

### passwd，shadow

　　这两个文件在用户使用 chfn、chsh 和 passwd 时有可能会发生修改。如果你是这个系统的唯一用户，你可以在使用这些工具之前重新将文件系统挂载为读写模式。否则的话，你就要考虑使用 NIS 或 LDAP 了（译注：NIS——[网络信息服务](http://www.tldp.org/HOWTO/NIS-HOWTO/introduction.html)；LDAP——[轻目录访问协议](https://segmentfault.com/a/1190000002607140)。之所以要切换用户，为的无非是获取目标用户的资源和权限，NIS 和 LDAP 类似于实现对一些用户的资源和权限做了共享，可以通过共享的方式获取，而无需真正登录为目标用户）。
  
### samba/dhcp.conf

　　如果安装了 dhcp3-client（即众所周知的 isc-dhcp-client），那么每当建立了 DHCP 连接时， `/etc/dhcp3/dhclient-enter-hooks.d/samba` 都会创建 `/etc/samba/dhcp.conf`，不论使用与否，或者在与不在 `/etc/samba/smb.conf`。
  
　　相关 bug：[629406](https://bugs.debian.org/629406)。
  
### suck

　　[suck](http://www.linuxcertif.com/man/1/suck/) 将文件存放在 `/etc/suck` 目录下，并在运行时修改。见 [206631](https://bugs.debian.org/206631) 以避开此问题，简而言之你需要做的是：
  
- 移动所有 `/etc/suck/sucknewsrc*` 文件到一个新的目录 `/var/local/suck`，

- 创建符号连接从 `/etc/suck/suckkillfile` 到 `/var/local/suck/suckkillfile`，

- 在 `get-news.conf` 中把 `etcdir` 设置为 `/var/local/suck` (相当于永久设置了 suck 的 `-dd` 选项)

### udev

　　如果 udev 的规则 75-cd-aliases-generator.rules 和 75-persistent-net-generator.rules 是启用的话，udev 就会尝试修改 `/etc/udev/rules.d/` 目录下的 `70-persistent-cd.rules` 和 `70-persistent-net.rules`。所以推荐一次性把所需要的规则都创建了，然后禁用掉 `/etc/init.d/udev-mtab` 这个初始化脚本。这样，当根目录挂载为只读时，所需的规则已经被添加到 `/dev/udev/rules.d/` 目录下了。
  
## 启用 readonly root

　　要让你的根级文件系统挂载为只读，就必须在 `/etc/fstab` 中设置挂载选项为 `ro`：
  
```shell
# /etc/fstab: static file system information.
#
# <file system>     <mount point>   <type>  <options>                              <dump>  <pass>
/dev/hda1           /               ext2    defaults,noatime,ro,errors=remount-ro  0       1
/dev/hda4           /var            ext3    defaults                               0       2
```

　　其中 `noatime` 选项很有用，特别是在硬盘被挂载为读写模式的情况下更新数据时。
  
## 系统安装过程中启用 readonly root

　　注：在 2010-10-20 起发布的 Debian Squeeze 版本上测试通过。
  
　　（略。主要是安装过程中有一些选项，可以启用 readonly root，这样就无需做上述步骤）
  
## 小贴士和小技巧

### 在需要的时候让 apt-get 重新挂载根目录 `/`

　　要让 apt-get 在调用 dpkg 时自动重新挂载文件系统为读写，并且在 dpkg 调用结束时再将其挂载回只读，只需在 `/etc/apt/apt.conf` 中加入：
  
```shell
DPkg {
    // Auto re-mounting of a readonly /
    Pre-Invoke { "mount -o remount,rw /"; };
    Post-Invoke { "test {NO_APT_REMOUNT:-no} = yes || mount -o remount,ro / || true"; };
};
```

　　环境变量 `NO_APT_REMOUNT` 可以被设置为 `yes`，从而禁用 apt 重新挂载文件系统为只读。这样就很灵活，特别是当你打算对所安装的软件包进行配置，或者想要在 `/etc` 目录下做些改动时。
  
### 找出阻塞重新挂载为 readonly 的进程

　　在更新完一轮软件包后，你可能会面临一个问题，那就是 mount 拒绝重新挂载文件系统为只读，并告诉你 “`/ is busy`”。这是由于被移除的文件被进程占用着（译注：还放在内存里）。要想找出哪些进程使用着这些已删除的文件，可以使用软件 [debian-goodies](https://packages.debian.org/debian-goodies) 所带的工具 [checkrestart(1)](https://manpages.debian.org/man/1/checkrestart)，或者使用如下命令。通常被找出来的进程都是些守护进程，使用着被更新的库。你必须重启这些进程才能释放这些文件。
  
```shell
% {lsof +L1; lsof|sed -n '/SYSV/d; /DEL\|(path /p;'} |grep -Ev '/(dev|home|tmp|var)'
COMMAND     PID     USER   FD   TYPE DEVICE    SIZE NLINK   NODE NAME
login      1546     root    4r   REG    3,3    1331     0  66165 /etc/passwd (deleted)
startx     1587    joerg   10r   REG    3,3    4491     0 295122 /usr/bin/startx
xinit      1609    joerg  txt    REG    3,3   19084     0 295565 /usr/bin/xinit
zsh-beta   5058    joerg  txt    REG    3,3  628968     0 458849 /bin/zsh-beta
zsh-beta   5058    joerg   12r   REG    3,3  174728     0 205450 /usr/share/zsh-beta/functions/Completion.zwc
zsh-beta   5058    joerg   13r   REG    3,3 2221256     0 205405 /usr/share/zsh-beta/functions/Completion/Unix.zwc
zsh-beta   5058    joerg   14r   REG    3,3  237528     0 205398 /usr/share/zsh-beta/functions/Completion/Base.zwc
udevd       458       root  mem       REG        3,3              131417 /lib/libnss_files-2.7.so (path inode=140638)
udevd       458       root  mem       REG        3,3              131431 /lib/libnss_nis-2.7.so (path inode=140653)
udevd       458       root  mem       REG        3,3              131389 /lib/libnsl-2.7.so (path inode=140616)
udevd       458       root  mem       REG        3,3              131401 /lib/libnss_compat-2.7.so (path inode=140623)
udevd       458       root  mem       REG        3,3              131212 /lib/libdl-2.7.so (path inode=140598)
udevd       458       root  mem       REG        3,3              131159 /lib/libc-2.7.so (path inode=140581)
udevd       458       root  mem       REG        3,3              131089 /lib/ld-2.7.so (path inode=140572)
syslog-ng  1406       root  mem       REG        3,3              131417 /lib/libnss_files-2.7.so (path inode=140638)
syslog-ng  1406       root  mem       REG        3,3              131431 /lib/libnss_nis-2.7.so (path inode=140653)
syslog-ng  1406       root  mem       REG        3,3              131389 /lib/libnsl-2.7.so (path inode=140616)
syslog-ng  1406       root  mem       REG        3,3              131401 /lib/libnss_compat-2.7.so (path inode=140623)
syslog-ng  1406       root  mem       REG        3,3              131159 /lib/libc-2.7.so (path inode=140581)
syslog-ng  1406       root  mem       REG        3,3              131089 /lib/ld-2.7.so (path inode=140572)
```

## AUFS 方式制作只读系统

　　你可能对[这个](https://help.ubuntu.com/community/aufsRootFileSystemOnUsbFlash)也感兴趣。


```python
　　
```
