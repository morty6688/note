## 配置

### docker，k8s，helm, istio 安装

- 安装docker desktop，启用k8s

- 安装其他附加软件：

  ```
  si helm openlens istioctl
  ```

- zsh自动补全（可能有性能问题）

  - 在.zshrc文件中添加如下命令：

    ```
    # k8s
    alias k=kubectl
    complete -F __start_kubectl k
    ```

  - 然后需要自动补全的shell里执行

    ```
    source <(kubectl completion zsh)
    ```

- 安装istio配置档

  ```
  istioctl install
  ```

## 常用命令

- 入门Dockerfile示例：

  - 使用maven

    ```dockerfile
    FROM openjdk:21
    
    RUN apk update
    RUN apk add maven
    
    # maven换源
    ADD settings.xml /root/.m2/settings.xml
    
    WORKDIR /app
    
    COPY pom.xml ./
    RUN mvn dependency:go-offline
    
    COPY src ./src
    CMD ["mvn", "spring-boot:run"]
    ```

  - 或者使用jar包

    ```dockerfile
    FROM openjdk:17-alpine3.14
    
    ADD hello-world-0.0.1-SNAPSHOT.jar /
    
    EXPOSE 8080
    
    ENTRYPOINT ["java", "-jar","/hello-world-0.0.1-SNAPSHOT.jar"]
    ```

  - go语言

    ```dockerfile
    # Create build stage based on buster image
    FROM golang:1.20-alpine3.17 AS builder
    # Create working directory under /app
    WORKDIR /app
    # Copy over all go config (go.mod, go.sum etc.)
    COPY go.* .
    # Install any required modules
    RUN go mod download
    # Copy over Go source code
    COPY *.go .
    # Run the Go build and output binary under hello_world
    RUN go build -o hello-world .
    # Make sure to expose the port the HTTP server is using
    EXPOSE 8080
    # Run the app binary when we run the container
    CMD ./hello-world
    ```

- 构建命令

  ```
  docker build -t java-docker .
  ```

- 运行命令

  ```
  docker run -dp 8080:8080 java-docker
  ```

  - -d表示以守护态运行，-p表示发布到端口

- 容器和宿主机数据拷贝

  ```
  docker cp seata-server:/seata-server/resources ./
  ```

- 挂载宿主机目录

  ```
  docker run -v /c/shared/seata/config/resources:/seata-server/resources seataio/seata-server:1.7.1
  ```

- 查看容器内部ip（<container_id>通过`docker ps`查看）

  ```
  docker inspect <container_id> | grep IPAddress
  ```

- 容器重启策略：https://docs.docker.com/config/containers/start-containers-automatically/

  - ```
    docker update --restart always mysql
    ```
    
    ```
    docker update --restart no mysql
    ```

## 常用组件

mall项目docker-compose示例：

```
docker-compose -f mall.yml -p mall up -d
```

[mall-docker-compose.yml](resources/compose_file/mall.yml)

### 数据库

#### MySQL

- ```
   docker run -itd --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --restart always mysql
   ```

   - ```
     mysql -hlocalhost -uroot -p
     create database test
     ```
     
     使用`show databases`查看全部数据库，`use test`切换到test数据库，`show tables`查看全部表
     
   - 复制宿主机sql到容器并执行
   
     ```
     docker cp ./mall.sql mysql:/home
     ```
   
     ```
     mysql -uroot -p
     source /home/mall.sql
     ```
   
   - 5.7挂载配置需要在conf下新建两个文件夹mysql.conf.d和conf.d

#### pg

- ```
   docker run --name pg -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
   ```

   - ```
     psql -h localhost -U postgres -W
     ```

     ```
     CREATE DATABASE test;
     ```

     使用`\l`查看全部数据库，`\c test`切换到test数据库，`\dt`查看全部表

#### redis

- 安装GUI：redisInsight，官网按钮有bug点不了，可以去github issues里找

- 单节点模式：

  ```
  docker run -id --restart=always --privileged=true --name=redis -p 6379:6379 redis --requirepass "redis"
  ```

### 中间件

#### 消息队列

##### kafka

- [kafka.yml](resources/compose_file/kafka.yml)

   ```
   docker-compose -f kafka.yml -p kafka up -d
   ```
   
- 使用：

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

##### RabbitMQ

- ```
  docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 -v `pwd`/data:/var/lib/rabbitmq -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin --restart always rabbitmq:3.12.6-management-alpine
  ```

#### Logstash

- 使用前在配置文件里配好input和output

- ```
  logstash-plugin install logstash-codec-json_lines
  ```

#### ES

