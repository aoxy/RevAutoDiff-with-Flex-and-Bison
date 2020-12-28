# 反向自动微分求解

这是中国科学技术大学2020年秋季学期**编译原理和技术**课程郑启龙班的编译原理上机实验2，要求编写一个 YACC 描述文件，实现反向自动微分求解。详细要求见本仓库中的[实验要求](./2020-compiler-lab-2.pdf)。本实现支持x0~x9共10个自变量，可以很方便地扩充至更多自变量。

## 示例：

输入：
```text
f(x1=2,x2=5):ln(x1)+x1*x2-sin(x2)
```

输出：
```text
val = 11.6521
f-PDF@x1 = 5.5
f-PDF@x2 = 1.71634
```

## 开始

需要安装Flex和Bison，在Ubuntu下可以使用命令
```shell
git clone git@git.lug.ustc.edu.cn:axy/RevAutoDiff.git
cd RevAutoDiff/
sudo apt-get install flex bison
```

执行`run.sh`脚本查看作者编写的三个样例

```shell
./run.sh
```

在`myinput.txt`中写输入函数后求解

```shell
make
./autodiff < myinput.txt
```

## 验证

执行脚本`run.sh`，得到如下输出：

```text
样例1：f(x1=2,x2=5):ln(x1)+x1*x2-sin(x2)
val = 11.6521
f-PDF@x1 = 5.5
f-PDF@x2 = 1.71634

样例2：f(x1=2,x2=3):exp(sin(x1))+x2^x2+x1*x2^2
val = 47.4826
f-PDF@x1 = 7.96688
f-PDF@x2 = 68.6625

样例3：f(x1=2,x2=3,x3=4,x4=5,x5=6):exp(sin(x1))+x2^x2+x3^2+4^x4+ln(x3*x4)+(cos(ln(2.5*x5)))^2
val = 1073.3
f-PDF@x1 = -1.03312
f-PDF@x2 = 56.6625
f-PDF@x3 = 8.25
f-PDF@x4 = 1419.77
f-PDF@x5 = 0.127074

```
在[`check.c`](./check.c)中手动计算写出微分式，代入数值求解作为验证，手动计算的结果如下：

```text
aa@DESKTOP-AXY:~/cplab2/autodiff$ make
gcc -o check check.c -lm
aa@DESKTOP-AXY:~/cplab2/autodiff$ ./check
样例1：f(x1=2,x2=5):ln(x1)+x1*x2-sin(x2)
手动计算结果：
val = 11.6521
f-PDF@x1 = 5.5
f-PDF@x2 = 1.71634

样例2：f(x1=2,x2=3):exp(sin(x1))+x2^x2+x1*x2^2
手动计算结果：
val = 47.4826
f-PDF@x1 = 7.96688
f-PDF@x2 = 68.6625

样例3：f(x1=2,x2=3,x3=4,x4=5,x5=6):exp(sin(x1))+x2^x2+x3^2+4^x4+ln(x3*x4)+(cos(ln(2.5*x5)))^2
手动计算结果：
val = 1073.3
f-PDF@x1 = -1.03312
f-PDF@x2 = 56.6625
f-PDF@x3 = 8.25
f-PDF@x4 = 1419.77
f-PDF@x5 = 0.127074

```

## 参考

- [1] [编译原理-如何使用flex和yacc工具构造一个高级计算器](https://blog.csdn.net/liaopiankun0618/article/details/84232771)
- [2] [Flex and Bison Tutorial](https://www.cse.scu.edu/~mwang2/compiler/TutorialFlexBison.pdf)
- [3] [自动微分](http://fancyerii.github.io/books/autodiff/)
