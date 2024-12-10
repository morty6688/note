### 配置

#### 基本配置

- 查看当前安装，列出所有发行版，安装，关机以及注销版本

  ```
  wsl -l -v
  ```

  ```
  wsl -l -o
  ```

  ```
  wsl --install -d Ubuntu
  ```

  ```
  wsl --shutdown Ubuntu
  ```

  ```
  wsl --unregister Ubuntu
  ```

- 与win共享：

  - windows中访问wsl文件：资源管理器地址栏输入`\\wsl$`

  - wsl中访问windows文件：`/mnt/c/desktop/tool`

- 设置`networkingMode=mirrored`，见下文（设置之后host的代理可以穿透到wsl，如果不行，注销ubuntu重装安装）


#### 常用命令

- 添加root用户密码，可以使用`su`命令切换到root用户：

  ```bash
  sudo passwd root
  ```

- 端口占用查看及kill：

  ```
  sudo lsof -i :8080
  kill -9 <PID>
  ```

- 系统：

  ```
  lsb_release -cdir
  ```

#### 软件安装

- 安装zsh和p10k：[zsh](../../general%20tools/git/config&problem.md#进阶配置)

- 开发工具
  - jdk8：
  
    - https://stackoverflow.com/questions/57107129/how-to-install-oracle-java-8-on-ubuntu-18-04
  
      ```
      wget https://github.com/frekele/oracle-java/releases/download/8u212-b10/jdk-8u212-linux-x64.tar.gz
      sudo mkdir /usr/lib/jvm-oracle
      sudo cp jdk-8u212-linux-x64.tar.gz /usr/lib/jvm-oracle 
      cd /usr/lib/jvm-oracle
      sudo tar -xvzf jdk-8u212-linux-x64.tar.gz
      cd jdk1.8.0_212
      sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm-oracle/jdk1.8.0_212/bin/java 1
      sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm-oracle/jdk1.8.0_212/bin/javac 1
      sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm-oracle/jdk1.8.0_212/bin/javaws 1
      ```

### 问题

1. vscode修改文件没有权限的问题：

   ```
   sudo chown -R morty /etc/wsl.conf
   # or
   sudo chmod 777 /etc/wsl.conf
   ```

2. wsl: 检测到 localhost 代理配置，但未镜像到 WSL。NAT 模式下的 WSL 不支持 localhost 代理

   - 创建wslconfig：

      ```bash
      code $USERPROFILE/.wslconfig
      ```
      
      ```
      [experimental]
      autoMemoryReclaim=gradual  # gradual  | dropcache | disabled
      networkingMode=mirrored
      dnsTunneling=true
      firewall=true
      autoProxy=true
      hostAddressLoopback=true
      ```
   
3. ~~开启wslg的systemd~~（会导致docker desktop 4.18.0的版本无法启动）

   - ```
     cd /etc
     touch wsl.conf
     sudo chmod 777 /etc/wsl.conf
     code /etc/wsl.conf
     ```

   - 然后添加下面内容到wsl.conf

     ```
     [boot]
     systemd=true
     ```