- ```
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

     - 如果挂载运行的话，将类似elasticsearch-analysis-ik-7.2.0.zip的文件放到plugins下直接解压
     - 如果对应版本的release没有的话，参考这个issue自己编译：https://github.com/medcl/elasticsearch-analysis-ik/issues/1017
   
   - kibana部署（ui界面）：
   
     ```
     docker run --name kibana --link=elasticsearch:test -p 5601:5601 -d kibana:7.2.0
     ```
   
   - 简单示例（在idea中打开）：[es-demo.http](resources/es/es-demo.http)
   
   - **问题**：
   
     - 有时es会有索引状态为红，可以用下列命令删掉：
   
       ```
       curl -s  'http://localhost:9200/_cat/indices/?v' | grep red | awk '{print $3}' | xargs -i curl -XDELETE http://localhost:9200/{}
       ```
   
       然后在用下列命令查看：
   
       ```
       curl -s  'http://localhost:9200/_cat/indices/?v' | grep red
       ```

### 微服务组件

以下表格列出每项功能的可选组件，可以自由组合（标删除线的在spring boot 3无法使用）

| 注册中心 + 动态配置                      | 网关（路由以及限流重试等） | 负载均衡      | 容错                         | 链路追踪         | 远程调用 | 分布式事务 |      |
| ---------------------------------------- | -------------------------- | ------------- | ---------------------------- | ---------------- | -------- | ---------- | ---- |
| eureka + config + bus + rabbitmq（无语） | ~~zuul~~                   | ~~ribbon~~    | ~~hystrix~~                  | ~~sleuth~~       | Feign    | Seata      |      |
| Consul                                   | gateway                    | load balancer | Sentinel（也包含限流等功能） | tracing + zipkin | dubbo    |            |      |
| Nacos                                    |                            |               |                              |                  |          |            |      |
| zk                                       |                            |               |                              |                  |          |            |      |

#### 注册中心

##### cousul

- ```
  docker run -d -p 8500:8500 --restart=always --name=consul consul:1.15.4 agent -server -bootstrap -ui -node=1 -client='0.0.0.0'
  ```

##### zk

- ```
  docker run -d --name zookeeper -p 2181:2181 -v /d/shared/mono/zookeeper/conf/zoo.cfg:/conf/zoo.cfg zookeeper:latest
  ```

  - 单个容器挂载用win terminal，win bash会有奇怪的bug
  
  - 启动zk容器中的客户端：
  
    ```
    ./bin/zkCli.sh
    ```
  
  - 下载可视化GUI：https://github.com/vran-dev/PrettyZoo/releases

##### nacos

- ```
  docker run --name nacos -e MODE=standalone -p 8848:8848 -p 9848:9848 -p 9849:9849 -d --restart=always nacos/nacos-server:latest
  ```


#### 链路追踪

##### zipkin

- ```
   docker run -d -p 9411:9411 --name zipkin --restart always openzipkin/zipkin
   ```

   - 整合es：

     ```
     docker-compose -f zipkin-elasticsearch.yml -p zipkin-elasticsearch up -d
     ```
     [zipkin-elasticsearch.yml](resources/compose_file/zipkin-elasticsearch.yml)

   - 整合rabbitmq：

     ```
     docker run -d --name zipkin_rabbitmq -p 9411:9411 -e RABBIT_ADDRESSES=localhost:5673 -e RABBIT_USER=admin -e RABBIT_PASSWORD=admin openzipkin/zipkin
     ```

#### 熔断限流

##### alibaba-sentinel

- ```
  docker run -d --name sentinel -p 8080:8080 --restart always leixuewen/sentinel-dashboard
  ```


#### 分布式事务

##### Seata

- 启动步骤如下：db模式需要先建表：https://github.com/seata/seata/blob/develop/script/server/db/mysql.sql

  ```
  docker run --name seata-server -d -p 8091:8091 -p 7091:7091 --restart always seataio/seata-server:latest
  ```

  - 将本地修改好的[application.yml](resources/config_file/seata/application.yml)（容器内部无法访问宿主机，要把nacos的ip改成host.docker.internal）复制到容器之后重启。[参考](https://github.com/seata/seata/blob/develop/server/src/main/resources/application.example.yml)

    ```
    docker cp ./application.yml seata-server:/seata-server/resources
    ```

  - 或者将resources文件夹复制出来，再挂载启动（用win terminal，win bash会有奇怪的bug）

    ```
    docker cp seata-server:/seata-server/resources /d/shared/mono/seata
    ```

    ```
    docker run -d --name seata-server -p 8091:8091 -p 7091:7091 -v /d/shared/mono/seata/resources:/seata-server/resources seataio/seata-server:1.7.1
    ```


- 默认AT模式，必须建日志表：[undo_log](https://github.com/seata/seata/blob/develop/script/client/at/db/mysql.sql)

- client项目resources下需要放配置文件：[conf](https://github.com/seata/seata/tree/develop/script/client/conf)

