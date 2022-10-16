## 介绍与使用

介绍：https://sspai.com/post/52710

安装：

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex
```

### 使用方法

#### 添加仓库+设置别名

```
# .zshrc里添加scoop别名
alias s='scoop'
alias sup='scoop update'
alias ss='scoop update && scoop status'
alias sl='scoop list'
alias se='scoop serach'
alias si='scoop install'
alias sui='scoop uninstall'
alias scu='scoop cleanup'

scoop bucket add java
scoop bucket add main
scoop bucket add extras
scoop bucket add dorado
scoop bucket add ash258.ash258
scoop bucket add sushi https://github.com/kidonng/sushi
```

#### 安装 aria2

```
scoop install aria2
scoop config aria2-split 32
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 1M
```

#### 代理

```
scoop config proxy 127.0.0.1:10809
```

```
scoop config rm proxy
```

```
scoop update
```

#### 更新

```
scoop list
scoop update
# 列出全部可更新软件
scoop status
# 全部更新
scoop update -a

# 禁止某个软件更新
scoop hold git
# 取消
scoop unhold git
```

#### 清除缓存（安装失败时清除残留）

```
scoop cache
scoop cache rm qbittorrent
scoop cache rm -a
```

#### 删除旧版本

```
scoop cleanup -a
```

#### 软件信息

```
scoop info openjdk
```

### 开发工具安装

#### 语言

##### java

```
scoop install git
```

- Git Bash设置如下：

​		[Git Bash设置](../../general%20tools/git/git_bash.md)

​		其他关于git的问题参考该文件：[git配置与问题记录](../../general%20tools/git/config&problem.md)

```
scoop install openjdk
```

```
scoop install maven
```

- 换源（~/.m2）：

​	https://maven.aliyun.com/

​	[settings.xml](resources/settings.xml)

- 3.8.1以上版本禁用https：

  ```xml
  <mirror>
      <id>maven-default-http-blocker</id>
      <mirrorOf>!*</mirrorOf>
      <url>http://0.0.0.0/</url>
  </mirror>
  ```

```
si gradle
```

- 换源（~/.gradle）：

​	[gradle.properties](resources/gradle.properties)

##### python

- 使用管理员权限安装anaconda：

```
scoop install extras/anaconda3
```

然后初始化（win上git_bash+zsh使用conda命令行有很多bug，建议使用powershell）：

```
conda init
```

conda换源（~/.condarc)：

```
channels:
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
show_channel_urls: true
auto_activate_base: false
report_errors: true
```
然后可以用idea创建conda环境

- 使用如下命令代替 pip 命令，以解决 Fatal error in launcher: Unable to create process using '"'的问题：


```
python -m pip
```

pip代理（win在用户目录下新建pip/pip.ini文件）：

```
[global]
proxy     = 127.0.0.1:10809 
[install]
```

- cuda和cuDNN（版本要匹配）

```
si cuda
```

```
scoop bucket add cudnn-versions https://github.com/shmishtopher/cudnn-versions
si cuDNNv8.6.0-CUDAv11.8-windows
# 如果安装不成功，将cuDNN压缩包中的bin、include、lib目录下的文件解压到cuda文件夹下的对应目录
# 然后执行下面命令删掉压缩包
sui cuDNNv8.6.0-CUDAv11.8-windows
```

##### go

```
scoop install go
```

换源（三选一）：

```
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
go env -w GOPROXY=https://goproxy.io,direct
```

```
go env | grep GOPROXY
```

##### js

```
 si nodejs
```

#### 环境

数据库及中间件见[docker_env](../../general%20tools/docker_desktop/docker_env.md)

### 常用软件安装

#### 日常使用

- everything

  ```
  scoop install everything
  ```

  - 设置中选中开机自启动，everything服务，去掉以管理员模式运行；设置显示窗口快捷键（Alt+F），并集成到资源管理器右键菜单

- ```
  scoop install trafficmonitor
  ```

- autohotkey2（需要手动安装）：

  ```
  scoop install autohotkey2
  ```

  - 使用如下设置，并将快捷方式放到Windows启动目录：

    [AHK启动脚本](ahk.md)

- ```
  scoop install qbittorrent-enhanced
  ```

  - 行为：设置开机自启动，启动时最小化，最小化到系统托盘
  - Bittorrent：设置做种限制
  
- ```
  scoop install pdf-xchange-editor
  ```

  - 勾选打开上次的文件，设置 Esc 键为选择文本快捷键
  
- ```
  si clash-for-windows
  ```
  
  - 一些uwp应用比如微软商店可能会打不开，需要添加`UWP Loopback`。

#### 图像影音

- ```
  scoop install sharex
  ```

- ```
  scoop install imageglass
  ```

- ```
  scoop install screenoff
  ```

  ```
  scoop install ffmpeg
  ```

- ```
  scoop install screentogif
  ```

- ```
  scoop install neteasemusic
  ```

- mpv：

  ```
  scoop install mpv
  scoop install yt-dlp
  ```

  - 后续设置：https://bbs.acgrip.com/thread-7443-1-1.html

  icaros：使用管理员模式启动

  ```
  scoop install icaros-np
  ```

- potplayer：（参考：https://zhuanlan.zhihu.com/p/33615747，配置真是麻烦，最后画质提升了一丢丢）

   ```
   si potplayer
   si lavfilters
   si madvr
   si xysubfilter
   ```

   

#### 编程相关

- ```
  scoop install mobaxterm
  ```

- ```
  scoop install typora
  ```

  - [typora配置](../../general%20tools/typora.md)
  
- ```
  scoop install filezilla
  ```

- ```
  scoop install switchhosts
  ```

#### 系统相关

- ```
  scoop install rufus
  ```

- ```
  scoop install dismplusplus
  ```

#### 游戏相关

- ```
  scoop install steampp
  ```

#### 国内软件

- ```
  scoop install wechat
  ```

### 其他

- 暂未用 scoop
  - steam
  - mouseinc
  - chrome
  - vscode
  - idea
  - kodi
  - Logi Options+
  - docker-desktop
  - bandizip：scoop下载的是绿色版，不能添加到资源管理器上下文菜单
    - 勾选文件关联 - 基本选项，取消勾选解压/压缩完成后不要关闭进度窗口
- 付费：

  - displayfusion
  - directory opus
  - quicker
- 国内：
  - 火绒
  - pico 串流助手
  - 115
  - pdf 补丁丁

## 问题

### Git相关

- error: Your local changes to the following files would be overwritten by merge:

  - 解决办法

    ```
    scoop bucket rm main
    scoop bucket add main
    scoop update
    ```

- 

