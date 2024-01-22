### 题号

```
175 176 177 178 180 181 182 183 184 196 596 620 626 627
```

### MySQL

- 简单

  - [627. Swap Salary](https://leetcode.cn/problems/swap-salary/)：update语句中`case...when...`的用法，或者也可以用if函数，更方便

    ```sql
    update Salary set sex = if(sex = 'm', 'f', 'm');
    ```

  - [620. Not Boring Movies](https://leetcode.cn/problems/not-boring-movies/)：这个题只有一个需要注意的地方，就是where子句中的`mod(id,2)=1`

  - [596. Classes More Than 5 Students](https://leetcode.cn/problems/classes-more-than-5-students/)：`group by`中`having`子句的用法，比子查询好得多

  - [182. Duplicate Emails](https://leetcode.cn/problems/duplicate-emails/)：这个跟上一题其实一样，只是找重复的记录就是`having count(email) > 1`

  - [196. Delete Duplicate Emails](https://leetcode.cn/problems/delete-duplicate-emails/)：这个很经典，删除之前最好先用select查看要删除的结果对不对。同时表连接自身可以找出所有某字段相同的记录。

  - [175. Combine Two Tables](https://leetcode.cn/problems/combine-two-tables/)：`left join`的简单示例

  - [181. Employees Earning More Than Their Managers](https://leetcode.cn/problems/employees-earning-more-than-their-managers/)：join的简单示例，与上题差不多

  - [183. Customers Who Never Order](https://leetcode.cn/problems/customers-who-never-order/)：还是`left join`，会保留右表相应字段为null的记录

- 中等

  - 

