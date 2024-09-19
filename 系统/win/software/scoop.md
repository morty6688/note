## 介绍与使用

首先下载一个绿色版clash-verge/clash-for-win或其他代理软件，同步一下系统时间，卸载掉系统自带的终端，安装vscode

然后安装：https://github.com/ScoopInstaller/Install

### 使用方法

#### 前置工作

0. 搜狗输入法（语音输入总是出bug，这一部分换用讯飞）
   - 只开启系统功能快捷键-英文输入法(ctrl+shift+i)和语音输入(ctrl+shift+a)；调整字号适应高分屏；安装ahk后使用ahk禁用搜狗输入法的全部快捷键（ahk脚本里已经有了）：ctrl+句号等等；

1. ```
   scoop install git
   ```

   - [git配置与问题记录](../../general%20tools/git/config&problem.md)，完成基本配置
2. 代理

    ```
    scoop config proxy 127.0.0.1:1130
    scoop update
    ```

    ```
    scoop config rm proxy
    ```

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

   - powershell：更新时切换成windows自带的那个powershell去更新。同时记得设置两个powershell的别名，见[powershell](powershell.md)

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
# 有时候aria2会有问题
scoop config aria2-enabled false
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
  visualvm --jdkhome "C:\Users\morty\scoop\apps\ojdkbuild8\current"
  ```

  然后安装插件

##### python

- anaconda3：

  ```
  si extras/anaconda3
  conda init
  ```

  - 在.zshrc中添加下列语句，来解决zsh+bash无法激活环境的问题（参考[讨论](https://github.com/conda/conda/issues/9922)）：

    ```
    # anaconda3
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval "$('/c/Users/lijian/scoop/apps/anaconda3/current/App/Scripts/conda.exe' 'shell.zsh' 'hook' | sed -e 's/"$CONDA_EXE" $_CE_M $_CE_CONDA "$@"/"$CONDA_EXE" $_CE_M $_CE_CONDA "$@" | tr -d \x27\\r\x27/g')"
    # <<< conda initialize <<<
    
    export PYTHONIOENCODING=UTF-8
    ```

  - alias

    ```
    # anaconda alias
    alias c='conda'
    alias ci='conda install'
    alias cu='conda update'
    alias cr='conda remove'
    alias cl='conda list'
    alias ca='conda activate'
    alias cda='conda deactivate'
    alias cc='conda create --name'
    alias cr='conda remove --name'
    alias cel='conda env list'
    
    # pip
    alias pi='pip install'
    alias pl='pip list'
    ```

  - channel

    ```
    conda install -c conda-forge ta-lib
    ```

  - can't find conda.exe: find conda.sh in global win files and refer to [this](https://stackoverflow.com/questions/75639901/why-did-activating-the-conda-environment-fail)

  - 设置默认不开启环境：

    ```
    conda config --set auto_activate_base false
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

- 用nvm来管理node版本（nvm 1.1.12有bug，node 20.11.0是一个lts版本）

  ```
  si nvm@1.1.11
  ```

  ```
  nvm install v20.11.0
  ```

  ```
  nvm use 20.11.0
  ```

- 然后安装pnpm或yarn，或者直接使用npm

  ```
  # 查看npm全局包
  npm list -g
  ```
  
  ```
  # npm代理
  npm config set proxy http://127.0.0.1:1130
  npm config set https-proxy http://127.0.0.1:1130
  ```
  
  ```
  # pnpm代理
  npm install -g pnpm
  pnpm config set proxy http://127.0.0.1:1130
  pnpm config set https-proxy http://127.0.0.1:1130
  
  # pnpm alias
  alias pn='pnpm'
  alias pnl='pnpm list'
  alias pni='pnpm install'
  alias pnui='pnpm uninstall'
  alias pns='pnpm start'
  alias pnb='pnpm build'
  ```
  
  ```
  # yarn代理
  npm install -g yarn
  yarn config set proxy http://127.0.0.1:1130
  yarn config set https-proxy http://127.0.0.1:1130
  
  # yarn alias
  alias y='yarn'
  alias ys='yarn start'
  alias yb='yarn build'
  alias yl='yarn list'
  alias yi='yarn install'
  alias yui='yarn uninstall'
  ```

##### go

- ```
  si go
  ```

- 代理：

  ```
  go env -w GOPROXY=https://goproxy.cn,direct
  ```

  ```
  go env | grep GOPROXY
  ```

- win上兼容syscall，最好不要用这些信号量

  在types_windows.go里添加如下内容

  ```
  /* compatible with windows */
  	SIGUSR1 = Signal(16)
  	SIGUSR2 = Signal(17)
  	SIGTSTP = Signal(18)
  ```

- 安装protobuf的go生成工具，以及其他等等

  ```
  go install github.com/golang/protobuf/protoc-gen-go@latest
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  ```

