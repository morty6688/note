## 非典型面试题

- 面试一般会问leetcode算法题，考察重点在算法。这里记录一些非典型面试题，跟算法关系不大，但是问的也比较多，更多的涉及到数据结构。

#### 手写单例

- Runtime类实现方式

  ```java
  public class Singleton {
      private static final Singleton INSTANCE = new Singleton();
  
      private Singleton() {
      }
  
      public static Singleton getInstance() {
          return INSTANCE;
      }
  }
  ```

  - 可以通过反射来破坏private封装拿到实例，当然反射也可以被禁止

    ```java
    var constructors = Singleton.class.getDeclaredConstructors();
    AccessibleObject.setAccessible(constructors, true);
    
    Arrays.stream(constructors).forEach(name -> {
        if (name.toString().contains("Singleton")) {
            try {
                Singleton instance = (Singleton) name.newInstance();
                instance.doSomething();
            } catch (Exception e) {
            }
        }
    });
    ```

- 双检锁（`Lombok`中的`@Getter(lazy=true)`实现方式）

  ```java
  public class Singleton {
      private volatile static Singleton INSTANCE = null;
  
      private Singleton() {
      }
  
      public static Singleton getInstance() {
          if (INSTANCE == null) {
              synchronized (Singleton.class) {
                  if (INSTANCE == null) {
                      INSTANCE = new Singleton();
                  }
              }
          }
  
          return INSTANCE;
      }
  }
  ```

- 单元素枚举实现方式（来自Effective Java，作者认为这个不能被反射攻击或反序列化攻击，u1s1，没啥必要）

  ```java
  public enum Singleton {
      INSTANCE;
  
      public void doSomething() {
          System.out.println("Doing something...");
      }
  }
  ```

- 静态内部类实现方式（服务端程序很少写内部类，Android开发可能用的多？但是现在Android开发都不怎么用Java了，用Kotlin吧）

  ```java
  public class Singleton {
      private Singleton() {
      }
  
      public static Singleton getInstance() {
          return SingletonInner.INSTANCE;
      }
  
      private static class SingletonInner {
          private final static Singleton INSTANCE = new Singleton();
      }
  
  }
  ```

#### 多线程

##### 多线程交替打印

- 本题表示一个奇偶数交替打印，首先Printer中有两个方法，分别打印奇数和偶数，main方法中分别启动相应的线程。

  - 最简单的方法为使用Atomic变量自旋，如下所示

    ```java
    public class OddEvenAlternatelyPrinter {
        private final int n;
    
        private final AtomicBoolean isOdd = new AtomicBoolean(true);
    
        public OddEvenAlternatelyPrinter(int n) {
            this.n = n;
        }
    
        public void printOdd() {
            for (int i = 1; i <= n; i += 2) {
                while (!isOdd.get()) {
                    Thread.yield();
                }
                System.out.println("thread that prints odd: " + i);
                isOdd.set(false);
            }
        }
    
        public void printEven() {
            for (int i = 2; i <= n; i += 2) {
                while (isOdd.get()) {
                    Thread.yield();
                }
                System.out.println("thread that prints even: " + i);
                isOdd.set(true);
            }
        }
    
        public static void main(String[] args) {
            var printer = new OddEvenAlternatelyPrinter(10);
            new Thread(printer::printOdd).start();
            new Thread(printer::printEven).start();
        }
    }
    ```

  - 当然也可以加锁，比如`synchronized`，`wait()`和`notifyAll()`配合使用

##### 死锁

- 死锁分顺序死锁和资源死锁。前者指的是java代码里的锁，每个锁就是一个对象，因为访问顺序有问题导致死锁；后者是非java代码的资源，比如两个线程去同时读取两个文件这种。面试中常实现的就是第一种，注意下面两个线程各睡1s就行，：

  ```java
  public class DeadLockDemo {
      private final Object left = new Object();
      private final Object right = new Object();
  
      public void leftRight() {
          synchronized (left) {
              try {
                  Thread.sleep(1000);
              } catch (InterruptedException e) {
                  throw new RuntimeException(e);
              }
              synchronized (right) {
                  System.out.println("leftRight");
              }
          }
      }
  
      public void rightLeft() {
          synchronized (right) {
              try {
                  Thread.sleep(1000);
              } catch (InterruptedException e) {
                  throw new RuntimeException(e);
              }
              synchronized (left) {
                  System.out.println("rightLeft");
              }
          }
      }
  
      public static void main(String[] args) {
          DeadLockDemo deadLockDemo = new DeadLockDemo();
          new Thread(deadLockDemo::leftRight).start();
          new Thread(deadLockDemo::rightLeft).start();
      }
  }
  ```

