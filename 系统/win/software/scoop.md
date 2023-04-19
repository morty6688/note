## 介绍与使用

首先下载一个绿色版clash-for-windows，同步一下系统时间，卸载掉系统自带的终端，安装vscode

然后安装：https://github.com/ScoopInstaller/Install

### 使用方法

#### 前置工作

0. 搜狗输入法
   - 使用ahk禁用搜狗输入法的全部快捷键：ctrl+句号等等；只开启系统功能快捷键-英文输入法(ctrl+shift+i)；调整字号适应高分屏

1. ```
   scoop install git
   ```

   - [git配置与问题记录](../../general%20tools/git/config&problem.md)，完成基本配置

2. 添加仓库

   ```
   scoop bucket add java
   scoop bucket add main
   scoop bucket add versions
   scoop bucket add extras
   scoop bucket add nonportable
   scoop bucket add dorado https://github.com/chawyehsu/dorado
   ```

3. ```
   scoop install windows-terminal powershell typora
   ```

   - [git配置与问题记录](../../general%20tools/git/config&problem.md)，完成进阶配置

   - [win terminal配置](win_terminal.md)

   - [typora配置](../../general%20tools/typora.md)

   - powershell：更新时切换成windows自带的那个powershell去更新

   - 用scoop来管理clash：
   
     - ```
       scoop install clash-for-windows
       ```
     - 一些uwp应用比如微软商店可能会打不开，需要添加`UWP Loopback`，例如`你的账户`这个程序，不添加到loopback可能会造成登录异常。
     - `allow LAN`功能开启后，点击旁边的图标查看192.168开头的局域网地址，可以让局域网内其他设备使用代理。比如给switch添加代理，修改其网络设置将上述局域网地址和代理端口加上即可。


#### 设置别名

- ~/.zshrc里添加scoop别名

```
# scoop alias
alias s='scoop'
alias sup='scoop update'
alias ss='scoop update && scoop status'
alias sl='scoop list'
alias se='scoop search'
alias si='scoop install'
alias sui='scoop uninstall'
alias scu='scoop cleanup'
```

#### 安装 aria2

```
si aria2
s config aria2-split 32
s config aria2-max-connection-per-server 16
s config aria2-min-split-size 1M
```

#### 代理

```
s config proxy 127.0.0.1:1130
```

```
s config rm proxy
```

```
sup
```

#### 更新

```
sl
# 列出全部可更新软件
ss
# 全部更新
sup -a

# 禁止某个软件更新
s hold git
# 取消
s unhold git
```

#### 清除缓存（安装失败时清除残留）

```
s cache
s cache rm qbittorrent
s cache rm -a
```

#### 删除旧版本

```
scu -a
```

#### 软件信息

```
s info openjdk
```

### 开发工具安装

#### 语言

##### java

```
si openjdk maven gradle
```

