### leetcode必刷题
#### 1. 参考
http://www.cyc2018.xyz/

- idea leetcode插件：

  - CodeFileName：

    ```
    $!velocityTool.camelCaseName(${question.titleSlug})
    ```

  - CodeTemplate：

    ```
    package leetcode.editor.cn;
    
    ${question.content}
    // 题目编号：${question.frontendQuestionId}
    public class $!velocityTool.camelCaseName(${question.titleSlug}){
        public static void main(String[] args) {
            Solution solution = new $!velocityTool.camelCaseName(${question.titleSlug})().new Solution();
        }
        
        ${question.code}
    }
    ```

#### 2. 题号

1. 全部

   ```
   1, 8, 9, 15, 17, 19, 20, 21, 24, 31, 34, 37, 39, 40, 43, 46, 47, 50, 51, 53, 55, 62, 64, 67, 69, 70, 72, 75, 77, 78, 79, 83, 84, 88, 90, 91, 93, 94, 95, 101, 104, 108, 109, 110, 111, 112, 113, 121, 122, 123, 127, 128, 130, 131, 136, 139, 141, 142, 144, 145, 147, 153, 155, 160, 162, 165, 167, 168, 169, 172, 179, 188, 189, 190, 198, 200, 204, 205, 206, 207, 208, 210, 213, 215, 216, 217, 224, 225, 226, 230, 231, 232, 234, 235, 236, 238, 240, 241, 242, 257, 260, 268, 278, 279, 283, 287, 292, 300, 303, 309, 316, 318, 322, 326, 328, 337, 338, 342, 343, 345, 347, 367, 371, 376, 377, 378, 392, 404, 405, 406, 409, 413, 415, 416, 417, 435, 437, 442, 451, 452, 455, 461, 462, 470, 474, 476, 485, 494, 496, 501, 503, 504, 513, 518, 524, 530, 538, 540, 543, 547, 560, 565, 566, 567, 572, 583, 594, 605, 617, 628, 633, 637, 645, 646, 647, 650, 662, 665, 667, 669, 671, 677, 680, 684, 687, 693, 695, 696, 697, 714, 725, 739, 743, 744, 763, 766, 769, 785, 1091, 1143
   ```

2. 依分类

   - 双指针：15, 88, 165, 167, 345, 524, 633, 680
   - 排序：75, 179, 215, 347, 451
   - 贪心：55, 121, 122, 392, 406, 435, 452, 455, 605, 665, 763
   - 二分：34, 69, 153, 162, 278, 540, 744
   - 分治：95, 241
   - 搜索：17, 31, 37, 39, 40, 46, 47, 51, 77, 78, 79, 90, 93, 127, 130, 131, 200, 216, 257, 279, 417, 547, 695, 1091
   - 动态规划：53, 62, 64, 70, 72, 91, 123, 139, 188, 198, 213, 279, 300, 303, 309, 322, 343, 376, 377, 413, 416, 474, 494, 518, 583, 646, 650, 714, 1143
   - 数学：50, 67, 168, 169, 172, 204, 238, 292, 326, 367, 405, 415, 462, 470, 504, 628
   - 链表：19, 21, 24, 83, 141, 142, 147, 160, 206, 234, 328, 725
   - 树：94, 101, 104, 108, 109, 110, 111, 112, 113, 144, 145, 208, 226, 230, 235, 236, 337, 404, 501, 513, 530, 538, 543, 572, 617, 637, 653, 662, 669, 671, 677, 687
   - 栈和队列：20, 155, 225, 232, 503
   - 哈希表：1, 128, 217, 594
   - 字符串：9, 205, 242, 409, 647, 696
   - 数组与矩阵：43, 189, 240, 283, 287, 378, 442, 485, 565, 566, 645, 667, 697, 766, 769
   - 图：207, 210, 684, 785
   - 位运算：136, 190, 231, 260, 268, 318, 338, 342, 371, 461, 476, 693
   - 单调栈：316, 496, 739
   - 滑动窗口：567
   - 前缀和：437, 560

3. SQL

   ```
   175, 176, 177, 178, 180, 181, 182, 183, 184, 196, 595, 596, 620, 626, 627
   ```