##### 生产者消费者

- 阻塞队列实现：生产者线程和消费者线程通过一个阻塞队列完成生产和消费，线程池的原理和这个也差不多

  ```java
  public class BlockingQueueModel {
      private final BlockingQueue<Task> queue;
      private final AtomicInteger counter = new AtomicInteger(0);
  
      public BlockingQueueModel(int capacity) {
          this.queue = new ArrayBlockingQueue<>(capacity);
      }
  
      class Producer implements Runnable {
          @Override
          public void run() {
              try {
                  Task task = new Task(counter.getAndIncrement());
                  System.out.println("produce: " + task.no);
                  queue.put(task);
              } catch (Exception e) {
                  throw new RuntimeException(e);
              }
          }
      }
  
      class Consumer implements Runnable {
          @Override
          public void run() {
              try {
                  Task task = queue.take();
                  System.out.println("consume: " + task.no);
              } catch (Exception e) {
                  throw new RuntimeException(e);
              }
          }
      }
  
      public static void main(String[] args) {
          BlockingQueueModel model = new BlockingQueueModel(5);
          for (int i = 0; i < 5; i++) {
              new Thread(model.new Producer()).start();
          }
          for (int i = 0; i < 5; i++) {
              new Thread(model.new Consumer()).start();
          }
      }
  }
  
  class Task {
      int no;
  
      public Task(int no) {
          this.no = no;
      }
  }
  ```

- 其他实现方式有wait和notifyAll等等，就不说了

#### 实现栈和队列

- 栈和队列首先要先抓住三个API的实现（isEmpty，isFull，size）

##### 栈

- 简单实现如下。这个还是很简单直观的，没啥特殊注意的地方

  ```java
  public class Stack {
      private final int[] array;
      private int top = -1;
  
      public Stack(int size) {
          array = new int[size];
      }
  
      public boolean isEmpty() {
          return top == -1;
      }
  
      public boolean isFull() {
          return top == array.length - 1;
      }
  
      public int size() {
          return top + 1;
      }
  
      public void push(int num) {
          if (isFull()) {
              throw new RuntimeException("stack is full!");
          }
          array[++top] = num;
      }
  
      public int pop() {
          if (isEmpty()) {
              throw new RuntimeException("stack is empty!");
          }
          return array[top--];
      }
  
      public int top() {
          if (isEmpty()) {
              throw new RuntimeException("stack is empty!");
          }
          return array[top];
      }
  }
  ```

##### 队列

- 栈的实现很简单，因为栈只有一个指针指向top，添加删除只改变这一个指针。但是队列不同，是队尾添加，队头删除，需要两个指针。以下是顺序队列的实现，记住`head = tail = -1`，然后按这个写就行了

  ```java
  public class Queue {
      private int maxSize;
      private int head, tail;
      private int[] array;
  
      public Queue(int maxSize) {
          this.maxSize = maxSize;
          array = new int[maxSize];
          head = tail = -1;
      }
  
      public boolean isEmpty() {
          return head == tail;
      }
  
      public boolean isFull() {
          return (tail + 1) == maxSize;
      }
  
      public int size() {
          return tail - head;
      }
  
      public void add(int num) {
          if (isFull()) {
              throw new RuntimeException("Queue is full");
          }
          array[++tail] = num;
      }
  
      public int remove() {
          if (isEmpty()) {
              throw new RuntimeException("Queue is empty");
          }
          return array[++head];
      }
  
      public int getHead() {
          if (isEmpty()) {
              throw new RuntimeException("Queue is empty");
          }
          return array[head + 1];
      }
  }
  ```

