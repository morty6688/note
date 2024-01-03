### leetcode必刷题
#### 参考
- http://www.cyc2018.xyz/


- idea leetcode插件：

  - 选中Custom Template

  - CodeFileName：
  
    ```
    $!velocityTool.camelCaseName(${question.titleSlug})
    ```

  - CodeTemplate：
  
    ```
    package leetcode.editor.cn;
    
    ${question.content}
    
    // [${question.frontendQuestionId}]${question.title}
    public class $!velocityTool.camelCaseName(${question.titleSlug}){
        public static void main(String[] args) {
            Solution solution = new $!velocityTool.camelCaseName(${question.titleSlug})().new Solution();
        }
        
        ${question.code}
    }
    ```
  

#### 题号

1. 全部

   ```
   leetcode：
   1    3    5    8    9    11    15    17    19    20    21    22    23    24    31    33    34    37    39    40    42    43    46    47    48    49    50    51    53    54    55    56    62    64    67    69    70    72    75    76    77    78    79    83    84    88    90    91    93    94    95    96    98    101    102    104    105    108    109    110    111    112    113    121    122    123    127    128    130    131    135    136    139    141    142    144    145    146    147    148    151    152    153    154    155    160    162    165    167    168    169    172    179    188    189    190    198    200    204    205    206    207    208    210    213    215    216    217    221    224    225    226    230    231    232    234    235    236    238    240    241    242    257    260    268    278    279    283    287    292    300    303    309    316    318    322    326    328    337    338    342    343    345    347    367    371    376    377    378    392    394    404    405    406    409    413    415    416    417    435    437    438    442    448    451    452    455    461    462    470    474    476    485    494    496    501    503    504    513    518    524    530    538    540    543    547    560    565    566    567    572    581    583    594    605    617    621    628    633    637    645    646    647    650    662    665    667    669    671    677    680    684    687    693    695    696    697    714    725    739    743    744    763    766    769    785    912    946    1091    1143

   剑指offer：
   9    13    32    53    59    62
   ```

2. 依分类

   - 双指针：15    88    165    167    283    345    524    581    633    680

   - 排序：56    75    147    148    179    215    347    451    912

   - 贪心：11    55    135    122    300    392    406    435    452    455    605    621    665    763

   - 分治：95    241

   - 搜索：37    40    47    51    78    90    127    130    131    200    216    257    417    547    695    1091    剑-13

      - 二分：33    34    69    153    154    162    278    540    744    剑-53 

     - backtrack：17    22    39    46    77    93
     
     - dfs：79 
     
   - 动态规划：5    42    53    62    64    70    72    91    121    123    139    152    188    198    213    221    279    309    322    343    376    377    413    474    518    583    646    647    650    714    1143

     - 背包：416    494 
     
   - 数学：50    67    96    168    169    172    204    238    279    292    326    343    367    405    415    462    470    504    628    剑-62

   - 链表：19    21    23    24    83    141    142    160    206    234    328    725

   - 树：94    98    101    102    104    105    108    109    110    111    112    113    144    145    226    230    235    236    337    404    501    513    530    538    543    572    617    637    653    662    669    671    677    687    剑-32(103)    剑-59
      - 层序遍历：
      - 特殊的树：208 
      
   - 栈和队列：20    146    155    224    225    232    503    946    剑-9
   
      - 单调栈：42    84    316    496    739
   
   - 哈希表：1    49    128    217    448    594
   
   - 字符串：8    9    151    205    242    394    409    696
   
   - 数组与矩阵：31    43    48    54    189    240    287    378    442    485    565    566    645    667    697    766    769

   - 图：207    210    684    785
   
   - 位运算：136    190    231    260    268    318    338    342    371    461    476    693
   
   - 滑动窗口：3    76    438    567
   
   - 前缀和：303    437    560

#### 常用数据结构及写法

##### 数组

