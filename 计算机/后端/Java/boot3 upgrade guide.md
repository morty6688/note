#### spring boot 3 upgrade guide

  - change each javax to jakarta (except javax.crypto)

  - change swagger to springdoc

    - annotation changes:
      - `@Api(tags= ` => `@Tag(name = `
      - `@ApiModel(value = ` => `@Schema(title = `
      - `@ApiModelProperty(value = ` => `@Schema(title = `
      - `@ApiOperation(value = "foo", notes = "bar") ` => `@Operation(summary = "foo", description = "bar") `
    - api encoding problem：https://github.com/springdoc/springdoc-openapi/issues/2143
    - [address](http://[host]:[port]/swagger-ui/index.htm)

  - mybatis-plus

    - dependency: 

      ```xml
      <dependency>
          <groupId>com.baomidou</groupId>
          <artifactId>mybatis-plus-spring-boot3-starter</artifactId>
          <version>3.5.5</version>
      </dependency>
      ```

    - change interceptor: 

      ```java
      @Bean
      public MybatisPlusInterceptor mybatisPlusInterceptor() {
          MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
          interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.POSTGRE_SQL));
          return interceptor;
      }
      ```

    - change some package name, sucha as `com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;`

- spring yaml file change:

  - change `spring.redis` to `spring,data.redis`
  - change `spring.profiles` to `spring.config.activate.on-profile`
  - `spring.main.allow-circular-references: true` to allow circular dependency


- Spring Security:

  - `authorizeRequests()`和`antMatchers()` need to be replaced with `authorizeHttpRequests()`和`requestMatchers()`

- convert  `ResourceProperties` to `WebProperties`. see this: https://github.com/spring-projects/spring-boot/issues/28762#issuecomment-978192961

- webflux:
  - error attributes:
    - previous method before spring boot 2.6:

      ```java
      boolean includeStackTrace = isIncludeStackTrace(request, MediaType.ALL);
      Map<String, Object> error = getErrorAttributes(request, includeStackTrace);
      ```

    - after 2.6:

      ```java
      ErrorAttributeOptions options = ErrorAttributeOptions
              .defaults()
              .including(ErrorAttributeOptions.Include.STACK_TRACE);
      Map<String, Object> error = getErrorAttributes(request, options);
      ```
- `HttpStatus` need to be replaced with `HttpStatusCode`: https://stackoverflow.com/questions/76273423/how-come-spring-webclient-onstatus-is-not-applicable-for-httpstatusis4xxclient

- Replace `org.springframework.core.LocalVariableTableParameterNameDiscoverer` which was deprecated with `org.springframework.core.DefaultParameterNameDiscoverer`
- in new version, `org.apache.tomcat.util.codec.binary.Base64` delete `encodeBase64(byte[] binaryData)` method, need to be replaced with `Base64.encodeBase64String(bytes).getBytes()`
- Apache HttpClient 5.x migration guide: https://hc.apache.org/httpcomponents-client-5.3.x/migration-guide/index.html. Many of the config items have been removed, just delete them
- 

