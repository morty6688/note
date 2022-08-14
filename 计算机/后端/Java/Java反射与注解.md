*参考：https://www.yuque.com/books/share/2b434c74-ed3a-470e-b148-b4c94ba14535*

## Java反射

### 概念

#### 类加载器与Class类

##### 类加载过程

- A a = new A();

  当JVM遇到这行代码时，ClassLoader首先将.class文件加载到内存，执行static相关语句；然后在方法区生成Class<A>对象，并在堆区申请对象空间；之后是调用构造器和父类构造器，并执行init语句和构造器内容。

  可以发现，本质还是通过Class<A>对象创建实例。

##### ClassLoader类

- 核心方法：loadClass，也即为双亲委派机制

  ```java
  protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
      synchronized (getClassLoadingLock(name)) {
          // 首先，检查是否已经加载该类
          Class<?> c = findLoadedClass(name);
          if (c == null) {
              long t0 = System.nanoTime();
              try {
                  // 如果尚未加载，则遵循父优先的等级加载机制（所谓双亲委派机制）
                  if (parent != null) {
                      c = parent.loadClass(name, false);
                  } else {
                      c = findBootstrapClassOrNull(name);
                  }
              } catch (ClassNotFoundException e) {
                  // ClassNotFoundException thrown if class not found
                  // from the non-null parent class loader
              }
  
              if (c == null) {
                  // 模板方法模式：如果还是没有加载成功，调用findClass()
                  long t1 = System.nanoTime();
                  c = findClass(name);
  
                  // this is the defining class loader; record the stats
                  sun.misc.PerfCounter.getParentDelegationTime().addTime(t1 - t0);
                  sun.misc.PerfCounter.getFindClassTime().addElapsedTimeFrom(t1);
                  sun.misc.PerfCounter.getFindClasses().increment();
              }
          }
          if (resolve) {
              resolveClass(c);
          }
          return c;
      }
  }
  
  // 子类应该重写该方法
  protected Class<?> findClass(String name) throws ClassNotFoundException {
      throw new ClassNotFoundException(name);
  }
  
  ```

  - 如果App, Ext, Bootstrap等各级ClassLoader都加载失败，最终会调用自定义ClassLoader的findClass()，此处为模板方法模式（因为我们暂时无法得知子类的findClass()到底怎么实现的，而父类又不需要实现这个方法）。

    ```java
    @Override
    public Class<?> findClass(String name) throws ClassNotFoundException {
    	try {
    		/*自己另外写一个getClassData()
                      通过IO流从指定位置读取xxx.class文件得到字节数组*/
    		byte[] datas = getClassData(name);
    		if(datas == null) {
    			throw new ClassNotFoundException("类没有找到：" + name);
    		}
    		//调用类加载器本身的defineClass()方法，由字节码得到Class对象
    		return defineClass(name, datas, 0, datas.length);
    	} catch (IOException e) {
    		e.printStackTrace();
    		throw new ClassNotFoundException("类找不到：" + name);
    	}
    }
    ```

    - 这个defineClass又是父ClassLoader里的native方法，最终交给底层处理。执行完毕后，JVM里终于出现了Class<A>对象。

##### Class类及其对象

- Class类里应该有什么字段？首先要有描述各修饰符，类名，泛型信息，接口，注解等的字段，其次更为重要的是A这个类里有什么字段，有什么方法和构造器，即Field、Method、Constructor。有了这些信息，我们便可以在运行时通过Class<A>对象创建实例，完全不需要new。

- API使用：

  ```java
  // 通过反射调用Builder模式创建对象，可以发现反射方法的万能之处
  // Student.builder().id(1L).name("a").build();
  Method builder = Student.class.getMethod("builder");
  Object afterBuilder = builder.invoke(null);
  
  Class<?> builder1 = afterBuilder.getClass();
  Method id = builder1.getMethod("id", Long.class);
  Object afterId = id.invoke(afterBuilder, 1L);
  
  Class<?> builder2 = afterId.getClass();
  Method name = builder2.getMethod("name", String.class);
  Object afterName = name.invoke(afterId, "lijian");
  
  Class<?> finalStep = afterName.getClass();
  Method build = finalStep.getMethod("build");
  Student s = (Student) build.invoke(afterName);
  System.out.println(s);
  ```

