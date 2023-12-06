## 介绍与使用

首先下载一个绿色版clash-verge或其他代理软件，同步一下系统时间，卸载掉系统自带的终端，安装vscode

然后安装：https://github.com/ScoopInstaller/Install

### 使用方法

#### 前置工作

0. 搜狗输入法
   - 使用ahk禁用搜狗输入法的全部快捷键：ctrl+句号等等；只开启系统功能快捷键-英文输入法(ctrl+shift+i)和语音输入(ctrl+shift+a)；调整字号适应高分屏

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

   - clash设置：
   
     - 一些uwp应用比如微软商店可能会打不开，需要添加`UWP Loopback`，例如`你的账户`这个程序，不添加到loopback可能会造成登录异常。cv需要下载网络回环管理器来应对这个，cfw不需要
     - cfw：`allow LAN`功能开启后，点击旁边的图标查看192.168开头的局域网地址，可以让局域网内其他设备使用代理。比如给switch添加代理，修改其网络设置将上述局域网地址和代理端口加上即可。


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

#### 注意事项

- 可以用类似`scoop reset openjdk`来切换像java一样的开发工具版本

#### 按语言

##### java

```
si oraclejdk-lts ojdkbuild8 openjdk17 maven gradle visualvm
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

- gradle换源（放到gradle user home/.gradle）：

​		[gradle.properties](resources/gradle.properties)

- visualvm启动：

  ```
  visualvm --jdkhome "C:\Users\lijian\scoop\apps\ojdkbuild8\current"
  ```

  然后安装插件

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

- 用nvm来管理node版本（首先安装一个最新的lts版本）

  ```
  si nvm
  nvm install v18.18.0
  nvm use 18.18.0
  ```

- 然后安装pnpm或yarn，或者直接使用npm

  ```
  # 代理和镜像
  npm config set proxy http://127.0.0.1:1130
  npm config set https-proxy http://127.0.0.1:1130
  
  yarn config set proxy http://127.0.0.1:1130
  yarn config set https-proxy http://127.0.0.1:1130
  
  pnpm config set proxy http://127.0.0.1:1130
  pnpm config set https-proxy http://127.0.0.1:1130
  
  # pnpm alias
  alias p='pnpm'
  alias pi='pnpm install'
  alias pl='pnpm list'
  alias pui='pnpm uninstall'
  ```

##### go

- ```
  si go
  ```

- 换源：

  ```
  go env -w GOPROXY=https://goproxy.cn,direct
  ```

  ```
  go env | grep GOPROXY
  ```

- 下载依赖

  ```
  go mod download
  ```

- win上兼容syscall，最好不要用这些信号量

  在types_windows.go里添加如下内容

  ```
  /* compatible with windows */
  	SIGUSR1 = Signal(16)
  	SIGUSR2 = Signal(17)
  	SIGTSTP = Signal(18)
  ```

- 安装protobuf的go生成工具

  ```
  go install github.com/golang/protobuf/protoc-gen-go@latest
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  ```


##### solidity

```
si solidity
```

##### rust

```
si rustup
```

#### 环境

数据库及中间件见[docker_env](../../general%20tools/docker_desktop/docker_env.md)

### 常用软件安装

#### 日常使用

```
si everything autohotkey qbittorrent-enhanced pdf-xchange-editor telegram discord trafficmonitor
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
  
  - 勾选文档 - 打开上次的文档；页面显示 - 默认缩放 - 适合可见；页面显示 - 默认页面设置 - 连续；
  - 设置 Esc 键为选择文本快捷键（右键工具栏 - 命令 - 搜索”选择文本“）；设置`键为打字机工具

#### 图像影音

```
si sharex imageglass screenoff ffmpeg screentogif neteasemusic qqmusic mpv yt-dlp icaros-np extras/kodi twinkle-tray obs-studio mkvtoolnix
```

- mpv：

  - [让B站视频可以在mpv中播放](https://github.com/diannaojiang/Bilibili-Playin-Mpv)，替换[mpv.reg](resources/mpv.reg)
  - ~~进阶设置~~：https://bbs.acgrip.com/thread-7443-1-1.html

- icaros：使用管理员模式启动

- sharex：启动时会跟onedrive冲突快捷键。此时先关闭sharex，然后按截图键，在onedrive弹出的窗口中选择`no, thx!`，再启动sharex即可




#### 编程相关

```
si tabby filezilla switchhosts rapidee chatgpt telnet protobuf
```


#### 系统相关

```
si rufus dismplusplus hasher renamer locale-emulator recuva
```

#### 游戏相关

```
si steampp
```

### 暂未用 scoop

- 带自动更新或无法使用的
  - steam
  - chrome
  - vscode
    - tabnine：全局搜索tabnine_config.json，修改一项设置`"inline_suggestions_mode": false`
  - idea
  
    - 常见问题：
  
      - winnat问题，重启网络（使用管理员模式）：
  
        ```
        net stop winnat
        net start winnat
        ```
      
        - IDEA有时会卡在开始界面无法启动，查idea.log发现是`java.net.BindException: *Address already in use*: *bind*`，这说明IDEA启动需要的端口被占用，使用该命令重启
      
        - 有时idea启动应用说端口被占用，但是使用`netstat -ano|findstr 8080 `结果为空，可能是端口处于tcp排除范围，使用`netsh interface ipv4 show excludedportrange protocol=tcp`可以看到排除范围，这时也可以用上述命令重启
  
      - 有时打开idea发现没有显示root目录：*File* → *Project Structure* → *Modules*, clicked on + and then *Import Module*, found root folder, selected it and it worked.
      
      - 有时启动项目报一个奇怪的错类似`input length = 1`，需要修改file encoding项为utf-8，这个选项每次启动新项目都会重置，很奇葩
  
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
  
  
  - potplayer：scoop下载的没有解码器，而且多了直播这个奇怪的功能
  
      - 开启电平控制
  
  
  - [KBLAutoSwitch](https://github.com/flyinclouds/KBLAutoSwitch)：根据程序自动切换输入法，还有一些bug存在
  
- 付费：

  - displayfusion
    - 用鼠标中键来转移窗口，取消窗口上的小按钮
    - win11 - 使用经典上下文菜单
  - directory opus
  - quicker
  
- 国内：
  
  - wechat
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

