## Java并发

### 1. 基础

#### 1.1 线程

##### 1.1.1 基本概念区分

###### 1.1.1.1 进程和线程

- 每当启动一个main方法时，OS会创建一个JVM进程，而main方法是其中的一个主线程。所有线程共享进程的**堆区**和**方法区**资源，但每个线程有自己的**程序计数器**、**虚拟机栈**和**本地方法栈**。用户空间的java线程和OS内核空间的线程是一一对应的关系。

  - 通过以下方法可以打印出所有的线程信息，可以看到一个main线程和其他线程。

    ```java
    public class MultiThread {
    	public static void main(String[] args) {
    		// 获取 Java 线程管理 MXBean
    	ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
    		// 不需要获取同步的 monitor 和 synchronizer 信息，仅获取线程和线程堆栈信息
    		ThreadInfo[] threadInfos = threadMXBean.dumpAllThreads(false, false);
    		// 遍历线程信息，仅打印线程 ID 和线程名称信息
    		for (ThreadInfo threadInfo : threadInfos) {
    			System.out.println("[" + threadInfo.getThreadId() + "] " + threadInfo.getThreadName());
    		}
    	}
    }
    ```

- 其他区别都是操作系统基础

###### 1.1.1.2 Thread、Runnable和Callable

- **有且仅有Thread类能通过start0()本地方法向操作系统申请线程资源**，线程池只是对Thread的复用

- Runnable和Callable是任务不是线程。没有线程或线程池去包裹他们的话，他们只是代码而已。

- 创建线程有如下几种形式：

  ```java
  public class AsyncAndWaitTest {
  
      public static void main(String[] args) throws ExecutionException, InterruptedException {
          // 方式1：重写Thread#run()
          Thread thread = new Thread() {
              @Override
              public void run() {
                  System.out.println(Thread.currentThread().getName() + "========>正在执行");
              }
          };
          thread.start();
  
          // 方式2：构造方法传入Runnable实例
          new Thread(() -> {
              System.out.println(Thread.currentThread().getName() + "========>正在执行");
          }).start();
  
          // 方式3：线程池 + Callable/Runnable，这里以Callable为例
          ExecutorService executorService = Executors.newSingleThreadExecutor();
          Future<String> submit = executorService.submit(() -> {
              System.out.println(Thread.currentThread().getName() + "========>正在执行");
              Thread.sleep(3 * 1000L);
              return "success";
          });
          String result = submit.get();
          System.out.println("result=======>" + result);
          // 关闭线程池
          executorService.shutdown();
      }
  }
  ```

- 此外，还有一种源码中经常出现的写法：把new Thread().start()隐藏到某个类的内部

  ```java
  public class AsyncAndWaitTest {
      public static void main(String[] args) throws InterruptedException {
          System.out.println(Thread.currentThread().getName() + "主线程开始");
          Worker w = new Worker();
          w.begin();
          System.out.println(Thread.currentThread().getName() + "主线程结束");
          Thread.sleep(4 * 1000L);
      }
  
      static class Worker implements Runnable {
          public void begin() {
              new Thread(this).start();
          }
  
          @Override
          public void run() {
              System.out.println(Thread.currentThread().getName() + "执行Worker#run()开始");
              try {
                  Thread.sleep(3 * 1000L);
              } catch (InterruptedException e) {
                  e.printStackTrace();
              }
              System.out.println(Thread.currentThread().getName() + "执行Worker#run()结束");
          }
      }
  }
  ```

##### 1.1.2 线程状态

- New：线程被实例化，但还没有调用start；TERMINATED：线程执行完毕
- Runnable：调用Thread.start()之后，包括Running和Ready两个状态，由OS进行调度。现代OS通常都是时间片轮转调度的，时间片都是ms级的，时间片用完就要被放入多级反馈队列的末尾进入Ready状态。因此Java不区分这两者。
  - 调用Thread.yield()可以将当前线程让步，切换为Ready状态。
- WAITING和TIMED_WAITING：线程进入等待状态，需要来自其他线程的通知或终端。
  - Object的wait()，notify()和notifyAll()方法不多说了，此时将该Object当做一个锁。线程A调用wait()释放锁并使当前线程等待，持有同一个对象锁的线程B调用notifyAll()后可以唤醒线程A。
  - Thread.join()可以使当前线程等待其他线程执行完毕
  - LockSupport类的park()和unpark()：java1.6之后的许可机制，比wait/notifyAll灵活的多，AQS中用到了这种结构
    - https://blog.csdn.net/hengyunabc/article/details/28126139
  - Thread.sleep(long)只是单纯等一段时间，没有任何对于锁的操作