- 几个注意点：

  - newInstance()底层还是调用无参构造器

  - 私有方法需要这样调：

    ```
    Method getX = Student.class.getDeclaredMethod("getX");
    getX.setAccessible(true);
    ```

  - *SecurityManager*启用之后，无法通过上述手段调用私有方法，需要添加VM参数-Djava.security.manager -Djava.security.policy=C:/java.policy，然后修改java.policy里添加下面一行

    ```
    permission java.lang.reflect.ReflectPermission "suppressAccessChecks";
    ```

    更多权限控制可见：https://blog.securityinnovation.com/blog/2011/09/define-a-security-policy.html

##### Method等底层细节

//TODO

## Java注解

### 概念

#### 编写注解

##### 定义

- 元注解：

  - @Target(ElementType.FIELD)表示这个注解是注在字段上的，括号里表示注解范围。
  - @Retention(RetentionPolicy.RUNTIME)表示这个注解运行期生效，一般都是注在运行期。
  - 其他元注解不常用

- 注解里虽然是方法，但是可以赋值，所以一般称之为属性。

  - 如果只需要写一个属性，而且叫value的话可以直接写，不需要指定属性名

- 常量类定义注解

  - ```java
    public class Const{
        public static final class Cron{
            public static final String TEN_SECONDS = "*/10 * * * * ?"
            public static final String ONE_MINUTE = "0 */1 * * * ?"
            public static final String FIVE_MINUTES = "0 */5 * * * ?"
            public static final String ONE_HOUR = "0 0 */1 * * ?"
            public static final String THREE_HOUR = "0 0 */3 * * ?"
        }
    }
    
    @Component
    @EnableScheduling
    public class MailCron {
        @Scheduled(cron = Const.Cron.TEN_SECONDS)
        public void cron() {
            IMAPMailUtil.receive();
            IMAPMailutil.close();
        }
    }
    ```

#### 使用注解

- 注解的使用离不开反射，除非该注解使用场景非常小，下面举例：

##### 山寨Junit