#### 3. 常用数据结构及写法

##### 3.1 栈/队列

###### 3.1.1 普通栈/队列

- java推荐使用Deque来实现栈和队列，Deque拥有两套API。其一为add/remove/element，会抛出异常，其二为offer/poll/peek，会返回特殊值，常用的为第一套。
- add相当于addLast，push相当于addFirst，remove和pop均相当于removeFirst，element相当于getFirst。因此当做栈来使用时，用push/pop/element或者addLast/removeLast/getLast；当做队列来使用时用add/remove/element。
- addLast/removeLast/getLast可以保证一个栈内的元素用new ArrayList<>(deque)转换后是正向打印出来的。适合backtrack或者dfs等场合要保存路径时应用。

###### 3.1.2 单调栈

- 递减栈用于寻找下一个更大元素，或上一个更大元素（逆序扫描）；

   同理，递增栈用于寻找下一个更小元素，或上一个更小元素（逆序扫描）。

   ```java
   // lc 496
   public int[] nextGreaterElement(int[] nums1, int[] nums2) {
       Map<Integer, Integer> nextGreaterElementMap = new HashMap<>();
   
       Deque<Integer> decreasingStack = new ArrayDeque<>();
       for (int num : nums2) {
           // 注意此处为while循环，且判断栈顶元素小于当前当前元素时出栈保证递减
           // 出栈元素的下一个更大元素即为当前元素
           while (!decreasingStack.isEmpty() && decreasingStack.element() < num) {
               nextGreaterElementMap.put(decreasingStack.pop(), num);
           }
           decreasingStack.push(num);
       }
   
       int[] result = new int[nums1.length];
       for (int i = 0; i < nums1.length; i++) {
           result[i] = nextGreaterElementMap.getOrDefault(nums1[i], -1);
       }
       return result;
   }
   ```

##### 3.2 堆

###### 3.2.1 堆本质

- 堆本质上讲就是一个完全二叉树，一般用数组来实现，可以方便的通过数组序号来定位堆节点。满足任意节点小于（或大于）它的所有后裔，最小元（或最大元）在堆的根上。

- heapify：建堆。heapify时间复杂度为O(n)，就是节点的总交换次数，等于每层的节点数乘以每个节点最多交换的次数，可以由等比数列求和推导出来。

  - siftDown：核心操作，以最大堆为例，为从root节点开始，依次将其与子节点比较，如果小于则交换值，接着递归的比较子节点。由于建堆操作通常是自底向上的，这样可以使root节点值保持最大。

- 经典问题：topK

  - 要取前K个最大值，典型思路就是建一个最大堆，将所有元素add入堆，最后remove出前K个，但是这样容易耗空间；因此也可以建容量为k的最小堆，add和remove同时用，动态的得到topK，但是这样执行了更多的remove操作。
  - topK问题也可以用快排的思路来解决

- 原理实现如下，工程中java实际使用PriorityQueue：

  ```java
  private void heapify(int[] nums, int heapSize) {
      for (int i = heapSize / 2; i >= 0; i--) {
          siftDown(nums, i, heapSize);
      }
  }
  
  private void siftDown(int[] nums, int root, int heapSize) {
      int l = 2 * root + 1, r = 2 * root + 2, largest = root;
      if (l < heapSize && nums[l] > nums[largest]) {
          largest = l;
      }
      if (r < heapSize && nums[r] > nums[largest]) {
          largest = r;
      }
      if (largest != root) {
          swap(nums, root, largest);
          siftDown(nums, largest, heapSize);
      }
  }
  ```

##### 3.3 二叉树

###### 3.3.1 各种遍历的非递归写法

- 先序遍历

  ```java
  public void preOrder(TreeNode root) {
      Deque<TreeNode> stack = new ArrayDeque<>();
      while (root != null || !stack.isEmpty()) {
          while (root != null) {
              /* do sth. about root.val */
  
              //先访问再入栈
              stack.push(root);
              root = root.left;
          }
          //如果是null，出栈并处理右子树
          root = stack.pop().right;
      }
  }
  ```