- Blocked：线程调用同步方法时没有获取到锁，便会被阻塞

### 2 锁

#### 2.1 概念

##### 2.1.1 简介

- 堆区对象除了实例数据以外，还有几个区域。比如元数据指针指向方法区所属的类，Mark Word表示了对象的锁状态，所以每个堆区对象都可以作为锁使用。锁也分类锁和对象锁。
- synchronized早期是重量级锁，需要向OS申请资源，设计用户态和内核态的切换，效率不高；因此有了自旋锁ReentrantLock，可以在发生锁竞争时使用CAS自旋，但是如果线程数过多，同时自旋也很耗费资源。

##### 2.1.2 synchronized介绍及优化

- JDK1.6以后对synchronized作了优化，有了“锁升级”的概念，也就是Mark Word中提到的无锁，偏向锁，轻量级锁（自旋锁），重量级锁
  - 无锁：对象刚new出来
  - 偏向锁：对象第一次被一个线程访问时，会把线程ID记到Mark Word里，此时没有多线程环境
  - 轻量级锁（自旋锁）：发生锁竞争时，JDK使用一套机制来控制自旋
  - 重量级锁：OS会维护一个队列来避免多个线程同时自旋等待耗费CPU性能

- synchronized是可重入锁，同一个线程在已经持有该锁的情况下，可以再次获取锁，并且会在某个状态量上做+1操作（ReentrantLock也支持重入）
- 只有竞争同一个对象锁时才会使某个线程wait，因此子类同步方法调用父类同步方法时，由于锁的都是this，指向的都是子类对象，而且可重入，因此可以调用
- 底层：synchronized同步语句块使用的是 `monitorenter` 和 `monitorexit` 指令，分别指向开始和结束位置，修饰同步方法时是ACC_SYNCHRONIZED标识，指明这是一个同步方法。**两者的本质都是对对象监视器 monitor 的获取。**
  - 执行`monitorenter`时，会尝试获取对象的锁，锁的计数器为 0表示可以获取，获取后将锁计数器设为 1 也就是加 1。
  - 对象锁的的拥有者线程才可以执行 `monitorexit` 指令来释放锁，锁计数器减1。

##### 2.1.3 synchronized和ReentrantLock 

- synchronized是JVM实现的，ReentrantLock 是API
- ReentrantLock多了一些功能：
  - 中断等待锁的线程：lock.lockInterruptibly()，线程可以处理其他事情
  - 可以指定是公平锁：先等待的线程先获得锁
  - 可实现选择性通知（锁可以绑定多个条件）：实现多路通知功能，即在一个ReentrantLock中创建多个Condition，线程对象可以注册在指定的Condition中。synchronized关键字就相当于整个 Lock 对象中只有一个Condition实例，notifyAll()方法会唤醒全部相关线程；而condition.signalAll()只会唤醒该Condition下的线程

##### 2.1.4 volatile 

- 由于CPU存在L1，L2，L3级缓存，变量可以保存在寄存器里，和内存的变量可能存在同步间隙。而Java也可能会将变量保存在本地内存里而不是主内存里。因此可以使用volatile来确保使用某变量时都到主存中进行读取。同时volatile也可以禁用指令重排。

##### 2.1.5 ThreadLocal

- ```java
  public class ThreadLocalExample implements Runnable {
      // SimpleDateFormat 不是线程安全的，所以每个线程都要有自己独立的副本
      private static final ThreadLocal<SimpleDateFormat> formatter = ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyyMMdd HHmm"));
  
      public static void main(String[] args) throws InterruptedException {
          ThreadLocalExample obj = new ThreadLocalExample();
          for (int i = 0; i < 10; i++) {
              Thread t = new Thread(obj, "" + i);
              Thread.sleep(new Random().nextInt(1000));
              t.start();
          }
      }
  
      @Override
      public void run() {
          System.out.println("Thread Name= " + Thread.currentThread().getName() + " default Formatter = " + formatter.get().toPattern());
          try {
              Thread.sleep(new Random().nextInt(1000));
          } catch (InterruptedException e) {
              e.printStackTrace();
          }
          //formatter pattern is changed here by thread, but it won't reflect to other threads
          formatter.set(new SimpleDateFormat());
  
          System.out.println("Thread Name= " + Thread.currentThread().getName() + " formatter = " + formatter.get().toPattern());
      }
  }
  ```

