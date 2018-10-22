# CUnit的安装及使用  
测试驱动开发的必要工具！
---

### CUnit的安装  
下面的网址有最新版的CUnit的下载链接：  
[https://sourceforge.net/projects/cunit/](https://sourceforge.net/projects/cunit/)  
我下载的时候版本为CUnit-2.1-3。下载后然后依次执行下述命令：  
```Bash
apt-get install aptitude
aptitude install libtool
tar jxvf CUnit-2.1-3.tar.bz2
cd CUnit-2.1-3
./bootstrap
./configure
make
make install
```
前面两条命令安装的是辅助工具libtool。注意，直接运行./configure即可，不要自己改动安装目录，否则后面使用时会平添很多麻烦！  


### CUnit使用示例  

在本地编辑一个例子程序，sum.c、sum.h和main.c。sum.c用来实现一个简单的两数相加的函数，如果简单的如下编译链接，可以得到一个打印出两数之和的可执行程序。  
```Bash
gcc -o main sum.c main.c
```
运行./main，可以得到如下打印结果：  
```Bash
The sum of 1 and 2 is 3.
```
说明sum.c中的sum函数运行的挺好！  

现在来编辑一个CUnit的测试程序，起名为test_sum.c。它的内容如下：  
```
#include <stdio.h>
#include "sum.h"
#include "CUnit/Basic.h"

int init_suite1(void) {
    return 0;
}

int clean_suite1(void) {
    return 0;
}

void test_sum_function(void) {
    CU_ASSERT(3 == sum(1,2));
    CU_ASSERT(13 == sum(11,2));
    CU_ASSERT(44998 == sum(10000,34998));
}

int main()
{
   CU_pSuite pSuite = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_1", init_suite1, clean_suite1);
   if (NULL == pSuite) {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* add the test cases to the suite */
   if ((NULL == CU_add_test(pSuite, "test of sum()", test_sum_function))){
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Run all tests using the CUnit Basic interface */
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();
   CU_cleanup_registry();
   return CU_get_error();
}
```
上面这段代码包含了一个"CUnit/Basic.h"的文件，该文件其实是从CUnit的默认安装目录开始查找的，其路径为：  
/usr/local/include/
可以将这个测试文件和sum.c放在一起编译，即运行：  
```Bash
gcc -Wall -o test_sum test_sum.c sum.c -lcunit
```
上面的命令有几个地方值得注意：
1. 加入-Wall是关闭警告，这个有没有都两可。  
2. 必须加入-lcunit，这个东西指向CUnit的库，其路径为/usr/local/lib/。  
3. 测试的函数在sum.c中，因此不要连main.c一起编译，否则main.c中的main函数会和CUnit测试工程的main函数冲突。  

运行以上的编译结果./test_sum，可以得到如下结果：
```
     CUnit - A unit testing framework for C - Version 2.1-3
     http://cunit.sourceforge.net/


Suite: Suite_1
  Test: test of sum() ...passed

Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests      1      1      1      0        0
             asserts      3      3      3      0      n/a

Elapsed time =    0.000 seconds
```

稍微解释一下。一次测试(registry)可以分成多个suit，一个suit里可以有多个case。每个suit有个init和clean函数，分别在执行suit之前或之后调用，用于设置测试用的变量的值。  
上述测试程序中包含了一个registry，一个suit，一个case，三个asserts。

详细的CUnit功能还有很多，这里给出CUnit的[用户手册](http://cunit.sourceforge.net/doc/index.html)，可以去慢慢发掘其中的功能。  