- maven换源（~/.m2）：

  - ~~3.8.1以上版本禁用https：~~

  ```xml
  <mirror>
      <id>maven-default-http-blocker</id>
      <mirrorOf>!*</mirrorOf>
      <url>http://0.0.0.0/</url>
  </mirror>
  ```

  - 阿里云仓库：[链接](https://maven.aliyun.com/)
  - 配置文件：[settings.xml](resources/settings.xml)

- gradle换源（~/.gradle）：

​		[gradle.properties](resources/gradle.properties)

##### python

- conda：

  - 使用管理员权限安装，然后初始化（win上git_bash+zsh使用conda命令行无法激活环境，详见[讨论](https://github.com/conda/conda/issues/9922)。建议使用idea直接创建conda环境，避免命令行激活。conda solving environment是真的慢，不如用venv）

    ```
    si extras/anaconda3
    conda init
    ```

  - 换源（~/.condarc)：

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

- venv

  ```
  si python310
  ```

  - 直接使用idea创建环境
  
  - pip代理
  
    ```
    code pip/pip.ini
    ```
    
    ```
    [global]
    proxy     = 127.0.0.1:1130 
    [install]
    ```
    


- cuda和cuDNN（不一定要装，更多的是用在虚拟环境中，可以添加下面的bucket，方便查看cudnn版本）

  ```
  si cuda
  s bucket add cudnn-versions https://github.com/shmishtopher/cudnn-versions
  si cuDNNv8.6.0-CUDAv11.8-windows
  # 如果安装不成功，将cuDNN压缩包中的bin、include、lib目录下的文件解压到cuda文件夹下的对应目录
  # 然后执行下面命令删掉压缩包
  sui cuDNNv8.6.0-CUDAv11.8-windows
  ```

##### js/ts

```
si nodejs pnpm yarn
pnpm setup

# 代理
npm config set proxy http://127.0.0.1:1130
npm config set https-proxy http://127.0.0.1:1130

yarn config set proxy http://127.0.0.1:1130
yarn config set https-proxy http://127.0.0.1:1130

pnpm config set proxy http://127.0.0.1:1130
pnpm config set https-proxy http://127.0.0.1:1130
```

##### go

```
si go
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

#### 环境

数据库及中间件见[docker_env](../../general%20tools/docker_desktop/docker_env.md)

### 常用软件安装

#### 日常使用

```
si everything autohotkey qbittorrent-enhanced pdf-xchange-editor telegram discord wechat trafficmonitor
```

- everything->工具->选项：

  - 常规->选中随系统自启动，everything服务，集成到右键菜单；去掉以管理员模式运行；
  - 界面->选中单击托盘图标打开搜索窗口，自动聚焦于输入框
  - 结果->选中搜索关键词为空时不显示搜索结果，双击路径列打开目录
  - 视图->选中高亮光标经过行，显示大小，选中数量等等
  - 快捷键->显示窗口快捷键（Alt+F）
  - 索引->选中索引文件夹大小

- autohotkey：

  - 使用如下设置，并将快捷方式放到Windows启动目录：
  
    [AHK启动脚本](ahk.md)

- qbittorrent-enhanced：
  
  - 行为：设置启动时最小化，最小化到系统托盘
  - Bittorrent：设置做种限制
  
- pdf-xchange-editor：
  
  - 勾选文档 - 打开上次的文档，设置 Esc 键为选择文本快捷键（右键工具栏 - 命令 - 搜索），页面显示 - 默认缩放 - 适合宽度

#### 图像影音

```
si sharex imageglass screenoff ffmpeg screentogif neteasemusic qqmusic mpv yt-dlp icaros-np potplayer extras/kodi twinkle-tray obs-studio
```

- mpv：

  - [让B站视频可以在mpv中播放](https://github.com/diannaojiang/Bilibili-Playin-Mpv)，替换[mpv.reg](resources/mpv.reg)
  - ~~进阶设置~~：https://bbs.acgrip.com/thread-7443-1-1.html

- icaros：使用管理员模式启动

- sharex：启动时会跟onedrive冲突快捷键。此时先关闭sharex，然后按截图键，在onedrive弹出的窗口中选择`no, thx!`，再启动sharex即可

- ~~potplayer提高画质~~：（参考：https://zhuanlan.zhihu.com/p/33615747，配置真是麻烦，最后画质提升了一丢丢，**不如不配**，而且最后的xysubfilter的manifest已经被移除）

   ```
   si sushi/lavfilters madvr xysubfilter
   ```


#### 编程相关

```
si mobaxterm filezilla switchhosts rapidee chatgpt
```


#### 系统相关

```
si rufus dismplusplus hasher
```

#### 游戏相关

```
si steampp neteaseuu
```



### 暂未用 scoop

- 带自动更新或无法使用的
  - steam
  - chrome
  - vscode
  - idea
  - Logi Options+/G Hub
  - docker-desktop：用作开发环境配置，[docker_env](../../general%20tools/docker_desktop/docker_env.md)。这年头安装完还要重启系统的软件不多了。。。
  - bandizip：scoop下载的是绿色版，不能添加到资源管理器上下文菜单
    - 勾选文件关联 - 基本选项，取消勾选解压/压缩完成后不要关闭进度窗口
  - [UACWhitelistTool](https://github.com/XIU2/UACWhitelistTool)：uac白名单小程序，生成一个不启动uac的快捷方式，可以添加到右键菜单
  - [BingGPT](https://github.com/dice2o/BingGPT)
  - [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher)：win11美化任务栏，卸载时把安装程序名改为ep_uninstall即可
  - translucenttb：下载windows store版。scoop下载的绿色版没有开机自启选项
    - 配合wallpaper engine一起用的话，将windows主题设置为深色，应用主题设置为浅色
  
  - feem：局域网全速传输文件。因为免费版默认目标文件夹是下载，建议把windows下载目录移动到D盘
  
  
  
  
  - AnyTXT
  - [KBLAutoSwitch](https://github.com/flyinclouds/KBLAutoSwitch)：根据程序自动切换输入法，还有一些bug存在
  
- 付费：

  - displayfusion
    - 用鼠标中键来转移窗口，取消窗口上的小按钮
    - win11 - 使用经典上下文菜单
  - directory opus
  - quicker
  
- 国内：
  - 搜狗输入法
  - mouseinc
  - 火绒
  - TIM，qq广告和bug太多
  - 115
  - 图吧工具箱
  - pico 串流助手
  - pdf 补丁丁


## 问题

### Git相关

- error: Your local changes to the following files would be overwritten by merge:

  - 解决办法

    ```
    s bucket rm main
    s bucket add main
    sup
    ```

- 