- 安装[bloomrpc](https://github.com/bloomrpc/bloomrpc)。也可以直接使用idea自带的http client

- .zshrc设置：

  ```
  # go
  alias gmt='go mod tidy'
  ```


##### solidity

```
si solidity
```

##### rust

```
si rustup
```

#####  php

- 安装：

  ```
  si php composer php-xdebug
  ```

  ```
  composer config -g -- disable-tls true
  ```

- openssl：

  - 首先下载证书并放到相应位置：

    - 查看证书位置：

      ```
      php -r "print_r(openssl_get_cert_locations());"
      ```

    - 下载文件：http://curl.haxx.se/ca/cacert.pem

    - 修改php.ini：

      ```
      extension=php_openssl.dll
      openssl.cafile=C:\Program Files\Common Files\SSL\cacert.pem
      ```

- xdebug（修改php.ini，我真是服了，什么古代语言，debugger还需要自己设置）：

  ```
  implicit_flush = On
  
  [XDebug]
  ; Only Zend OR (!) XDebug
  zend_extension_ts="C:\Users\morty\scoop\apps\php-xdebug\current\php_xdebug.dll"
  xdebug.remote_enable=true
  xdebug.remote_host=localhost
  xdebug.remote_port=10000
  xdebug.remote_handler=dbgp
  ```

  

#### 环境

数据库及中间件见[docker_env](../../general%20tools/docker_desktop/docker_env.md)

### 常用软件安装

#### 日常使用

```
si everything autohotkey qbittorrent-enhanced pdf-xchange-editor telegram discord trafficmonitor firefox magpie
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

  - [让B站视频可以在mpv中播放](https://github.com/diannaojiang/Bilibili-Playin-Mpv)，导入[mpv.reg](resources/mpv.reg)
  - ~~进阶设置~~：https://bbs.acgrip.com/thread-7443-1-1.html

- icaros：使用管理员模式启动

- sharex：启动时会跟onedrive冲突快捷键。此时先关闭sharex，然后按截图键，在onedrive弹出的窗口中选择`no, thx!`，再启动sharex即可。onedrive没啥卵用，建议禁用开机自启


#### 编程相关

```
si tabby filezilla switchhosts rapidee telnet protobuf redis mysql make
```

- 装redis和mysql只为了使用他们的客户端测试docker或k8s组件的连接

- make需要设置以下path：`C:\Users\morty\scoop\apps\make\current\bin\make.exe`


#### 系统相关

```
si rufus dismplusplus hasher renamer locale-emulator recuva
```


### 暂未用 scoop

- 带自动更新或无法使用的
  - steam
  
  - chrome
  
    - 常见问题：
      - 屏幕闪烁：https://www.reddit.com/r/chrome/comments/15uuyry/artifactsflickering_on_chrome_w10/。解决办法：把angle显卡后端设为d3d9
  
  - vscode
  
  - idea
  
    - 常见问题：
  
      - winnat问题，重启网络（使用管理员模式）：
  
        ```
        net stop winnat
        net start winnat
        ```
      
        - IDEA有时会卡在开始界面无法启动，查idea.log发现是`java.net.BindException: *Address already in use*: *bind*`，这说明IDEA启动需要的端口被占用，使用该命令重启
      
        - 有时idea启动应用说端口被占用，但是使用`netstat -ano|findstr 8080 `结果为空，可能是端口处于tcp排除范围，使用`netsh interface ipv4 show excludedportrange protocol=tcp`可以看到排除范围，这时也可以用上述命令重启

      - 有时打开idea发现没有显示root目录：*File* → *Project Structure* → *Modules*, clicked on + and then *Import Module*, found root folder, selected it and it worked；或者删除.idea然后重启
      
      - 有时启动项目报一个奇怪的错类似`input length = 1`，需要修改file encoding项为utf-8，这个选项每次启动新项目都会重置，很奇葩

      - terminal修改path：`C:\Users\morty\scoop\apps\git\current\bin\bash.exe`，设置选中时复制

      - 其他设置可以直接同步
  
  - Logi Options+/G Hub
  - docker-desktop：用作开发环境配置，[docker_env](../../general%20tools/docker_desktop/docker_env.md)。这年头安装完还要重启系统的软件不多了。。。
  - bandizip：scoop下载的是绿色版，不能添加到资源管理器上下文菜单
    - 勾选文件关联 - 基本选项，取消勾选解压/压缩完成后不要关闭进度窗口
  - [UACWhitelistTool](https://github.com/XIU2/UACWhitelistTool)：uac白名单小程序，生成一个不启动uac的快捷方式，可以添加到右键菜单
  
  - [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher)：win11美化任务栏，卸载时把安装程序名改为ep_uninstall即可
  - translucenttb：下载windows store版。scoop下载的绿色版没有开机自启选项
    - 配合wallpaper engine一起用的话，将windows主题设置为深色，应用主题设置为浅色（个性化 - 颜色 - 选择模式 - 自定义）
  
  - feem：局域网全速传输文件。因为免费版默认目标文件夹是下载，建议把windows下载目录移动到D盘
  
  
  - potplayer：scoop下载的没有解码器，而且多了直播这个奇怪的功能
  
      - 开启电平控制
  - chatbox：配合AiHubMix的API Key使用
  - SnipDo和OpenAI Translator
  - watt-toolkit
  
  
  - [KBLAutoSwitch](https://github.com/flyinclouds/KBLAutoSwitch)：根据程序自动切换输入法，还有一些bug存在
  
- 付费：

  - displayfusion
    - 用鼠标中键来转移窗口，取消窗口上的小按钮
    - win11 - 使用经典上下文菜单（有待优化）
    - 关闭 `任务栏 - 在每个显示器上启用任务栏`，启动系统自带的`在所有显示器上显示任务栏`
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
  - PICO 互联
  - pdf 补丁丁
  - 游戏加加
  

## 问题

### Git相关

- error: Your local changes to the following files would be overwritten by merge:

  - 解决办法

    ```
    s bucket rm main
    s bucket add main
    sup
    ```