- 顺序队列有个问题，就是浪费内存。head和tail只能向右移动，这样数组的左边会越来越空。因此更好的实现是循环队列，就是数组右边满了，可以继续放到左边。

  - 假如此时还是使用上面的思路会导致判空和判满都是`head==tail`，所以需要额外的size来保存队列容量

    ```java
    public class Queue {
        private int maxSize;
        private int head, tail, size;
        private int[] array;
    
        public Queue(int maxSize) {
            this.maxSize = maxSize;
            array = new int[maxSize];
            head = tail = size = 0;
        }
    
        public boolean isEmpty() {
            return size == 0;
        }
    
        public boolean isFull() {
            return size == maxSize;
        }
    
        public int size() {
            return size;
        }
    
        public void add(int num) {
            if (isFull()) {
                throw new RuntimeException("Queue is full");
            }
            array[tail] = num;
            tail = (tail + 1) % maxSize;
            size++;
        }
    
        public int remove() {
            if (isEmpty()) {
                throw new RuntimeException("Queue is empty");
            }
            int res = array[head];
            head = (head + 1) % maxSize;
            size--;
            return res;
        }
    
        public int getHead() {
            if (isEmpty()) {
                throw new RuntimeException("Queue is empty");
            }
            return array[head];
        }
    }
    ```

  - 如果不使用额外size，只能牺牲一个数组元素位置来保证不会出现判空和判满条件相同的冲突问题，所以初始化要初始化为`maxSize+1`的容量

    ```java
    public class Queue {
        private int maxSize;
        private int head, tail;
        private int[] array;
    
        public Queue(int maxSize) {
            this.maxSize = maxSize + 1;
            array = new int[maxSize + 1];
            head = tail = 0;
        }
    
        public boolean isEmpty() {
            return head == tail;
        }
    
        public boolean isFull() {
            return (tail + 1) % maxSize == head;
        }
    
        public int size() {
            return (tail - head + maxSize) % maxSize;
        }
    
        public void add(int num) {
            if (isFull()) {
                throw new RuntimeException("Queue is full");
            }
            array[tail] = num;
            tail = (tail + 1) % maxSize;
        }
    
        public int remove() {
            if (isEmpty()) {
                throw new RuntimeException("Queue is empty");
            }
            int res = array[head];
            head = (head + 1) % maxSize;
            return res;
        }
    
        public int getHead() {
            if (isEmpty()) {
                throw new RuntimeException("Queue is empty");
            }
            return array[head];
        }
    }
    ```

#### 缓存淘汰策略

##### LRU Cache

