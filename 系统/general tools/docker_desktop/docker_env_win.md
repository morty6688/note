## 配置

### docker，k8s，helm, istio 安装

- 安装docker desktop，启动k8s

  - 添加代理：Resources - Proxies

- 安装其他附加软件：

  ```
  si helm openlens istioctl
  ```

  - openlens设置：
    - 设置proxy
    - 插件：@alebcay/openlens-node-pod-menu

  - 安装istio配置档：

    ```
    istioctl install --set profile=demo -y
    kubectl label namespace default istio-injection=enabled
    ```

    - 可以通过以下命令查看label：

      ```
      k get ns --show-labels
      ```

  - krew配置（k8s插件管理器，需要使用管理员模式打开shell安装）：

    ```
    si krew
    ```

    - kubecm（切换kubeconfig，需要命令行挂一下临时代理）：
      ```
      k krew install kc
      ```
      使用方法：
      ```
      k kc list
      ```

  - telepresence：直接使用官网提供的ps1脚本安装。如果需要替换版本，可以将其他版本exe放到和ps1脚本同目录下替换原始exe，再运行ps1脚本或者直接替换c盘的exe

      ```
      # telepresence
      alias tp=telepresence
      alias tpc='telepresence connect'
      alias tps='telepresence status'
      alias tpq='telepresence quit'
      alias tpv='telepresence version'
      ```

- zsh自动补全（在.zshrc文件中添加如下命令）

  ```
  # k8s
  alias k=kubectl
  source <(kubectl completion zsh)
  ```

- 合并`.kubeconfig`文件

  ```
  export KUBECONFIG=~/.kube/config:~/.kube/config1
  kubectl config view --flatten > ./merged-config
  ```

## 常用命令

### docker

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

- 环境使用方法：

  - 使用idea自带的运行按钮

  - 或者使用命令行，以mall项目docker-compose示例：

    ```bash
    docker-compose -f ./resources/compose_file/mall.yml up -d
    ```

    [mall-docker-compose.yml](resources/compose_file/mall.yml)

### 数据库

#### MySQL

- 注意：**5.7挂载配置需要在conf下新建两个文件夹mysql.conf.d和conf.d，8.x挂载需要建conf.d**

   ```bash
   docker run -itd --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --restart always -v //d/shared/mono/mysql8/data:/var/lib/mysql -v //d/shared/mono/mysql8/conf:/etc/mysql -v //d/shared/mono/mysql8/logs:/logs mysql
   ```

