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

#### 换源（不生效，待完善）

```
scoop config SCOOP_REPO https://gitee.com/squallliu/scoop
scoop config rm SCOOP_REPO
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

- 使用管理员权限安装anaconda（配合git bash还是有点问题）：

```
scoop install extras/anaconda3
```

然后打开anaconda prompt（使用zsh问题还是有点多）：

```
conda init zsh
```

然后改一下.zshrc，注掉自动生成的eval语句：

```
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval "$('/C/Users/lijian/scoop/apps/anaconda3/2022.05/Scripts/conda.exe' 'shell.zsh' 'hook')"
. /C/Users/lijian/scoop/apps/anaconda3/2022.05/etc/profile.d/conda.sh
# <<< conda initialize <<<
```

添加一个系统环境变量：

```
PYTHONIOENCODING -> utf_8_sig
```

修改conda.sh如下：



然后运行

```
conda config --set auto_activate_base false
```

- 使用如下命令代替 pip 命令，以解决 Fatal error in launcher: Unable to create process using '"'的问题：


```
python -m pip
```

换源：

```
# 清华源
python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 或：
# 阿里源
python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
# 腾讯源
python -m pip config set global.index-url http://mirrors.cloud.tencent.com/pypi/simple
# 豆瓣源
python -m pip config set global.index-url http://pypi.douban.com/simple/
```

安装后请运行install-pep-514.reg

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

