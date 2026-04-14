# Scoop

### 基本安装

安装（ powershell 1.0 里运行，不需要管理员权限）：

```
irm get.scoop.sh | iex
```

0. ```
    scoop install git powershell windows-terminal
    ```

    - [git配置与问题记录](../../general%20tools/git/config&problem.md)，完成基本配置
    - [win terminal配置](win_terminal.md)，完成win terminal的设置
    
1. 代理

    ```
    scoop config proxy 127.0.0.1:1130
    scoop update
    ```

    - 取消代理

      ```
      scoop config rm proxy
      ```

2. 添加仓库

   ```
   scoop bucket add java
   scoop bucket add versions
   scoop bucket add extras
   scoop bucket add nonportable
   scoop bucket add dorado https://github.com/chawyehsu/dorado
   scoop bucket add lemon https://github.com/hoilc/scoop-lemon
   scoop bucket add nirsoft-alternative https://github.com/ScoopInstaller/Nirsoft.git
   ```
   
3. 进阶配置
   
   - [git配置与问题记录](../../general%20tools/git/config&problem.md)，完成进阶配置
   - powershell：更新时切换成 powershell 1.0 去更新。同时记得设置两个powershell的别名，见[powershell](powershell.md)
   - 在vs code里select default profile：git bash

#### 安装 aria2

```
si aria2
s config aria2-split 32
s config aria2-max-connection-per-server 16
s config aria2-min-split-size 1M
```