- ```
  mysql -hlocalhost -uroot -p
  ```

  ```
  create database test;
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

#### PG

- ```
   docker run --name pg -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d -v //d/shared/mono/postgresql/data:/var/lib/postgresql/data --restart always postgres
   ```

   - ```
     docker exec -it pg psql -hlocalhost -Upostgres -W
     ```

     ```
     CREATE DATABASE test;
     ```

     使用`\l`查看全部数据库，`\c test`切换到test数据库，`\dt`查看全部表

#### Mongo

- ```
  docker run --name mongo -p 27017:27017 -d -v //d/shared/mono/mongo/db:/data/db --restart always mongo
  ```

  

#### redis

- 安装GUI：redisInsight，官网按钮有bug点不了，可以去github issues里找

- 单节点模式：

  ```bash
  docker run -id --restart=always --privileged=true --name=redis -v //d/shared/mono/redis/data:/data -p 6379:6379 redis --requirepass "root"
  ```

### 中间件

#### 消息队列

##### kafka

- GUI：[kafka-ui](https://github.com/provectus/kafka-ui)，已集成在下面的docker-compose文件中

- 集群模式（1zk-3broker-1ui）：[kafka-cluster.yml](resources/compose_file/kafka-cluster.yml)

   - docker-compose文件中将kafka容器内部设置为19092，外部设置为9092方便宿主机访问。生产环境不需要这么设置
   
- 使用：

   - topic操作

     - 建立名为events的topic。`--replication-factor 3`和`--partitions 4`分别可以指定副本因子数和分区数，副本因子数需要大于broker数，比如：
   
       ```
       docker exec kafka1 kafka-topics --bootstrap-server kafka1:19092 --create --topic events --replication-factor 3 --partitions 4
       ```
     
     - topic list
   
       ```
     docker exec kafka1 kafka-topics --bootstrap-server kafka1:19092 --list
       ```
     
     - topic详情
   
       ```
     docker exec kafka1 kafka-topics --bootstrap-server kafka1:19092 --describe --topic events
       ```
     
     - 删除topic
   
       ```
       docker exec kafka1 kafka-topics --bootstrap-server kafka1:19092 --delete --topic events
       ```
     
   - 消息操作
   
     - 写消息
   
       ```
       docker exec --interactive --tty kafka1 kafka-console-producer --bootstrap-server kafka1:19092 --topic events
       ```
   
     - 读消息
   
       ```
       docker exec --interactive --tty kafka1 kafka-console-consumer --bootstrap-server kafka1:19092 --topic events --from-beginning
       ```
   

##### RabbitMQ

```
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 -v //d/shared/mono/rabbitmq/data:/var/lib/rabbitmq -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin --restart always rabbitmq:3.12.6-management-alpine
```

#### Logstash

- 使用前在配置文件里配好input和output

- ```
  logstash-plugin install logstash-codec-json_lines
  ```

#### ES

```
docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -d --restart always -v //d/shared/mono/elasticsearch/plugins:/usr/share/elasticsearch/plugins -v //d/shared/mono/elasticsearch/data:/usr/share/elasticsearch/data elasticsearch:7.17.16
```

- 如果遇到奇怪的权限问题：删除文件夹重建（win）或加权限（linux）

- ik分词器安装，进入容器：

  ```
  elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.17.16/elasticsearch-analysis-ik-7.17.16.zip
  ```

  - 如果挂载运行的话，将类似elasticsearch-analysis-ik-7.17.16.zip的文件放到plugins下直接解压
  - 如果对应版本的release没有的话，参考这个issue自己编译：https://github.com/medcl/elasticsearch-analysis-ik/issues/1017

- kibana部署（ui界面）：

  ```
  docker run --name kibana --link=elasticsearch:test -p 5601:5601 -d --restart always kibana:7.17.16
  ```

- 简单示例（在idea中打开）：[es-demo.http](./resources/es/es-demo.http)：（如果要在kibana中使用，将localhost:9200删掉）

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

| 注册中心 + 动态配置                      | 网关（路由以及限流重试等） | 负载均衡      | 容错                         | 链路追踪         | 远程调用 | 分布式事务 |
| ---------------------------------------- | -------------------------- | ------------- | ---------------------------- | ---------------- | -------- | ---------- |
| eureka + config + bus + rabbitmq（无语） | ~~zuul~~                   | ~~ribbon~~    | ~~hystrix~~                  | ~~sleuth~~       | Feign    | Seata      |
| Consul                                   | gateway                    | load balancer | Sentinel（也包含限流等功能） | tracing + zipkin | dubbo    |            |
| Nacos                                    |                            |               |                              |                  |          |            |
| zk                                       |                            |               |                              |                  |          |            |

#### 注册中心

##### cousul

- ```
  docker run -d -p 8500:8500 --restart=always --name=consul consul:1.15.4 agent -server -bootstrap -ui -node=1 -client='0.0.0.0'
  ```

##### zk

```
docker run -d --name zookeeper -p 2181:2181 -v //d/shared/mono/zookeeper/conf/zoo.cfg:/conf/zoo.cfg zookeeper:latest
```

- 启动zk容器中的客户端：

  ```
  ./bin/zkCli.sh
  ```

- GUI：[PrettyZoo](https://github.com/vran-dev/PrettyZoo/releases)

##### nacos

- ```
  docker run --name nacos -e MODE=standalone -p 8848:8848 -p 9848:9848 -p 9849:9849 -d --restart=always nacos/nacos-server:latest
  ```


#### 链路追踪

##### zipkin

- ```
   docker run -d -p 9411:9411 --name zipkin --restart always openzipkin/zipkin
   ```

   - 整合es：[zipkin-elasticsearch.yml](resources/compose_file/zipkin-elasticsearch.yml)

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

  - 或者将resources文件夹复制出来，再挂载启动

    ```
    docker cp seata-server:/seata-server/resources //d/shared/mono/seata
    ```
    
    ```
    docker run -d --name seata-server -p 8091:8091 -p 7091:7091 -v //d/shared/mono/seata/resources:/seata-server/resources seataio/seata-server:1.7.1
    ```


- 默认AT模式，必须建日志表：[undo_log](https://github.com/seata/seata/blob/develop/script/client/at/db/mysql.sql)

- client项目resources下需要放配置文件：[conf](https://github.com/seata/seata/tree/develop/script/client/conf)
