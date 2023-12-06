## 非典型面试题

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

#### 多线程交替打印

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


#### 实现一个栈

- 简单实现如下

  ```java
  class Stack {
      private int[] arr;
      private int top;
  
      public Stack(int capacity) {
          arr = new int[capacity];
          top = -1;
      }
  
      public void push(int element) {
          if (top == arr.length - 1) {
              throw new IllegalStateException("栈已满！");
          }
          arr[top++] = element;
      }
  
      public int pop() {
          if (isEmpty()) {
              throw new IllegalStateException("栈为空！");
          }
          return arr[top--];
      }
  
      public int top() {
          if (isEmpty()) {
              throw new IllegalStateException("栈为空！");
          }
          return arr[top];
      }
  
      public boolean isEmpty() {
          return top == -1;
      }
  
      public int size() {
          return top + 1;
      }
  }
  ```

#### LRU Cache

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
  
  如果要手动实现双向链表，应该是下面的写法，面试还真有面试官出这玩意儿，服气
  
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
  
  