- 一些奇怪套路的典型题：
  - [[31]Next Permutation](https://leetcode-cn.com/problems/next-permutation/)：有很奇怪的套路，需要先从后向前找一个升序相邻数对(i, j)，然后向后找第一个比i大的数记为k，交换i和k，然后reverse从i+1到结尾的元素。
  - **数组环形链表**：如果数组里只包括数组索引，则可以将数组看成链表，如果出现重复索引，则可以看成环形链表
    - [[287]Find the Duplicate Number](https://leetcode.cn/problems/find-the-duplicate-number/)：本题即可将数组看成环形链表，使用快慢指针解决

##### 双指针

- 双指针类题目可以认为是数组题目的一个特殊情况。起手式为`int i=0, j=n-1`，后续根据不同情况分别进行`i++`或者`j--`操作

- 典型应用为快排中的`partition`函数，见[快速排序](# 快速排序)

- 其他典型题：

  - [[15]3Sum](https://leetcode.cn/problems/3sum/)：这题思路其实很简单，比较烦的去除重复元素时的细节处理。这个题细节处理有以下几点需要注意：

    - 外层指针`int i`的循环条件为`i < n - 2`，这个好理解，因为结果里至少需要三个数。同时尽量用`while`循环，如果用`for`循环会导致外层循环和内层循环去重逻辑不一致，外层不能写`i++`，很别扭，见下一条

    - 外层去重逻辑，注意这里是`if`条件判断，相当于每次跳过一个重复值：

      ```java
      if (i > 0 && nums[i] == nums[i - 1]) {
          i++;
          continue;
      }
      ```

      同样的，内层也是该逻辑：

      ```java
      if (j > i + 1 && nums[j] == nums[j - 1]) {
          j++;
          continue;
      }
      ```

    - （**不要用**）上面的`if`条件判断能否改成`while`循环？事实上外层的可以改，写法如下所示：

      ```java
      while (i > 0 && i < n - 2 && nums[i] == nums[i - 1]) {
          i++;
      }
      ```

      - 那么内层的能不能改成这样？并不能，考虑`[-2,-1,-1,0,0,1,2,3]`，假如内层也改了的话，经过两次循环j和k都会指向其中的1，这样结果中会出现`[-2,1,1]`这个错误的数组。因此不要这样改，增加了复杂度，结果还不对

##### 矩阵

- 一些奇怪套路的典型题：
  - [[48]Rotate Image](https://leetcode.cn/problems/rotate-image/)：两次翻转即可。只需要注意水平翻转时i的范围只有一半，对角线翻转时j的范围取决于i的范围。
  - [[240]Search a 2D Matrix II](https://leetcode.cn/problems/search-a-2d-matrix-ii/)：这个题直观的解法是对每一行二分搜索，复杂度O(mlogn)。更简单的解法是从右上角开始搜索，迭代时(i++, j--)。

##### 链表

- 单链表部分的题，包括合并、反转等等操作之类的没啥难的；判定是否有环就用快慢指针，也没啥难的
- 典型题：
  - [[160]Intersection of Two Linked Lists](https://leetcode.cn/problems/intersection-of-two-linked-lists/)：本题有一个很取巧的解法是两个指针先顺着链表遍历，到结尾了再跳到另一个链表。两个指针相遇在节点处即为有交叉，相遇在null则没有

##### 哈希表

###### 普通哈希表

- 本身没啥好说的，空间换时间的哈希表
- 典型题：
  - [[128]Longest Consecutive Sequence](https://leetcode-cn.com/problems/longest-consecutive-sequence/)：本题除了hashmap，还可以用dp和并查集。


###### 滑动窗口

- 通常会需要两个map(need和window)，表示各字符的计数器。need为我们需要的，window为当前窗口中包含的。为了比较两个窗口的数量，我们通常还需要一个valid计数。伪代码如下：

  ```java
  int left = 0, right = 0;
  
  while (right < s.size()) {
      // 增大窗口
      window.put(c, need.getOrDefault(c, 0) + 1);
      right++;
      
      while (window needs shrink) {
          // 缩小窗口
          window.put(d, window.getOrDefault(d, 0) - 1);
          left++;
      }
  }
  ```

- 典型题：

  - [[76]Minimum Window Substring](https://leetcode.cn/problems/minimum-window-substring/)：最基本的题，需要添加start和len比较并记录子串
  - [[3]Longest Substring Without Repeating Characters](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)：本题不需要need和valid，只需要注意什么时候收缩窗口和更新result就可以
  

##### 栈/队列

###### 普通栈/队列

- java推荐使用Deque来实现栈和队列，Deque拥有两套API。其一为add/remove/element，会抛出异常，其二为offer/poll/peek，会返回特殊值，常用的为第一套。
- add相当于addLast，push相当于addFirst，remove和pop均相当于removeFirst，element相当于getFirst。因此当做栈来使用时，用push/pop/element或者addLast/removeLast/getLast；当做队列来使用时用add/remove/element。
- **addLast/removeLast/getLast可以保证一个栈内的元素用new ArrayList<>(deque)转换后是正向打印出来的。适合backtrack或者dfs等场合要保存路径时应用。**

###### 单调栈

- 递减栈用于寻找[[496]Next Greater Element I](https://leetcode.cn/problems/next-greater-element-i/)，或上一个更大元素（逆序扫描）；

   同理，递增栈用于寻找下一个更小元素，或上一个更小元素（逆序扫描）。

   ```java
   // [496] core code
   Deque<Integer> decreasingStack = new ArrayDeque<>();
   for (int num : nums2) {
       // pay attention to the while loop
       // the next greater element of the popped element is num 
       while (!decreasingStack.isEmpty() && decreasingStack.element() < num) {
           nextGreaterElementMap.put(decreasingStack.pop(), num);
       }
       decreasingStack.push(num);
   }
   ```
   
   - 典型题：
     - [[42]Trapping Rain Water](https://leetcode.cn/problems/trapping-rain-water/)：本题使用单调栈解法时，是分层求解雨水的量。使用递减栈寻找下一个更大的元素，可以得到比当前元素大的左右边柱子，不断循环即可得到每层雨水的量。使用单调栈解法的理解难度更高，建议优先考虑dp。
   
     - [[84]Largest Rectangle in Histogram](https://leetcode-cn.com/problems/largest-rectangle-in-histogram/)：本题关键在于利用递增栈可以同时找到左右两边第一个比当前元素小的柱子，可以构成矩形；同时我们可以添加两个哨兵（高度为0的柱子），这样不用去判断栈为空的情况。
   
     - [[316]Remove Duplicate Letters](https://leetcode.cn/problems/remove-duplicate-letters/)：本题使用递增栈来保证栈内元素字典序最小，关键在于记录重复元素最后一次出现的位置和访问记录。元素已经在栈中直接跳过，如果遍历过程中某栈顶元素不是最后一次出现且不满足递增栈性质，就将其移除出栈。

##### 堆

###### 堆本质

- 堆本质上讲就是一个完全二叉树，一般用数组来实现，可以方便的通过数组序号来定位堆节点。满足任意节点小于（或大于）它的所有后裔，最小元（或最大元）在堆的根上。

- heapify：建堆。heapify时间复杂度为O(n)，就是节点的总交换次数，等于每层的节点数乘以每个节点最多交换的次数，可以由等比数列求和推导出来。

  - siftDown：核心操作，以最大堆为例，为从root节点开始，依次将其与子节点比较，如果小于则交换值，接着递归的比较子节点。由于建堆操作通常是自底向上的，这样可以使root节点值保持最大。

- 经典问题：[[215]Kth Largest Element in an Array](https://leetcode.cn/problems/kth-largest-element-in-an-array/)

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

##### 树

###### 各种遍历的非递归写法

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
          //如果是null，出栈并处理右子树（注意这个地方不需要对right进行判空，否则无法跳出循环）
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

###### 层次遍历

- 标准层次遍历非常简单，不再赘述。层次遍历中有几种特殊情况需要注意，如下：

  - 记录每层节点：遍历每一层时通过`queue.size()`来确定遍历几次，此处需要用一个**局部变量**来保存这个size，不然size会变
  - 记录节点编号：使用WrapNode将节点再包一层

###### 其他问题

- 基本问题：反转二叉树，树的深度，是否对称二叉树，前序中序建树

  - [[108]Convert Sorted Array to Binary Search Tree](https://leetcode.cn/problems/convert-sorted-array-to-binary-search-tree/)：本题要把有序数组组成二叉搜索平衡树，因为其中序遍历一定有序，所以可以考虑二分，mid一定是根

- 二叉树的公共祖先（LCA问题）：按是否二叉搜索树来区分难度，该题及其容易忘记，建议多做几遍

  - 如果是搜索树，思路比较简单

  - 如果不是搜索树，[[236]Lowest Common Ancestor of a Binary Tree](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/)：

    ```java
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || root == p || root == q) {
            return root;
        }
    	// 递归过程中可能找不到两者的公共祖先，而只能找到其中一个的祖先
        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);
        if (left == null) {
            return right;
        }
        if (right == null) {
            return left;
        }
        return root;
    }
    ```

- 路径和问题：先看是不是从根节点到叶节点的路径

  - [[112]Path Sum](https://leetcode-cn.com/problems/path-sum/)：判断是否存在路径和，简单递归就可以了
  - [路径总和 II](https://leetcode-cn.com/problems/path-sum-ii/)：输出全部路径，backtrack思路

  - [[437]Path Sum III](https://leetcode.cn/problems/path-sum-iii/)：不要求从根节点到叶节点，需要在遍历的途中对每个节点寻找路径，直到叶节点返回，中间变量需要用long防止溢出。更好的思路是用前缀和，用一个map记录每个prefixSum出现的次数，然后查找curSum-target就可以得到以该节点为终点的路径条数。

- [树的子结构](https://leetcode-cn.com/problems/shu-de-zi-jie-gou-lcof/)：看起来不难，写起来很无语

##### 并查集

###### 定义

- // TODO

  ```java
  class UnionFindSet {
      int[] parents;
  
      public UnionFindSet(int n) {
          parents = new int[n];
          for (int i = 0; i < n; i++) {
              // each element is its own parent
              parents[i] = i;
          }
      }
  
      public int find(int x) {
          if (parents[x] == x) {
              return x;
          }
          return parents[x] = find(parents[x]);
      }
  
      public void union(int x, int y) {
          int px = find(x);
          int py = find(y);
          if (px != py) {
              parents[px] = py;
          }
      }
  }
  ```

##### 图

###### 定义

- 图可以用邻接表或邻接矩阵表示。邻接矩阵就是一个二维数组，如果节点很多的话，会导致数组占据很多空间，除非这个数组是入参，否则我们一般不采用这种初始化方式；邻接表相对的会好很多，初始化方式如下：

  ```
  
  ```


##### 前缀和

###### 定义

- 这个定义很简单，就是对于nums数组来说建立一个prefixSum数组。然后有`prefixSum[i + 1] = prefixSum[i] + nums[i]`
- 然后前缀和数组建立之后，可以通过`i == 0 ? dp[j] : dp[j] - dp[i - 1]`直接求出区间`(i, j)`的和，就像[[303]Range Sum Query - Immutable](https://leetcode.cn/problems/range-sum-query-immutable/)中实现的API

#### 常用算法模板

##### 排序

###### 堆排序

​	堆定义见[堆](# 堆)

- ```java
  public int[] heapSort(int[] nums) {
      // 从小到大排序，建最大堆
      heapify(nums, nums.length);
      for (int i = nums.length - 1; i >= 0; i--) {
          // 将最大元素挪至结尾
          swap(nums, 0, i);
          // 保证堆顶元素的最大
          siftDown(nums, 0, i);
      }
      return nums;
  }
  ```

###### 快速排序

​	快速排序采用分治的思想，每一次partition将一个pivot的放到其正确的位置上，随后递归的处理左右两半。partition函数使用双指针处理pivot并最终返回其正确序号。

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
      // 尤其注意这个i和j的设置，别写成-1和0
      int i = left - 1, j = left;
      // all in [0, i] <= pivot
      while (j < right) {
          if (a[j] <= pivot) {
              swap(a, ++i, j);
          }
          j++;
      }
      swap(a, i + 1, right);
      return i + 1;
  }
  ```
  
  - partition函数的另一个典型用法是[[75]Sort Colors](https://leetcode-cn.com/problems/sort-colors/)，比快排中的partition多了一个指针，将数组分为三个区间，解法如下：
  
    ```java
    public void sortColors(int[] nums) {
        // i points to 0, k points to 2
        int i = -1, k = nums.length;
        int j = 0;
        while (j < k) {
            if (nums[j] == 0) {
                swap(nums, ++i, j++);
            } else if (nums[j] == 1) {
                j++;
            } else {
                // here j shouldn't be incremented
                // cuz the latter 0 may be swapped
                swap(nums, --k, j);
            }
        }
    }
    ```
  

###### 归并排序

​	归并排序同样为分治的思想，只是每次将左右两边的subList排序好，最后通过merge两个有序的subList得到最终结果。

- 首先是数组：

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

- 然后是链表：

  - 题目：[[148]Sort List](https://leetcode.cn/problems/sort-list/)，链表排序不使用额外空间的话，只能用归并。堆排序需要额外的堆空间，快排需要记录每个节点的序号，都不合适
  - 链表的话不像数组那样需要开辟额外空间，merge函数的参数只需要两个子链表的头结点，而且用一个dummy节点记录最后结果即可
  - 数组可以直接得到mid，链表的话需要使用快慢指针确定mid。最外层调用为`sortList(head, null)`，不包括末尾节点。所以子链表前半和后半直接为`sortList(head, mid)`，`sortList(mid, tail)`

###### 特殊排序

- [[56]Merge Intervals](https://leetcode-cn.com/problems/merge-intervals/)，按区间左端点排序可以使得要合并的区间连续，之后根据右端点merge即可。
- [[179]Largest Number](https://leetcode.cn/problems/largest-number/)：这个题排序规则非常特殊，需要先将各个数字转为字符串，然后按`(a, b) -> (b + a).compareTo(a + b)`排序，之后连接每个数字即可。证明的话需要证明充分性和必要性，充分性用反证法证明，必要性需要证明传递性和完全性。除了这个之外，还有一个边界条件需要处理：当排序后字符数组第一个字符串是`"0"`，那么需要直接返回0，因为此时说明结果就是0。

##### 搜索

###### 二分

- 选择搜索区：二分搜索关键在于通过mid值与low值或high值的比较，确定要搜索的目标值在list的哪边，如果没法确定则无法搜索。

  - 标准二分如下，能准确找到target值或者插入target所在位置，搜索条件为low <= high（需要添加等号，想象一下只有一个元素的情况）：

    ```java
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (nums[mid] == key) {
            return mid;
        } else if (nums[mid] > key) {
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }
    ```

  - **若选择搜索区时需要保留mid值，则循环结束时low一定等于high**：

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

- 搜索条件，二分的搜索条件至关重要，不同的搜索条件决定了能不能确定搜索区，一些特殊的搜索条件如下：

  - [[剑-53] II. 0～n-1中缺失的数字](https://leetcode-cn.com/problems/que-shi-de-shu-zi-lcof/)：建议先想一想
  - [[162]Find Peak Element](https://leetcode-cn.com/problems/find-peak-element/)：条件为 nums[mid] > nums[mid + 1]
  - 旋转数组：
    - [[153]Find Minimum in Rotated Sorted Array](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/)：条件为 nums[mid] < nums[high]
      - 旋转数组问题，如果nums[mid]<nums[high]，则[mid, high]一定为右侧单调递增区间；如果nums[low]<nums[mid]，则[low, mid]一定为左侧单调递增区间。详细解释见[[Link]](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/solution/er-fen-cha-zhao-wei-shi-yao-zuo-you-bu-dui-cheng-z/)
    - [154]，跟[153]几乎一样，区别是有重复值，处理方法也很简单粗暴，发现相等的时候直接right-1。
    - [[33]Search in Rotated Sorted Array](https://leetcode-cn.com/problems/search-in-rotated-sorted-array/)：第一个条件与[153]一致，之后需要确定target是否在单调递增区间内，需要两步条件判断（要特别注意本题的**等号**）；本题还可以先用上一题思路找到最小值，然后通过取余还原旋转数组。
    - [[34]Find First and Last Position of Element in Sorted Array](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array)：用两次标准二分来分别搜索第一个和最后一个target。区别只是在等于target时，不结束搜索，而是继续向左半边或右半边搜
  

###### backtrack

- backtrack本质上是一种dfs，不同之处在于**dfs通常解决可达性问题，到出口了直接返回；backtrack通常解决排列组合问题，需保存中间结果，之后继续递归。**

  - 通常用一个栈（一般用Deque，结果容易处理）来保存中间结果。所以进入下一层递归时，需要将某元素标记为访问过，而返回上一层递归时，需要将访问标记删除

  - 通常需要一个pos变量表示当前位置，表示进入下一层时从哪个位置开始

  - 典型题：
  
    - [[17]Letter Combinations of a Phone Number](https://leetcode.cn/problems/letter-combinations-of-a-phone-number/)：比较简单
  
    - [[46]Permutations](https://leetcode-cn.com/problems/permutations/)
    
      ```java
      // backtrack需要一个pos变量表示当前位置，还需要一个栈来保存中间结果。本例中，nums是swap in place的，因此省略了这个队列
      private void backtrack(List<List<Integer>> res, int[] nums, int pos) {
          if (pos == nums.length - 1) {
              res.add(Arrays.stream(nums).boxed().collect(Collectors.toList()));
              return;
          }
      
          // 注意从pos开始，pos之前的位置元素均已固定
          for (int i = pos; i < nums.length; i++) {
              // 进入下一层递归前改变中间结果
              swap(nums, i, pos);
              backtrack(res, nums, pos + 1);
              // 返回上一层递归前还原
              swap(nums, i, pos);
          }
      }
      
      // 另外一种写法
      private void backtrack(List<List<Integer>> res, int[] nums, int pos) {
          res.add(Arrays.stream(nums).boxed().collect(Collectors.toList()));
          for (int i = pos; i < nums.length; i++) {
              for (int j = i + 1; j < nums.length; j++) {
                  swap(nums, i, j);
                  backtrack(res, nums, i + 1);
                  swap(nums, i, j);
              }
          }
      }
      ```
  
    - [[39]Combination Sum](https://leetcode-cn.com/problems/combination-sum/)：比较典型的题，可以重复利用元素，要注意进入下一层pos的值
    
    
      - [[22]Generate Parentheses](https://leetcode-cn.com/problems/generate-parentheses/)：本题的一个特殊之处在于有两个pos，左括号和右括号，因此解法略有不同
      - [[剑-38]字符串的排列](https://leetcode-cn.com/problems/zi-fu-chuan-de-pai-lie-lcof/)：本题跟上题不一样的是，要对结果去重
    
  

###### dfs

- 典型题：

  - [[79]Word Search](https://leetcode-cn.com/problems/word-search/)，是二维网格的一种典型dfs题，模板十分固定，如下所示：
  
    ```java
    public boolean exist(char[][] board, String word) {
        int[][] directions = new int[][]{{-1, 0}, {1, 0}, {0, 1}, {0, -1}};
        int m = board.length, n = board[0].length;
        boolean[][] visited = new boolean[m][n];
    
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (dfs(board, m, n, i, j, word, 0, visited, directions)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    private boolean dfs(char[][] board, int m, int n, int i, int j, String word, int k, boolean[][] visited, int[][] directions) {
        if (k == word.length()) {
            return true;
        }
        if (i < 0 || i >= m || j < 0 || j >= n || visited[i][j] || board[i][j] != word.charAt(k)) {
            return false;
        }
        visited[i][j] = true;
        for (int[] direction : directions) {
            if (dfs(board, m, n, i + direction[0], j + direction[1], word, k + 1, visited, directions)) {
                return true;
            }
        }
        visited[i][j] = false;
        return false;
    }
    ```
  
  - 这种问题需要注意的点在于visited数组的处理和控制return。比如：[[剑-13]机器人的运动范围](https://leetcode-cn.com/problems/ji-qi-ren-de-yun-dong-fan-wei-lcof/)，和上题细节不太一样


###### bfs

- 与dfs区别只是搜索方式不一样：[[200]Number of Islands](https://leetcode-cn.com/problems/number-of-islands/)

- 能解决的问题比较有限

  ```java
  private void bfs(char[][] grid, int m, int n, int[][] directions, boolean[][] visited, int i, int j) {
      var queue = new ArrayDeque<int[]>();
      queue.add(new int[]{i, j});
      visited[i][j] = true;
      while (!queue.isEmpty()) {
          var node = queue.remove();
          // bfs这个visited无法回溯清除，只能解决某些问题，比如这个岛屿问题，无法应对单词搜索等问题，建议优先使用dfs
          visited[i][j] = false;
          for (var direction : directions) {
              int x = node[0] + direction[0], y = node[1] + direction[1];
              if (x < 0 || x >= m || y < 0 || y >= n || visited[x][y] || grid[x][y] != '1') {
                  continue;
              }
              grid[x][y] = '2';
              queue.add(new int[]{x, y});
              visited[x][y] = true;
          }
      }
  }
  ```


##### 动态规划

- 当前状态只由前置状态决定，不会被未来影响

###### 数组

- 典型题：

  - 简单问题：

    - [[53]Maximum Subarray](https://leetcode-cn.com/problems/maximum-subarray/)：只需要保存一个preMax表示之前最大的和，即可比较得出当前的最大和：

      ```java
      public int maxSubArray(int[] nums) {
          int res = nums[0], preMax = nums[0];
          for (int i = 1; i < nums.length; i++) {
              preMax = Math.max(nums[i], preMax + nums[i]);
              res = Math.max(res, preMax);
          }
          return res;
      }
      ```

    - [[322]Coin Change](https://leetcode.cn/problems/coin-change/)：本题思路很简单，只是需要注意初始化dp数组时，可以设置从1到amount的初始值都是amount+1，因为面值为amount的硬币最多也只能兑换为额度都是1的硬币，所以数量上限不可能超过amount。

    - 对从2到n的所有数分解质因数，并统计全部质因数个数（例如输入4，输出4。因为2和3分解后都是1个质因数，4=2*2有两个质因数，所以总共是4个）：本题也是典型的数组动态规划，思路比较简单。唯一需要注意的可能是质数搜索范围为2到`sqrt{n}`
  
  - 小偷问题：
  
    - [[198]House Robber](https://leetcode.cn/problems/house-robber/)：这个思路很容易想，属于简单题
    - 
  
  - 股票问题：
  
    - [[121]Best Time to Buy and Sell Stock](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/)：只能买卖一次。跟最大子数组和差不多，区别是一个是preSum，这个是preMin。
    - [[309]Best Time to Buy and Sell Stock with Cooldown](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-with-cooldown/)：由于冷冻期间不能买卖股票，因此需要加一维状态区分冷冻期。分别表示持有股票或者不持有股票，但是处于或者不处于冷冻期下的收益。然后根据相应的状态转移列出转移方程。
  
  - [背包问题](https://github.com/tianyicui/pack)：
  
    - 描述：有一些物品和一个容量为N的背包，每件物品有体积Vi和价值Wi，问怎么放可以使背包中物品价值最大。
  
      - 0-1背包：每件物品只有一件
      - 完全背包：每件物品可以放无限个
      - 多重背包：物品数量有限制
      - 多维费用背包：物品不仅有体积，还有重量，同时考虑这两种限制
      - 其它：物品之间相互约束或者依赖
  
    - 思路（0-1背包）：
  
      - 定义`dp[i][j]`表示前 i 件物品放入体积为j的背包能达到的最大价值。那么有两种情况，即第i件物品放入或不放入背包
  
        - 如果不放入，`dp[i][j] = dp[i-1][j]`
        - 如果放入，`dp[i][j] = dp[i-1][j-w] + v`
        - 最终结果取上面两种情况的最大值
  
      - 空间优化以及其他问题：
  
        - 由于前 i 件物品的状态仅与前 i-1 件物品的状态有关，因此可以节省一维空间。转移方程变成了`dp[j] = max(dp[j], dp[j-w] + v)`，为了防止将原方程中i-1的信息覆盖，第二层循环要从后往前循环
        - 初始化：如果不要求恰好装满背包，数组应该全部初始化为0；反之，则除了`dp[0] = 0`之外，其余位置应该初始化为无穷大，因为只有容量为0的背包可以在什么也不装的时候被装满。
        - 无法使用贪心，即不能只放性价比高的物品，会造成空间的浪费
  
      - 示例代码：
  
        ```java
        public int knapsack(int W, int N, int[] weights, int[] values) {
            int[] dp = new int[W + 1];
            for (int i = 1; i <= N; i++) {
                int w = weights[i - 1], v = values[i - 1];
                for (int j = W; j >= w; j--) {
                    dp[j] = Math.max(dp[j], dp[j - w] + v);
                }
            }
            return dp[W];
        }
        ```
  
      - 典型题：
  
        - [[416]Partition Equal Subset Sum](https://leetcode.cn/problems/partition-equal-subset-sum/)：背包大小为array sum的一半的0-1背包问题
  
        - [[494]Target Sum](https://leetcode.cn/problemset/all/?listId=2cktkvj)：本题思路跟上一题一样。假设正号部分和为P，负号部分和为N，则由如下推导可以得知，如果存在部分元素的和为P或者N则证明存在解。
  
          - $$
            \Sigma(P)-\Sigma(N)=target
            $$
  
            $$
            \Sigma(P)+\Sigma(N)=total
            $$
  
            $$
            \Sigma(P)=(total+target)/2;  \Sigma(N)=(total-target)/2
            $$
  
          - 第二层循环里不再取放或者不放的最大值，而是直接加起来，因为题目要求的是表达式总数
  
          - 初始化只有`dp[0] = 1`，表示从一个空集合选出和为0的数字只有一种办法；其他位置初始化为0表示从空集合中无法选出数字使其和大于1
  
        - 

###### 矩阵

- 矩阵部分的动态规划题往往是二维的。一些题目为二维网格只能向右或者向下移动，不难；更为典型的题目是[[72]Edit Distance](https://leetcode-cn.com/problems/edit-distance/)或者[[5]Longest Palindromic Substring](https://leetcode-cn.com/problems/longest-palindromic-substring/)

###### HashMap

- 使用数组或者矩阵的dp题目是比较容易理解的，然而还有一些题目使用HashMap来进行dp。


- [[128]Longest Consecutive Sequence](https://leetcode-cn.com/problems/longest-consecutive-sequence/)，本题的典型解法是使用HashMap不断更新右边界来合并连续序列的路径，写法较容易。而使用HashMap进行dp的解法如下，较难理解：

  ```java
  public int longestConsecutive(int[] nums) {
      // key表示num，value表示num所在连续区间的长度
      Map<Integer, Integer> map = new HashMap<>();
  
      int res = 0;
      for (int num : nums) {
          // 当map中不包含num，也就是num第一次出现
          if (!map.containsKey(num)) {
              int left = map.getOrDefault(num - 1, 0);
              int right = map.getOrDefault(num + 1, 0);
              int curLen = left + right + 1;
              res = Math.max(res, curLen);
  
              // 将num加入map中，表示已经遍历过该值。其对应的value可以为任意值。
              map.put(num, -1);
  
              // 更新包含num在内的区间左右端点值的长度
              map.put(num - left, curLen);
              map.put(num + right, curLen);
          }
      }
      return res;
  }
  ```

##### 贪心

贪心算法没有统一的步骤，对于不同的题目，解法通常会符合直觉。但是如果从来没有遇到过这题，大概率不可能当场想出来，即使知道是用贪心思路做，细节上也不一定能完全做对。所以最好还是多做一些贪心的题

- 典型题：
  - [[11]Container With Most Water](https://leetcode.cn/problems/container-with-most-water/)：这个题思路在于当我们向内移动板时，面积一定是减小的。但是向内移动短板时，面积有可能增大。所以为了这种可能性，要不断向内移动短板
  - [[135]Candy](https://leetcode.cn/problems/candy/)：这个题其实很好想，就是如果把序列看成一个柱形图，那么这个图就像股票走势，有上升有下降序列。那么可以新建两个数组，先全部初始化为1，分别从左到右更新上升趋势，然后从右到左更新下降趋势。最后组合一下
  - [[300]Longest Increasing Subsequence](https://leetcode.cn/problems/longest-increasing-subsequence/)：本题要构造最长递增序列，采用贪心算法的思路为使序列增长的尽可能慢，这样序列就会尽可能的长。比如一个序列是[0, 4, 8]，此时遇到一个2，就需要把序列更新为[0, 2, 8]。由于这个序列是递增的，所以在查找更新位置时可以用二分降低复杂度
  - [[406]Queue Reconstruction by Height](https://leetcode.cn/problems/queue-reconstruction-by-height/)：本题的贪心思路为先让高个站好，然后遇到一个矮个就往k序号上插，这样前面正好有k个比他高的
  - [[621]Task Scheduler](https://leetcode.cn/problems/task-scheduler/)：贪心思路为先安排出现次数最多的任务，让这个任务两次执行的时间间隔正好为n。再在这个时间间隔内填充其他的任务
  - [餐馆问题](https://blog.csdn.net/qq_43109561/article/details/99404646)：大意是餐馆有n张桌子，每张桌子可容纳的顾客数量不同，给出几批顾客，每批有顾客数量和花费。问不拼桌的情况下，怎么安排这些顾客餐馆盈利最大。思路是先将桌子按从小到大排序，再将顾客按照钱从大到小排序，排好序后给每一批顾客找个桌子吃饭，直到桌子用完，用完就中断循环，输出结果

##### 位运算

- 位运算有一些特殊公式用在某些题里面效果很好
- 典型题：
  - 

##### 数学

- 典型题：

  - 卡特兰数(Catalan number)。递推公式和计算公式如下：
    $$
    f(n)= \sum_{i=1}^{n} f(i-1) \cdot f(n-i)
    $$

    $$
    CTL_{n}=\frac{1}{n+1}C_{2n}^{n}
    $$
    
    - [[96]Unique Binary Search Trees](https://leetcode.cn/problems/unique-binary-search-trees/description/)
  
  - 约瑟夫环(Josephus problem)。假设有n个成员，每次第m个人离开，递推公式如下：
    $$
    f(n,m)=(m\bmod n+f(n-1,m))\bmod n=(m+f(n-1,m))\bmod n
    $$
    
    - [LCR 187. 破冰游戏](https://leetcode.cn/problems/yuan-quan-zhong-zui-hou-sheng-xia-de-shu-zi-lcof/)，原来的剑指offer第62题。
    - 公式很直观，就是上一次的结果是`f(n-1,m)`，再往后数m就是`f(n,m)`，因为m可能比n大，所以要模n，括号里面的n约掉就是最后的结果。可以轻松的用递归或迭代求解

