# 编译原理上机实验 2

编写一个 YACC 描述文件，实现反向自动微分求解。

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

安装Flex和Bison后就可以使用，再Ubuntu下使用
```shell
sudo apt-get install flex bison
```

在`input.txt`中写输入函数，执行`run.sh`脚本

或者执行`make`命令得到可执行文件`diff`

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