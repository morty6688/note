介绍：https://sspai.com/post/52710

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
   # 列出全部可更新软件
   scoop status
   # 全部更新
   scoop update '*'
   
   # 禁止某个软件更新
   scoop hold git
   # 取消
   scoop unhold git
   ```

5. 清除缓存（安装失败时清除残留）

   ```
   scoop cache show
   scoop cache rm qbittorrent
   scoop cache rm '*'
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
   scoop install openjdk17
   ```

   ```
   scoop bucket add main
   scoop install maven
   ```

   https://maven.aliyun.com/

   [settings.xml](settings.xml)

2. python

   ```
   scoop install python
   ```

   使用如下命令代替pip命令，以解决Fatal error in launcher: Unable to create process using '"'的问题：

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

   

3. go

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

   

4. mysql

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

   

5. redis

   ```
   
   ```

   

6. zookeeper

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

7. kafka

   ```
   scoop install kafka
   ```

   