- 每个线程内部维护了一个**ThreadLocalMap**，可以存储以ThreadLocal为key，其他对象为value的键值对。多个ThreadLocal都保存在这个ThreadLocalMap里，并对其他线程不可见。

  - JVM强，弱，软，虚引用介绍：
    - 强引用不受GC影响，只有引用全部切断时，才会在下一次GC时被回收
    - 软引用对象会在内存不足触发GC时被回收（适用于高速缓存）
    - 弱引用是每次GC时都回收，不论内存是否不足
      - ThreadLocalMap的Entry extends WeakReference<ThreadLocal<?>>，并在构造器里调用了super(k)，相当于把key包装成了弱引用。这样在外界强引用切断的情况下，可以触发GC，不至于导致ThreadLocalMap中的对象无法回收导致内存泄漏。
    - 虚引用（堆外内存，比如zerocopy）

- 内存泄漏
  - 书接上文，弱引用将key回收后，key变成了null，但是对应的value还在，导致无法移除。所以ThreadLocalMap在下一次get/set时会判断，key为null时将value置为null。
  - 但是如果没有下一次get/set呢？所以最好是在用完后手动调用remove()，这也是Java开发手册中建议的做法。

#### 2.2 线程池

##### 2.2.1 ThreadPoolExecutor

- 继承体系：ThreadPoolExecutor -> AbstractExecutorService -> ExecutorService -> Executor

  - Executor顶层接口：就一个execute方法
  - ExecutorService接口：引入**线程池状态**，比如引入了shutDown等方法；同时还引入了**submit()方法**，返回一个Future对象
    - ScheduledExecutorService：定时任务
  - AbstractExecutorService抽象类：新增newTaskFor()方法，将Runnable和Callable两种任务**统一**为FutureTask类型；对submit()等方法做了**初步**实现
  - ThreadPoolExecutor：终于是一个真实能用的线程池了

- 参数分析：

  - corePoolSize，maximumPoolSize：核心线程数和最大线程数
  - keepAliveTime，unit：线程存活时间，超过进行销毁
  - workQueue：阻塞队列
    - ArrayBlockingQueue内部使用ReentrantLock实现，两个Condition为notEmpty和notFull，当队列满时，notFull进行await阻塞生产者线程；消费者同理

  - threadFactory：一般用来加名字区分线程
  - handler：拒绝策略，将size和queue容量设置为1，可以很容易看出区别
    - AbortPolicy：直接抛异常
    - CallerRunsPolicy：使用当前线程处理，比如main线程
    - DiscardOldestPolicy：丢弃最老的未处理任务，把新的加进来
    - DiscardPolicy：丢弃新的任务

- 调用过程：核心线程处理任务 -> 任务进入任务队列等待 -> 非核心线程处理任务 -> 拒绝策略

  - execute方法：

    - 假设核心线程数未满，调用addWorker(command, true)，true表示核心线程；如果满了，尝试把任务加入到workQueue；如果队列也满了，调用addWorker(command, false)创建非核心线程；如果非核心线程也失败，调用拒绝策略。整个过程是非阻塞的
    - addWorker方法：其中会异步开启Worker中的线程，线程会调用runWorker
    - runWorker方法：核心/非核心线程处理完手头任务后，异步线程调用这个方法，其中会getTask获取任务，也就是说，addWorker最终会跑到这儿获取任务

  - getTask简化逻辑如下：

    ```java
    private Runnable getTask() {
        boolean timedOut = false; // Did the last poll() time out?
    
        // 尝试循环获取任务
        for (;;) {
    
            // 是否需要检测超时：当前线程数超过核心线程
            boolean timed = wc > corePoolSize;
    
            // 超时了，return null
            if (timed && timedOut) {
                return null;
            }
    
            try {
                // 是否需要检测超时
                Runnable r = timed ?
                    workQueue.poll(keepAliveTime, TimeUnit.NANOSECONDS) :
                    workQueue.take();
                if (r != null)
                    return r;
                timedOut = true;
            } catch (InterruptedException retry) {
                timedOut = false;
            }
        }
    } 
    ```

    - 线程数小于核心线程数，timed永远为false。那么就会调用workQueue.take()一直阻塞下去，直到有新的任务提交进来。但是处理结束后，还是会进入循环，周而复始。由于线程永远处于阻塞等待任务、执行任务、继续阻塞等待任务的死循环中，也就永远不会销毁了。

    - 销毁：task=null && 队列为空 && 当前线程数超过corePoolSize

#### 2.3 AQS

##### 2.3.1 
