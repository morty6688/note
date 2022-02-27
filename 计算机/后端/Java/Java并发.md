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
  - LockSupport类的park()和unpark()：//TODO，不是很懂
  - Thread.sleep(long)只是单纯等一段时间，没有任何对于锁的操作
- Blocked：线程调用同步方法时没有获取到锁，便会被阻塞

### 2 锁

#### 2.1 概念

