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
