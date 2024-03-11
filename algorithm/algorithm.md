#### 0 常用基础

##### 0.1 生成随机数

生成`[n, m]`之间的整数

```java
int randomNum = (int) (Math.random() * (m - n + 1)) + n;
```

如何理解呢？首先已知`Math.random()`产生的随机数在`[0, 1)`之间

如果直接乘上m，那么结果范围就是`[0, m)`（**分别代入最小值0和最大近似值1计算可得**）

```java
Math.random() * m;
```

如果想要将结果范围的最小值提升到n，直接加n是不行的，因为这样结果范围就变成了`[n, m + n)`

```java
Math.random() * m + n;
```

可不可以只加最小值的n，最大值的n不加呢，可以，减掉最大值的n就行了，于是公式变成了

> 代入最大近似值1计算可知最大值变为 m + n - n = m，最小值仍然为n

```java
Math.random() * m + n - Math.random() * n;
```

截止目前结果范围是`[n, m)`，仍然不符合需求，如何让最大值取到m呢，注意到我们虽然没有取到m，但是实际最大值是极为接近m的，考虑到可以取整，而正好随机函数的值就在1以内，于是可以加上一个随机函数的值

> 假设随机数为0.99，m为10，则原本最大值为9.9，取整后得最大整数为9，取不到10，若加上随机函数的值0.99，则最大值变为10.89，取整后为10，正好符合要求

```java
Math.random() * m + n - Math.random() * n + Math.random();
```

整理可得公式

#### 1 大O表示法

算法都是有效率的，有的效率高，有的效率慢，如何表示算法的效率呢，随着操作数的增加，算法的增速是不一样的，操作数少的时候，可能两个算法的运行时间是差不多的，但是当操作数很大时，不同算法的运行时间差距会越来越大，大O表示法就是用来表示算法的增速的

比如简单查找算法中，如果有n个元素，则最坏情况下需要检查n个元素即操作n次才能找到想要的元素，故运行时间为O(n)，没有时间单位，因为大O表示法表示的是增速

二分查找算法中，如果有n个元素，则最坏情况下需要检查log2n个元素即操作log2n次，故运行时间为O(log2n)

因此大O表示法**表示算法在最坏情况下需要的操作次数，表明了算法的增速**

常见的大O运行时间：

1. O(log2n)：对数时间，如二分查找
2. O(n)：线性时间，如简单查找
3. O(nlog2n)：线性对数时间，如快速排序
4. O(n^2)：幂时间，如选择排序
5. O(n!)：阶乘时间，如旅行商问题的解决方案

#### 2 排序算法

##### 2.1 冒泡排序

基本排序算法，通过双重循环遍历操作，两两比较元素，交换位置，最终达到排序的目的

> 外部循环每一趟，最大的元素将会被排到最后的位置，由于排序到最后一个最小元素时不需要再继续排序，故外部循环的次数为数组大小减一，内部循环由于是两两比较，故一开始的循环次数与外部循环相同，但是由于每次内部循环结束后，最大元素会被排到最后，因此下一次内部循环时，最大循环次数将会减一，一开始减一，然后减二，以此类推，符合这个变量要求的正好是外部循环的变量i，所以内部循环的最大次数正好是数组大小减一再减i

```java
import java.util.Arrays;

public class Main {
    public static void main(String[] args) {
        int[] intArr = {12, 3, 45, 12, 23, 54, 14};
        System.out.println("排序前：" + Arrays.toString(intArr));
        int temp = 0;
        for (int i = 0; i < intArr.length - 1; i++) {
            for (int j = 0; j < intArr.length - 1 - i; j++) {
                if (intArr[j] > intArr[j + 1]) {
                    temp = intArr[j];
                    intArr[j] = intArr[j + 1];
                    intArr[j + 1] = temp;
                }
            }
        }
        System.out.println("排序后：" + Arrays.toString(intArr));
    }
}
```

##### 2.2 选择排序

