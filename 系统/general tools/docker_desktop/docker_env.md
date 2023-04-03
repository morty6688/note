### 配置

#### docker，k8s，helm 安装

- win10安装步骤：

  - (**下面内容deprecated**，现在直接使用代理启动k8s，默认wsl2后端) 

    ~~安装docker desktop后参照下面repo安装k8s，使用wsl2后端~~

    https://github.com/AliyunContainerService/k8s-for-docker-desktop

  - 换源：settings -> docker engine
  
    ```
    "registry-mirrors": [
        "https://docker.mirrors.ustc.edu.cn",
        "https://registry.docker-cn.com"
    ]
    ```

  - 限制内存使用：
  
    ```
    # powershell
    code ~/.wslconfig
    
    # 添加如下内容
    [wsl2]
    memory=4GB   # Limits VM memory in WSL 2 up to 4GB
    processors=4 # Makes the WSL 2 VM use 4 virtual processors
    
    # 然后重启
    ```
  
  - 安装helm：
  
    ```
    si helm lens
    ```
  
    - 开启kubectl自动补全（可能有性能问题）
  
      ```
      source <(kubectl completion zsh)
      echo 'alias k=kubectl' >>~/.zshrc
      echo 'complete -F __start_kubectl k' >>~/.zshrc
      ```

#### 数据库

##### mysql

1. ```
   docker run -itd --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mysql mysql
   ```

   - ```
     mysql -h localhost -u root -p
     ```

     ```
     create database test
     ```

     使用`show databases`查看全部数据库，`use test`切换到test数据库，`show tables`查看全部表

##### pg

1. ```
   docker run --name pg -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
   ```

   - ```
     psql -h localhost -U postgres -W
     ```

     ```
     CREATE DATABASE test;
     ```

     使用`\l`查看全部数据库，`\c test`切换到test数据库，`\dt`查看全部表

##### redis

1. ```
   docker run -id --restart=always --privileged=true --name=redis -p 6379:6379 redis --requirepass "redis"
   ```

   - ```
     scoop install another-redis-desktop-manager
     ```

#### 中间件

##### kafka

1. [docker-compose.yml](../resources/kafka/docker-compose.yml)

   - 在该文件目录运行如下第一条命令即可完成部署，可以通过java或其他客户端直接访问localhost:9092；运行第二条命令即可停止kafka

     ```
     docker-compose up -d
     docker-compose down
     ```

   - 部署一次后，可以直接在docker desktop里重启，关闭电脑也不会丢失镜像信息

2. 使用：

   - 建立topic

     ```
     docker exec broker kafka-topics --bootstrap-server broker:9092 --create --topic quickstart
     ```

   - topic list

     ```
     docker exec broker kafka-topics --bootstrap-server broker:9092 --list
     ```

   - topic详情

     ```
     docker exec broker kafka-topics --bootstrap-server broker:9092 --describe --topic quickstart
     ```
   
   - 删除topic
   
     ```
     docker exec broker kafka-topics --bootstrap-server broker:9092 --delete --topic quickstart
     ```
   
   - 写消息
   
     ```
     docker exec --interactive --tty broker kafka-console-producer --bootstrap-server broker:9092 --topic quickstart
     ```
   
   - 读消息
   
     ```
     docker exec --interactive --tty broker kafka-console-consumer --bootstrap-server broker:9092 --topic quickstart --from-beginning
     ```

##### ES

1. ```
   docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -d elasticsearch:7.2.0
   ```

   - 解决跨域问题：进入容器

     ```
     cd /usr/share/elasticsearch/config/
     vi elasticsearch.yml
     
     // 加入如下内容：
     http.cors.enabled: true
     http.cors.allow-origin: "*"
     ```

   - ik分词器安装：进入容器

     ```
     cd /usr/share/elasticsearch/plugins/
     elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.2.0/elasticsearch-analysis-ik-7.2.0.zip
     ```

   - kibana部署（ui界面）：

     ```
     docker run --name kibana --link=elasticsearch:test  -p 5601:5601 -d kibana:7.2.0
     ```

   - 简单示例（在idea中打开）：[es-demo.http](../resources/es/es-demo.http)

##### zk

1. ```
   docker run -d --name zk -p 2181:2181 zookeeper:3.5.8
   ```

   ```
   ./bin/zkCli.sh
   ```
   
   


### 问题

#### docker

- ##### 安装docker desktop里的k8s无限starting问题：

  - 按照k8s-for-docker-desktop里的解决，删除pki文件夹

  - hosts文件中添加

    ```
    # Kubernetes
    127.0.0.1 kubernetes.docker.internal
    ```

  - 如果hosts无法写入，只能重启


