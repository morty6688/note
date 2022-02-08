### 介绍与启动

介绍：https://sspai.com/post/52710

启动：

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex
```

### 使用方法

#### 0. 添加仓库

```
scoop bucket add java
scoop bucket add main
scoop bucket add extras
scoop bucket add dorado
scoop bucket add ash258.ash258
```

#### 1. 安装 aria2

```
scoop install aria2
scoop config aria2-split 32
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 1M
```

#### 2. 代理

```
scoop config proxy 127.0.0.1:10809
```

```
scoop config rm proxy
```

```
scoop update
```

#### 3. 换源（不生效，待完善）

```
scoop config SCOOP_REPO https://gitee.com/squallliu/scoop
scoop config rm SCOOP_REPO
scoop update
```

#### 4. 更新

```
scoop list
scoop update
# 列出全部可更新软件
scoop status
# 全部更新
scoop update '*'

# 禁止某个软件更新
scoop hold git
# 取消
scoop unhold git
```

#### 5. 清除缓存（安装失败时清除残留）

```
scoop cache show
scoop cache rm qbittorrent
scoop cache rm '*'
```

#### 6. 删除旧版本

```
scoop cleanup '*'
```

#### 7. 软件信息

```
scoop info openjdk
```

### 开发工具安装

#### 1. java

```
scoop install git
```

- Git Bash设置如下：

​		[Git Bash设置](git_bash.md)

​		其他关于git的问题参考该文件：[git配置与问题记录](../../../系统/通用工具/git/config&problem.md)

```
scoop install openjdk17
```

```
scoop install maven
```

- 换源：

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

#### 2. python

```
scoop install python
```

使用如下命令代替 pip 命令，以解决 Fatal error in launcher: Unable to create process using '"'的问题：

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

#### 3. go

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

#### 4. mysql

```
scoop install mysql
```

```powershell(管理员)
# 注册为服务
mysqld --install MySQL
# 删除服务
mysqld -remove MySQL
# 启动服务
net start MySQL
# 停止服务
net stop MySQL
```

```
# 修改密码
mysqladmin -uroot -p password
```

```
# 关闭计划任务
控制面板-搜索计划任务-MySQL-Installer-先导出后删除
```

#### 5. zookeeper

```
 scoop install zookeeper
```

启动：

```
# 启动zookeeper，无需start，直接运行
zkserver
# 启动客户端
zkcli
# 创建节点
create /node value
# 获取节点的值
get /node
# 设置节点的值
set /node newValue
# 删除节点
delete /node
```

### 常用软件安装

#### 1. 日常使用

- everything

  ```
  scoop install everything
  ```

  - 设置开机自启动和显示窗口快捷键（Alt+F），并集成到资源管理器右键菜单

- ```
  scoop install trafficmonitor
  ```

- autohotkey：使用管理员模式运行

  ```
  scoop install autohotkey-installer
  ```

  - 使用如下设置，并将快捷方式放到Windows启动目录：

    [AHK启动脚本](ahk.md)

- ```
  scoop install qbittorrent
  ```

- ```
  scoop install bandizip
  ```

  - 勾选文件关联 - 基本选项，取消勾选解压/压缩完成后不要关闭进度窗口

- ```
  scoop install pdf-xchange-editor
  ```

  - 勾选打开上次的文件，设置 Esc 键为选择文本快捷键

#### 2. 图像影音

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

#### 3. 编程相关

- ```
  scoop install mobaxterm
  ```

- ```
  scoop install typora
  ```

  - [typora配置](typora.md)
  
- ```
  scoop install filezilla
  ```

- ```
  scoop install switchhosts
  ```

#### 4. 系统相关

- ```
  scoop install rufus
  ```

- ```
  scoop install dismplusplus
  ```

#### 5. 游戏相关

- ```
  scoop install steampp
  ```

#### 6. 国内软件

- ```
  scoop install neteaseuu
  ```

- ```
  scoop install wechat
  ```

- ```
  scoop install neteasemusic
  ```

### 其他

- 暂不方便用 scoop

  - steam
  - mouseinc
  - v2rayn
  - chrome
  - vscode
  - idea
  - kodi
  - potplayer
  - docker-desktop

- 付费：

  - displayfusion
  - directory opus
  - quicker

- 国内：

  - 火绒

  - pico 串流助手

  - 115

  - pdf 补丁丁