选择排序即将原数组中的最大的元素（或者是最小的元素）选择出来，放入一个新的数组，然后重复操作这个过程，直到原数组中最后一个元素被放到新数组中

也可以不创建新的数组，直接在原数组上进行数据交换

> 运行时间为O(n^2)，虽然每次可以少检查一个元素，但是大O表示法会忽略常数

```java
public static void selectionSort(int[] arr, int n) {
    for (int i = 0; i < n; i++) {
        // 寻找 [i, n) 区间的最小值，放到相应顺序的位置
        int minIndex = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
    }
}
```

##### 2.3 快速排序

###### 2.3.1 递归

递归是一种循环调用

通常是封装一个函数，然后函数自己调用自己（递归条件）

特别注意递归容易陷入死循环，所以需要设置限制条件让其停止调用（基线条件）

```js
function name(n) {
  console.log(n - 1)
  if(n <= 0) {
      return
  } else {
      name(n - 1)
  }
}
name(3)
```

###### 2.3.2 分而治之
分治是一种思想而非具体算法

主要思想是首先找出基线条件，然后通过不断缩小问题规模的办法（通常使用递归），使其符合基线条件，从而求解问题

###### 2.3.3 快排

快速排序顾名思义是速度比较快的排序算法，首先找到基线条件，当数组剩余0或一个元素时，不用排序，排序结束，然后将数组分为子数组，对子数组采用相同的方法，直到满足基线条件

1. 判断数组大小，如小于等于1，直接返回数组

2. 找一个基准值（pivot），通常第一个数组元素就行

3. 划分数组为子数组，将小于等于基准值的元素划为子数组1，大于基准值的元素划为子数组2

4. 对子数组继续应用上诉2、3步骤，即递归调用，直至数组长度满足步骤1，递归结束

>注意基线条件是数组长度，故在递归过程中需要改变数组长度
>
>选择中间的元素作为基准值可以减少调用栈长度

```js
const arr = [3, 2, 4, 5, 8, 7, 1]

function quickSort(arr) {
  if (arr.length < 2) return arr
  const pivot = arr.splice(0, 1)[0] // 取基准值的同时减短数组的长度
  const lower = arr.filter(e => e <= pivot)
  const higher = arr.filter(e => e > pivot)
  return quickSort(lower).concat([pivot], quickSort(higher))
}

console.log(quickSort(arr))
```

#### 3 查找

##### 3.1 二分查找

二分查找效率高，但只适用于有序列表

> 二分查找每次会舍弃掉一半的元素，因此效率很高，关键点在于：
>
> 1. 如何计算中间点，应该是最小索引加最大索引的结果除以2，比如想求5~10的中间数，就是`(5 + 10) / 2 = 7`（java中会省略小数，因此等于7）
> 2. 如何处理比较之后的高低临界值，如果中间数小于查找数，那么应该舍弃中间数以下的元素，即低临界值应该修改为中间数加一，加一是因为中间数不等于查找数，应该舍弃掉，同理可得，当高临界值应该修改为中间数减一

```java
public class Main {
    public static int binarySearch(int[] arr, int item) {
        int low = 0;
        int high = arr.length - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            if(arr[mid] < item) {
                low = mid + 1;
            } else if (arr[mid] > item) {
                high = mid - 1;
            } else {
                return mid;
            }
        }
        return -1;
    }

    public static void main(String[] args) {
        int[] intArr = {2, 3, 4, 5, 6, 7, 8, 9, 11, 23, 25, 34, 45};
        int item = 5;
        int index = binarySearch(intArr, item);
        System.out.println("查找到的索引是：" + index);
    }
}

```

#### 4 散列表

假设你在超市上班，有一张记录商品价格的列表，如果是无序的，那么简单查找的时间复杂度为O(n)，有序且采用二分查找的话为O(logn)，如何做到O(1)呢，即使使用数组保存，也不能做到O(1)的时间复杂度，更别说链表了，但是散列表可以做到

我们知道数组的查找速度是很快的，为O(1)