- 中序遍历

  ```java
  // 跟上述区别是先入栈再访问，会了一个很快就会另一个
  public void inOrder(TreeNode root) {
      Deque<TreeNode> stack = new ArrayDeque<>();
      while (root != null || !stack.isEmpty()) {
          while (root != null) {
              stack.push(root);
              root = root.left;
          }
          
          root = stack.pop();
          /* do sth. about root.val */
  
          root = root.right;
      }
  }
  ```

- 后序遍历

  ```java
  public void postOrder(TreeNode root) {
      Deque<TreeNode> stack = new ArrayDeque<>();
      TreeNode pre = null;
      while (!stack.isEmpty() || root != null) {
          while (root != null) {
              stack.push(root);
              root = root.left;
          }
          root = stack.pop();
          // 右子树存在 && 未访问过
          if (root.right != null && root.right != pre) {
              // 重复压栈以记录当前路径分叉节点
              stack.push(root);
              root = root.right;
          } else {
              // 此时node的左右子树应均已完成访问
              /* do sth. about root.val */
  
              // 避免重复访问右子树
              pre = root;
              // 避免重复访问左子树
              root = null;
          }
      }
  }
  ```

#### 4. 常用算法模板

##### 4.1 排序

###### 4.1.1 堆排序

​	堆定义见[3.2 堆](#3.2 堆)

- ```java
  // 从小到大排序，建最大堆
  public int[] heapSort(int[] nums) {
      int heapSize = nums.length;
      heapify(nums, heapSize);
      for (int i = nums.length - 1; i >= 0; i--) {
          // 将最大元素挪至结尾
          swap(nums, 0, i);
          heapSize--;
          // 保证堆顶元素的最大
          siftDown(nums, 0, heapSize);
      }
      return nums;
  }
  ```

###### 4.1.2 快速排序

​		快速排序采用分治的思想，每一次partition将一个pivot的放到其正确的位置上，随后递归的处理左右两半。partition函数使用双指针处理pivot并最终返回其正确序号。

- ```java
  private void quickSort(int[] a, int left, int right) {
      if (left >= right) {
          return;
      }
      int index = partition(a, left, right);
      quickSort(a, left, index - 1);
      quickSort(a, index + 1, right);
  }
  
  private int partition(int[] a, int left, int right) {
      int randomI = random.nextInt(right - left + 1) + left;
      swap(a, randomI, right);
  
      int pivot = a[right];
      int i = left - 1;
      for (int j = left; j < right; j++) {
          if (a[j] <= pivot) {
              i++;
              // 保证i位置上一定是比pivot小的数
              swap(a, i, j);
          }
      }
      swap(a, i + 1, right);
      return i + 1;
  }
  ```

###### 4.1.3 归并排序

​		归并排序同样为分治的思想，只是每次将左右两边的subList排序好，最后通过merge两个有序的subList得到最终结果。

- 对数组的归并简单的方法是建立一个新数组进行copy，核心方法如下：

  ```java
  private void mergeSort(int[] nums, int left, int right) {
      int mid = left + (right - left) / 2;
      if (left < right) {
          mergeSort(nums, left, mid);
          mergeSort(nums, mid + 1, right);
          merge(nums, left, mid, right);
      }
  }
  
  private void merge(int[] nums, int left, int mid, int right) {
      int[] temp = new int[right - left + 1];
      int i = left, j = mid + 1, k = 0;
      while (i <= mid && j <= right) {
          if (nums[i] < nums[j]) {
              temp[k++] = nums[i++];
          } else {
              temp[k++] = nums[j++];
          }
      }
      while (i <= mid) {
          temp[k++] = nums[i++];
      }
      while (j <= right) {
          temp[k++] = nums[j++];
      }
  
      System.arraycopy(temp, 0, nums, left, temp.length);
  }
  ```

- merge in place方法如下：

  ```java
  // TODO：添加原理
  private void merge(int[] nums, int left, int mid, int right) {
      int i = left, j = mid + 1;
      while (i < j && j <= right) {
          while (i < j && nums[i] <= nums[j]) {
              i++;
          }
          int index = j;
          while (j <= right && nums[j] <= nums[i]) {
              j++;
          }
          swapAdjacentBlocks(nums, i, index - i, j - index);
          i += (j - index);
      }
  }
  
  private void swapAdjacentBlocks(int arr[], int bias, int oneSize, int anotherSize) {
      reverse(arr, bias, bias + oneSize - 1);
      reverse(arr, bias + oneSize, bias + oneSize + anotherSize - 1);
      reverse(arr, bias, bias + oneSize + anotherSize - 1);
  }
  ```

##### 4.2 搜索

###### 4.2.1 二分

- 选择搜索区：二分搜索关键在于通过mid值与low值或high值的比较，确定要搜索的目标值在list的哪边，如果没法确定则无法搜索。

  - 标准二分如下，能准确找到target值，搜索条件为l <= h：

    ```java
    while (l <= h) {
        int m = l + (h - l) / 2;
        if (nums[m] == key) {
            return m;
        } else if (nums[m] > key) {
            h = m - 1;
        } else {
            l = m + 1;
        }
    }
    ```

  - 若选择搜索区时需要保留mid值，则循环结束时low一定等于high：

      ```java
      // 循环结束时low一定等于high
      while (low < high) {
          int mid = low + (high - low) / 2;
          if (.....) {
              high = mid;
          } else {
              low = mid + 1;
          }
      }
      ```

  - 还有一些要求另类的，比如第一个大于target的数：

      ```java
      // res初始化为nums.length是因为可能数组中所有数字都比target小
      int low = 0, high = nums.length - 1, res = nums.length;
      while (left <= right) {
          int mid = low + (high - low) / 2;
          if (nums[mid] > target) {
              right = mid - 1;
              // 其实跟标准二分一样，只是在循环过程中记录结果
              res = mid;
          } else {
              left = mid + 1;
          }
      }
      ```

      

- 搜索条件，二分的搜索条件至关重要，不同的搜索条件决定了能不能确定搜索区，一些特殊的搜索条件如下：

  - lc 162，[寻找峰值](https://leetcode-cn.com/problems/find-peak-element/)：条件为 nums[mid] > nums[mid + 1]。
  - lc 153，[寻找旋转排序数组中的最小值](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/)：条件为 nums[mid] < nums[high]。详细解释见：https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/solution/er-fen-cha-zhao-wei-shi-yao-zuo-you-bu-dui-cheng-z/

###### 4.2.2 backtrack

- backtrack本质上是一种dfs，不同之处在于**dfs通常解决可达性问题，到出口了直接返回；backtrack通常解决排列组合问题，需保存中间结果，之后继续递归。**

  - 所以进入下一层递归时，需要将某元素标记为访问过，而返回上一层递归时，需要将访问标记删除

  - 典型示例：lc 46，[全排列](https://leetcode-cn.com/problems/permutations/)

    ```java
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        backtrack(res, nums, 0);
        return res;
    }
    
    // backtrack需要一个pos变量表示当前位置，还需要一个队列来保存中间结果。本例中，nums是swap in place的，因此省略了这个队列
    private void backtrack(List<List<Integer>> res, int[] nums, int pos) {
        res.add(Arrays.stream(nums).boxed().collect(Collectors.toList()));
        for (int i = pos; i < nums.length; i++) {
            for (int j = i + 1; j < nums.length; j++) {
                // 进入下一层递归前改变中间结果
                swap(nums, i, j);
                backtrack(res, nums, i + 1);
                // 返回上一层递归前还原
                swap(nums, i, j);
            }
        }
    }
    ```

  - 典型示例2：lc 39，[组合总和](https://leetcode-cn.com/problems/combination-sum/)
  
    ```java
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> res = new ArrayList<>();
        backtrack(candidates, target, res, 0, new ArrayDeque<>());
        return res;
    }
    
    private void backtrack(int[] candidates, int target, List<List<Integer>> res, int pos, Deque<Integer> deque) {
        if (target <= 0) {
            if (target == 0) {
                res.add(new ArrayList<>(deque));
            }
        } else {
            for (int i = pos; i < candidates.length; i++) {
                deque.addLast(candidates[i]);
                backtrack(candidates, target - candidates[i], res, i, deque);
                deque.removeLast();
            }
        }
    }
    ```
  
    