###### 定义注解

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MyBefore {
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MyTest {
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MyAfter {
}
```

###### 读取注解

```java
/**
 * 这个就是注解三部曲中最重要的：读取注解并操作
 * 相当于我们使用Junit时看不见的那部分（在隐秘的角落里帮我们执行标注了@Test的方法）
 *
 * @author qiyu
 */
public class MyJunitFrameWork {
    public static void main(String[] args) throws Exception {
        // 1.先找到测试类的字节码：EmployeeDAOTest
        Class clazz = EmployeeDAOTest.class;
        Object obj = clazz.newInstance();

        // 2.获取EmployeeDAOTest类中所有的公共方法
        Method[] methods = clazz.getMethods();

        // 3.迭代出每一个Method对象，判断哪些方法上使用了@MyBefore/@MyAfter/@MyTest注解
        List<Method> myBeforeList = new ArrayList<>();
        List<Method> myAfterList = new ArrayList<>();
        List<Method> myTestList = new ArrayList<>();
        for (Method method : methods) {
            if (method.isAnnotationPresent(MyBefore.class)) {
                //存储使用了@MyBefore注解的方法对象
                myBeforeList.add(method);
            } else if (method.isAnnotationPresent(MyTest.class)) {
                //存储使用了@MyTest注解的方法对象
                myTestList.add(method);
            } else if (method.isAnnotationPresent(MyAfter.class)) {
                //存储使用了@MyAfter注解的方法对象
                myAfterList.add(method);
            }
        }

        // 执行方法测试
        for (Method testMethod : myTestList) {
            // 先执行@MyBefore的方法
            for (Method beforeMethod : myBeforeList) {
                beforeMethod.invoke(obj);
            }
            // 测试方法
            testMethod.invoke(obj);
            // 最后执行@MyAfter的方法
            for (Method afterMethod : myAfterList) {
                afterMethod.invoke(obj);
            }
        }
    }
}
```

###### 使用注解

```java
/**
 * 和我们平时使用Junit测试时一样
 *
 * @author qiyu
 */
public class EmployeeDAOTest {
    @MyBefore
    public void init() {
        System.out.println("初始化...");
    }

    @MyAfter
    public void destroy() {
        System.out.println("销毁...");
    }

    @MyTest
    public void testSave() {
        System.out.println("save...");
    }

    @MyTest
    public void testDelete() {
        System.out.println("delete...");
    }
}
```

##### 山寨JPA

###### 定义注解

```java
// 山寨Table注解
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Table {
    String value();
}
```

###### 读取注解

```java
public class BaseDao<T> {
    private static BasicDataSource datasource;

    // 静态代码块,设置连接数据库的参数
    // ...

    // 得到jdbcTemplate
    private JdbcTemplate jdbcTemplate = new JdbcTemplate(datasource);
    // DAO操作的对象，POJO类
    private Class<T> beanClass;

    /**
     * 构造器
     * 初始化时完成对实际类型参数的获取，比如BaseDao<User>插入User，那么beanClass就是User.class
     * 
     * this.getClass().getGenericSuperclass()返回 ParameterizedType
     * 例如 UserDao extends BaseDao<User>，返回 BaseDao<User>
     */
    public BaseDao() {
        beanClass = (Class<T>) ((ParameterizedType) this.getClass()
                .getGenericSuperclass())
                .getActualTypeArguments()[0];
    }

    public void add(T bean) {
        // 得到User对象的所有字段
        Field[] declaredFields = beanClass.getDeclaredFields();

        StringBuilder sql = new StringBuilder()
                .append("insert into ")
                // 处理注解获取真实表名，拼接sql
                .append(beanClass.getAnnotation(Table.class).value())
                .append(" values(");
        for (int i = 0; i < declaredFields.length; i++) {
            sql.append("?");
            if (i < declaredFields.length - 1) {
                sql.append(",");
            }
        }
        sql.append(")");

        // 获得bean字段的值（要插入的记录）
        ArrayList<Object> paramList = new ArrayList<>();
        try {
            for (Field declaredField : declaredFields) {
                declaredField.setAccessible(true);
                Object o = declaredField.get(bean);
                paramList.add(o);
            }
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        int size = paramList.size();
        Object[] params = paramList.toArray(new Object[size]);

        // 传入sql语句模板和模板所需的参数，插入User
        int num = jdbcTemplate.update(sql.toString(), params);
        System.out.println(num);
    }
}
```

###### 使用注解

```java
@Table("t_user")
public class User {
    private String name;
    private Integer age;
}
```

## 动态代理

### 概念

#### 静态代理和动态代理

##### 静态代理的不便之处

- 静态代理，代理类和目标类需要实现同一个接口。例如，接口Calculator的实现类有CalculatorImpl和CalculatorProxy。CalculatorProxy内部维护一个目标对象引用，如下：

  ```java
  /**
   * 静态代理类，实现Calculator接口
   */
  public class CalculatorProxy implements Calculator {
      // 代理对象内部维护一个目标对象引用
  	private Calculator target;
          
      // 通过构造方法，传入目标对象
  	public CalculatorProxy(Calculator target) {
  		this.target = target;
  	}
  
      // 调用目标对象的add，并在前后打印日志
  	@Override
  	public int add(int a, int b) {
  		System.out.println("add方法开始...");
  		int result = target.add(a, b);
  		System.out.println("add方法结束...");
  		return result;
  	}
  }
  ```

- 如果代理方法很多，存在很多重复代码。虽然这样已经满足了开闭原则

##### 动态代理

- 目标：省去编写静态代理类，总不能打印一个日志写一遍代理类，再来个需求也再写一遍吧。所以要只写增强代码，但是还有个问题需要解决，就是在不写代理类的前提下，如何获取目标对象。
- 解决办法：
  - 使用接口，接口只需要与目标对象具有同样的方法就可以。这是JDK动态代理
  - 使用目标类本身，这是CGLib动态代理

### JDK动态代理

#### 问题

- 使用反射只能得到接口的方法，因为接口没有构造器。

- Proxy.getProxyClass()可以返回代理Class对象，而不用实际编写代理类。

#### 实现

- 简单应用

  ```java
  public class ProxyTest {
      public static void main(String[] args) throws Throwable {
          Calculator calculatorProxy = (Calculator) JdkProxyFactory.getLogProxy(new CalculatorImpl());
          calculatorProxy.add(1, 2);
      }
  }
  
  // Jdk代理工厂
  class JdkProxyFactory {
      // 静态工厂方法
      public static Object getLogProxy(Object target) {
          return Proxy.newProxyInstance(
                  target.getClass().getClassLoader(),
                  target.getClass().getInterfaces(),
                  // 日志InvocationHandler
                  (proxy, method, args) -> {
                      System.out.println(method.getName() + "方法开始执行...");
                      Object res = method.invoke(target, args);
                      System.out.println(res);
                      System.out.println(method.getName() + "方法执行结束...");
                      return res;
                  }
          );
      }
  }
  ```
  
  - InvocationHandler的几个参数：
    - Object proxy：代理对象本身，一般不用
    - Method method：执行目标对象的方法
    - Obeject[] args：方法参数
  
- 本质上就是通过clone创建了一个有构造器的代理类，并将增强代码抽取出来作为InvocationHandler，最后两者进行解耦。

#### Proxy类原理

//TODO

### CGLIB 动态代理

#### 问题

-  JDK动态代理只能代理实现了接口的类，所以在Spring AOP中，如果目标对象实现了接口，则默认采用 JDK 动态代理，否则采用 CGLIB 动态代理。

#### 实现

```java
public class CglibProxyTest {
    public static void main(String[] args) {
        XCalculator xCalculator = (XCalculator) CglibProxyFactory.getLogProxy(XCalculator.class);
        xCalculator.add(1, 2);
    }
}

class LogMethodInterceptor implements MethodInterceptor {
    @Override
    public Object intercept(Object o, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
        System.out.println("before method " + method.getName());
        Object res = methodProxy.invokeSuper(o, args);
        System.out.println(res);
        System.out.println("after method " + method.getName());
        return res;
    }
}

class CglibProxyFactory {
    public static Object getLogProxy(Class<?> clazz) {
        Enhancer enhancer = new Enhancer();
        enhancer.setClassLoader(clazz.getClassLoader());
        enhancer.setSuperclass(clazz);
        enhancer.setCallback(new LogMethodInterceptor());
        return enhancer.create();
    }
}
```

- 本质上是生成了目标类的子类来拦截被代理类的方法调用，因此不能代理声明为 final 类型的类和方法。

### Spring AOC

- 简单应用：打印接口耗时

  ```java
  @Aspect
  @Component
  public class ApiTimeLogAspect {
      @Pointcut("execution(* controller.*.*(..))")
      public void controllerPointcut() {
      }
  
      @Around("controllerPointcut()")
      public Object doAround(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
          long startTime = System.currentTimeMillis();
          Object result = proceedingJoinPoint.proceed();
          HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
          String url = request.getRequestURL().toString();
          String reqParam = preHandle(proceedingJoinPoint, request);
          log.info("接口url: {}, 请求参数: {}, 耗时: {} ms", url, reqParam, System.currentTimeMillis() - startTime);
          return result;
      }
  
      private String preHandle(ProceedingJoinPoint joinPoint, HttpServletRequest request) {
          String reqParam = "";
          Annotation[] targetAnnotations = ((MethodSignature) joinPoint.getSignature()).getMethod().getAnnotations();
          for (Annotation annotation : targetAnnotations) {
              if (annotation.annotationType().equals(GetMapping.class)) {
                  reqParam = JSON.toJSONString(request.getParameterMap());
                  break;
              }
          }
          return reqParam;
      }
  }
  ```

  
