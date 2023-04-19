### 配置

https://github.com/microsoft/wslg

```
wsl --install -d Ubuntu
```

#### 基本配置

- 添加用户并赋权：

  ```
  sudo passwd root
  su 
  ```

- ~~开启wslg的systemd~~（会导致docker desktop 4.18.0的版本无法启动）

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

- ~~换源（更新失败时将https换为http）~~目前看来不需要了

  ```
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.copy
  ```

​		https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/

- 端口：

  ```
  netstat -ap
  ```

- 系统：

  ```
  lsb_release -a
  uname -a
  ```


### 问题

1. vscode修改文件没有权限的问题：

   ```
   sudo chown -R lijian /etc/wsl.conf
   # or
   sudo chmod 777 /etc/wsl.conf
   ```

   