- 有时候aria2会有问题：

  ```
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
sho git
# 取消
suh git
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

```
si oraclejdk-lts maven gradle visualvm python nvm go protobuf solidity rustup
```

#### 具体语言配置

##### java

- 历史遗留oracle-jdk1.8：https://github.com/frekele/oracle-java/releases/tag/8u202-b08

- maven换源（~/.m2）：

  - 阿里云仓库：[链接](https://maven.aliyun.com/)
  - 配置文件：[settings.xml](resources/settings.xml)

- gradle代理（放到gradle user home/.gradle）：[gradle.properties](resources/gradle.properties)

- （可选）visualvm启动：

  ```
  visualvm --jdkhome "C:\Users\morty\scoop\apps\ojdkbuild8\current"
  ```

  然后安装插件

##### python

- 安装其他版本python

  ```
  si python310
  ```

- venv

  - 直接使用ai助手或者ide来创建环境
  
  - ~~pip代理~~
  
    ```
    code pip/pip.ini
    ```
  
    ```
    [global]
    proxy     = 127.0.0.1:1130 
    [install]
    ```
  
- （可选，venv也够用了）anaconda3：

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


- （可选）cuda和cuDNN（不一定要装，一般用不到这么底层的东西。更多的是用在虚拟环境中，可以添加下面的bucket，方便查看cudnn版本）

  ```
  si cuda
  s bucket add cudnn-versions https://github.com/shmishtopher/cudnn-versions
  si cuDNNv8.6.0-CUDAv11.8-windows
  # 如果安装不成功，将cuDNN压缩包中的bin、include、lib目录下的文件解压到cuda文件夹下的对应目录
  # 然后执行下面命令删掉压缩包
  sui cuDNNv8.6.0-CUDAv11.8-windows
  ```

##### js/ts

- **用nvm来管理node版本**

  ```
  nvm install lts
  nvm use lts
  ```

- 然后安装pnpm或yarn（优先用pnpm，切换node版本后将这些都重装一遍）

  - 查看npm全局包

    ```
    npm list -g
    ```

  - npm代理

    ```
    npm config set proxy http://127.0.0.1:1130
    npm config set https-proxy http://127.0.0.1:1130
    ```

    - 取消代理

      ```
      npm config rm proxy
      npm config rm https-proxy
      ```

  - ~~镜像~~

    ```
    npm config set registry https://registry.npmmirror.com
    ```

  - pnpm

    ```
    npm install -g pnpm
    ```

    - 代理

      ```
      pnpm config set proxy http://127.0.0.1:1130
      pnpm config set https-proxy http://127.0.0.1:1130
      ```

      - 取消代理

        ```
        pnpm config delete proxy
        pnpm config delete https-proxy
        ```

    - 缓存清除（适用于下载不完整的时候，比如electron postinstall失败）

      ```
      pnpm store prune
      ```

  - yarn

    ```
    npm install -g yarn
    ```

    - 代理

      ```
      yarn config set proxy http://127.0.0.1:1130
      yarn config set https-proxy http://127.0.0.1:1130
      ```

      - 取消代理

        ```
        yarn config delete proxy
        yarn config delete https-proxy
        ```

  - bun

    ```
    npm install -g bun
    ```

    - 升级

      ```
      bun upgrade
      ```

  - nestjs

    ```
    npm i -g @nestjs/cli
    ```

  - electron（记得改mirror，win上build要提权）

    ```
    pnpm create @quick-start/electron
    ```

  - vue

    ```
    pnpm create vue@latest
    ```

- 配置：

  ```
  pna vite-plugin-vue-devtools unplugin-vue-setup-extend-plus unplugin-auto-import vite-plugin-compression vite-plugin-svg-icons @vitejs/plugin-vue-jsx vite-plugin-compression2 @eslint/eslintrc
  ```

  - `unplugin-auto-import`：

    - js环境：`vite.config.js`中添加以下代码

      ```js
      AutoImport({
        imports: ['vue'],
        dts: false,
        eslintrc: {
          enabled: true,
        },
      }),
      ```

      `eslint.config.js/mjs`中添加以下代码，以禁用 ESLint对auto import的error of no-undef

      ```js
      import { FlatCompat } from '@eslint/eslintrc'
      
      const compat = new FlatCompat()
      
      export default [
        // existing contents
        ...compat.extends('./.eslintrc-auto-import.json')
      ]
      ```

    - ts环境：修改`vite.config.ts`中`dts`为`true`或者`'src/auto-imports.d.ts'`，会自动生成类型文件；`eslint.config.js/mjs`中同样添加上面代码；同时在`tsconfig.app.json`的`include`项中添加配置：`"*.d.ts"`

- 问题：

  - idea控制台有时会输出乱码，在package.json中添加`chcp 65001 &&` 切换

##### go

- 代理：

  ```
  go env -w GOPROXY=https://goproxy.cn,direct
  ```

  - 查看代理

    ```
    go env | grep GOPROXY
    ```

  - 取消代理

    ```
    go env -w GOPROXY=direct
    ```

- 安装protobuf的go生成工具，以及其他等等

  ```
  go install github.com/golang/protobuf/protoc-gen-go@latest
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  ```

- 安装[bloomrpc](https://github.com/bloomrpc/bloomrpc)。也可以直接使用ide自带的http client

- （可选）历史版本：

  ```
  si go@1.20
  ```

- （兼容）win上兼容syscall，最好不要用这些信号量

  在types_windows.go里添加如下内容

  ```
  /* compatible with windows */
  	SIGUSR1 = Signal(16)
  	SIGUSR2 = Signal(17)
  	SIGTSTP = Signal(18)
  ```


#####  php（可选）

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

#### docker环境

- 安装[docker-desktop](https://www.docker.com/products/docker-desktop/)
  - 把前面的装完再装这个，这个装完会重启系统并安装wsl
  - 数据库及中间件配置见[docker_env_win](../../general%20tools/docker_desktop/docker_env_win.md)

#### 编程相关scoop软件

```
si filezilla make pandoc latex switchhosts telnet innounp orange dbeaver
```

- 其他可选：tabby

#### 注意事项

- 可以用类似`scoop reset openjdk`来切换像java一样的开发工具版本（24/12/10切换失败）


### 其他

- idea（vibe coding大环境下，不确定以后还需不需要用）

  - 常见问题：

    - winnat问题，重启网络（使用管理员模式）：

      ```
      net stop winnat
      net start winnat
      ```
    
      - IDEA有时会卡在开始界面无法启动，查idea.log发现是`java.net.BindException: *Address already in use*: *bind*`，这说明IDEA启动需要的端口被占用，使用该命令重启
    
      - 有时idea启动应用说端口被占用，但是使用`netstat -ano|findstr 8080 `结果为空，可能是端口处于tcp排除范围，使用`netsh interface ipv4 show excludedportrange protocol=tcp`可以看到排除范围，这时也可以用上述命令重启

      - 改变某个文件夹的分隔符：*File* → *File Properties*→ *Line Separators*，重新格式化也可以在右键菜单里找到
    
    - 有时打开idea发现没有显示root目录：*File* → *Project Structure* → *Modules*, clicked on + and then *Import Module*, found root folder, selected it and it worked；**或者删除.idea然后重新右键菜单打开当前项目，不要从idea的最近项目里打开**

    - 有时启动项目报一个奇怪的错类似`input length = 1`，需要修改file encoding项为utf-8，这个选项每次启动新项目都会重置，很奇葩

    - terminal修改path：`C:\Users\morty\scoop\apps\git\current\bin\bash.exe`，设置选中时复制
    
    - 其他设置可以直接同步

- [~~KBLAutoSwitch~~](https://github.com/flyinclouds/KBLAutoSwitch)：根据程序自动切换输入法，还有一些bug存在

## 问题

### Git相关

- error: Your local changes to the following files would be overwritten by merge:

  - 解决办法

    ```
    s bucket rm main
    s bucket add main
    sup
    ```

### Chrome：

- 屏幕闪烁：https://www.reddit.com/r/chrome/comments/15uuyry/artifactsflickering_on_chrome_w10/。解决办法：把angle显卡后端设为d3d9。**该问题似乎已修复**。
