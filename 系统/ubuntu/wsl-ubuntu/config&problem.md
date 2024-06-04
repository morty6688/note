### 配置

#### 基本配置

- 查看，安装，关机以及注销版本

  ```
  wsl -l -v
  ```

  ```
  wsl --install -d Ubuntuwsl --install -d Ubuntu
  ```

  ```
  wsl --shutdown
  ```

  ```
  wsl --unregister Ubuntu
  ```

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

- 与win共享：

  - windows中访问wsl文件：资源管理器地址栏输入`\\wsl$`

  - wsl中访问windows文件：`/mnt/c/desktop/tool`



#### 软件安装

- 安装zsh和p10k：见git篇
- 


### 问题

1. vscode修改文件没有权限的问题：

   ```
   sudo chown -R morty /etc/wsl.conf
   # or
   sudo chmod 777 /etc/wsl.conf
   ```

2. wsl: 检测到 localhost 代理配置，但未镜像到 WSL。NAT 模式下的 WSL 不支持 localhost 代理（这个有bug，见https://github.com/microsoft/WSL/issues/11085）

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