- [[146]LRU Cache](https://leetcode.cn/problems/lru-cache/)，`leetcode`上有这个题。下面这个是有泛型的版本，简单的做法是用`LinkedHashMap`，构造函数加上true可以使元素按访问顺序排序

  ```java
  public class LruCache<K, V> extends LinkedHashMap<K, V> {
      private int capacity;
  
      public LruCache(int capacity) {
          super(capacity, 0.75f, true);
          this.capacity = capacity;
      }
  
      @Override
      public V get(Object key) {
          return super.getOrDefault(key, null);
      }
  
      public V put(K key, V value) {
          return super.put(key, value);
      }
  
      @Override
      protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
          return size() > capacity;
      }
  }
  ```
  
  如果要手动实现双向链表，应该是下面的写法，这东西写起来是很烦，建议先定义API和基本结构，如下。基本思想就是`get`时需要同时调用`moveToHead`。`put`时如果key已存在，更新值并`moveToHead`；如果key不存在，`addToHead`同时`size+1`，当然`size > capacity`时需要淘汰缓存，删除key并调用`removeTail`。
  
  ```java
  public class LRUCache<K, V> {
      private Map<K, DLinkedNode> cache = new HashMap<>();
      private int size;
      private int capacity;
      private DLinkedNode head, tail;
  
      public LRUCache(int capacity) {
          this.capacity = capacity;
  
          // dummy head and tail
          head = new DLinkedNode();
          tail = new DLinkedNode();
          head.next = tail;
          tail.prev = head;
      }
  
      public V get(K key) {
          DLinkedNode node = cache.get(key);
          if (node == null) {
              return null;
          }
          moveToHead(node);
          return node.value;
      }
  
      public void put(K key, V value) {
          DLinkedNode node = cache.get(key);
          if (node == null) {
              // create a new node
              DLinkedNode newNode = new DLinkedNode(key, value);
              // add to cache
              cache.put(key, newNode);
              // add to head
              addToHead(newNode);
              size++;
              if (size > capacity) {
                  // remove the tail
                  DLinkedNode tail = removeTail();
                  cache.remove(tail.key);
                  size--;
              }
          } else {
              // update the value
              node.value = value;
              // move to head
              moveToHead(node);
          }
      }
  
      class DLinkedNode {
          K key;
          V value;
          DLinkedNode prev;
          DLinkedNode next;
      }
  }
  ```
  
  完整版如下。这里其实有四个链表操作，`addToHead`，`removeNode`，`moveToHead`，`removeTail`。需要先实现前两个，后两个依赖前两个的实现。
  
  ```java
  public class LRUCache<K, V> {
      private Map<K, DLinkedNode> cache = new HashMap<>();
      private int size;
      private int capacity;
      private DLinkedNode head, tail;
  
      public LRUCache(int capacity) {
          this.capacity = capacity;
          // 使用伪头部和伪尾部节点
          head = new DLinkedNode();
          tail = new DLinkedNode();
          head.next = tail;
          tail.prev = head;
      }
  
      public V get(int key) {
          DLinkedNode node = cache.get(key);
          if (node == null) {
              return null;
          }
          // 如果 key 存在，先通过哈希表定位，再移到头部
          moveToHead(node);
          return node.value;
      }
  
      public void put(K key, V value) {
          DLinkedNode node = cache.get(key);
          if (node == null) {
              // 如果 key 不存在，创建一个新的节点
              DLinkedNode newNode = new DLinkedNode(key, value);
              // 添加进哈希表
              cache.put(key, newNode);
              // 添加至双向链表的头部
              addToHead(newNode);
              ++size;
              if (size > capacity) {
                  // 如果超出容量，删除双向链表的尾部节点
                  DLinkedNode tail = removeTail();
                  // 删除哈希表中对应的项
                  cache.remove(tail.key);
                  --size;
              }
          } else {
              // 如果 key 存在，先通过哈希表定位，再修改 value，并移到头部
              node.value = value;
              moveToHead(node);
          }
      }
  
      private void addToHead(DLinkedNode node) {
          node.prev = head;
          node.next = head.next;
          head.next.prev = node;
          head.next = node;
      }
  
      private void removeNode(DLinkedNode node) {
          node.prev.next = node.next;
          node.next.prev = node.prev;
      }
  
      private void moveToHead(DLinkedNode node) {
          removeNode(node);
          addToHead(node);
      }
  
      private DLinkedNode removeTail() {
          DLinkedNode res = tail.prev;
          removeNode(res);
          return res;
      }
  
      class DLinkedNode {
          K key;
          V value;
          DLinkedNode prev;
          DLinkedNode next;
  
          public DLinkedNode() {
          }
  
          public DLinkedNode(K key, V value) {
              this.key = key;
              this.value = value;
          }
      }
  }
  ```
  

##### LFU Cache

- [[460]LFU Cache](https://leetcode.cn/problems/lfu-cache/)：LFU Cache知道是啥就行了，目前为止没遇到面试官出过。这个比LRU Cache还长

#### 加权轮询算法

- 负载均衡算法的一种，此外还有最小连接数法，源地址哈希法，这个出现频率真的高。为什么要有权重呢，因为服务可能部署在多台机器上，有的配置高，有的配置低，配置高的就可以设置一个大的权重。

- 不同算法的比较：https://mp.weixin.qq.com/s/P25wnGkOjrZiq034UIu2pg

- nginx采用平滑加权轮询算法保证调度不会集中压在同一台权重比较高的机器上：

  - 正确性证明：https://tenfy.cn/2018/11/12/smooth-weighted-round-robin/

  - 算法步骤（只有两步，着重点在`current`）：

    - 对每个节点：`current += weight`
    - 然后选择`current`最大的节点：`current -= total`

  - 代码实现：

    ```java
    class WrrSmooth {
        ServerNode[] nodes;
        int total = 0;
    
        public WrrSmooth(ServerNode[] nodes) {
            this.nodes = nodes;
            for (ServerNode node : nodes) {
                total += node.weight;
            }
        }
    
        public ServerNode nextNode() {
            if (nodes == null || nodes.length == 0) {
                return null;
            }
            ServerNode best = null;
            for (ServerNode node : nodes) {
                node.current += node.weight;
                if (best == null || best.current < node.current) {
                    best = node;
                }
            }
            best.current -= total;
            return best;
        }
    
        static class ServerNode {
            String name;
            int weight;
            int current = 0;
    
            public ServerNode(String name, int weight) {
                this.name = name;
                this.weight = weight;
            }
        }
    }
    ```

    

