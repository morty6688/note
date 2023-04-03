### 配置

https://github.com/microsoft/wslg

#### 基本配置

- 设置默认用户

  ```
  ubuntu2004 config --default-user lijian
  ```

- 添加用户并赋权：

  ```
  sudo passwd root
  adduser lijian
  su 
  passwd lijian
  adduser lijian sudo
  ```

- 开启wslg的systemd

  - ```
    sudo chmod 777 /etc
    code /etc/wsl.conf
    ```

  - 然后添加下面内容到wsl.conf

    ```
    [boot]
    systemd=true
    ```

- 换源（更新失败时将https换为http）：

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

#### 中间件安装

1. ##### ~~kafka安装及启动~~（建议使用docker）

   参考：https://dcrunch.dev/blog/kafka/set-up-and-run-apache-kafka-on-windows-wsl-2/#dc-install-java
   
   及该站点下其他kafka相关文章，还有官方文档

```bash
wget https://downloads.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz
tar -zxf kafka_2.13-3.0.0.tgz
cd kafka_2.13-3.0.0

# 运行zookeeper
bin/zookeeper-server-start.sh config/zookeeper.properties

# 启动kafka broker在另一个终端
bin/kafka-server-start.sh config/server.properties
```

```bash
# 正常情况下的命令
# 创建topic
bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic quickstart-events --partitions 3 --replication-factor 1

# 列出所有topic
bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

# topic详情
bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic quickstart-events

# 删除topic
bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic quickstart-events

# 生产
bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092

# 消费，可以被多个客户端消费无限次
bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
```

​		**但是由于在WSL2中安装kafka时，localhost无法正确映射，导致idea访问不到。所以要将localhost改为ipv6环回地址，即::1。**具体方法如下：

​		注：zsh无法解析方括号[]，所以命令行中加方括号要转义，添加反斜杠\

```
# 修改配置文件
code config/server.properties
listeners=PLAINTEXT://[::1]:9092
```

```bash
# 创建topic
bin/kafka-topics.sh --bootstrap-server ::1:9092 --create --topic quickstart-events --partitions 3 --replication-factor 1

# 列出所有topic
bin/kafka-topics.sh --bootstrap-server ::1:9092 --list

# topic详情
bin/kafka-topics.sh --bootstrap-server ::1:9092 --describe --topic quickstart-events

# 删除topic
bin/kafka-topics.sh --bootstrap-server ::1:9092 --delete --topic quickstart-events

# 生产
bin/kafka-console-producer.sh --bootstrap-server ::1:9092 --topic quickstart-events

# 消费，可以被多个客户端消费无限次
bin/kafka-console-consumer.sh --bootstrap-server ::1:9092 --from-beginning --topic quickstart-events
```


### 问题

1. 关于使用WSL2出现“参考的对象类型不支持尝试的操作”的解决方法：

   https://zhuanlan.zhihu.com/p/151392411

   [NoLsp.exe](NoLsp.exe)

2. vscode修改文件没有权限的问题：

   ```
   sudo chown -R lijian /etc/fstab
   ```

   
