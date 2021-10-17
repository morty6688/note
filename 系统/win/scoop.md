启动：

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex
```

预备工作：

1. ```
   scoop install aria2
   scoop config aria2-split 32
   scoop config aria2-max-connection-per-server 16
   scoop config aria2-min-split-size 1M
   ```
   
2. 代理
   
   ```
   scoop config proxy 127.0.0.1:10809
   ```
   
   ```
   scoop config rm proxy
   ```

   ```
   scoop update
   ```
   
3. 换源（不生效，待完善）

   ```
   scoop config SCOOP_REPO https://gitee.com/squallliu/scoop
   scoop config rm SCOOP_REPO
   scoop update
   ```

4. 更新

   ```
   scoop list
   scoop update
   scoop status
   scoop update '*'
   ```

5. 清除缓存（安装失败时清除残留）

   ```
   scoop cache show
   scoop cache rm qbittorrent
   ```


6. 删除旧版本

   ```
   scoop cleanup '*'
   ```

   



开发工具安装，其他工具见[此处](./常用软件/即装即用.md)：

1. java

   ```
   scoop install git
   ```

   ```
   scoop bucket add java
   scoop install openjdk11
   ```

   ```
   scoop bucket add main
   scoop install maven
   ```

   https://maven.aliyun.com/

2. python

   ```
   scoop install python
   ```

3. mysql

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

