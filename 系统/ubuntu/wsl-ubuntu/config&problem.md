### 配置

#### 1. 基本配置

1. 设置默认用户

```
ubuntu2004 config --default-user lijian
```

2. 添加用户并赋权：

```bash
sudo passwd root
adduser lijian
su 
passwd lijian
adduser lijian sudo
```

3. 换源（更新失败时将https换为http）：

```bash
sudo chmod 777 /etc/apt/sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.copy
```

​	https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/

4. Java:

```bash
sudo apt install openjdk-11-jdk maven
```

​	https://zhuanlan.zhihu.com/p/369912485

5. 端口：netstat -ap
6. 系统：

```bash
lsb_release -a
uname -a
```

#### 2. 中间件安装

1. ##### kafka安装及启动

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




### 问题

1. 关于使用WSL2出现“参考的对象类型不支持尝试的操作”的解决方法：

   https://zhuanlan.zhihu.com/p/151392411

   [NoLsp.exe](NoLsp.exe)

2. 

