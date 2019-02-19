## 驱动模型  

本自述文件说明了有关驱动模型的基本设计思想，也说明了其在U-Boot当中的具体实现。该作业已经通过下面几位同仁的努力得以完成。  
- Marek Vasut <marex@denx.de>  
- Pavel Herrmann <morpheus.ibis@gmail.com>  
- ViktorKřivák<viktor.krivak@gmail.com>  
- Tomas Hlavacek <tmshlvck@gmail.com>  
这些内容已经由下面的同事简化并扩展到现在的应用程序中。  
- Simon Glass <sjg@chromium.org>  

### 术语  

- Uclass ： 一组以相同方式运行的设备。一个uclass提供一种访问组内个别设备的方法，它们使用相同的界面。例如，GPIO的uclass提供获取/设定值的操作。I2C的uclass可能有10个I2C端口、其中4个带一个驱动器，其余6个带另一个驱动器。  
- Driver ： 面向一些外围设备通信的代码，提供更高级别的抽象接口。  
- Device ： 绑定到特定端口或外围设备的驱动程序（设备）实例。  

### 快速入门

构建U-Boot sandbox并运行它：  
```shell
make sandbox_defconfig
make
./u-boot -d u-boot.dtb
（输入'reset'退出U-Boot）
```

此时U-Boot会生成一个名为'demo'的uclass。这个uclass会输出hello，并报告当前运行状态。在这个uclass中存在两个设备：  
1. simple：只打印一条hello消息，不显示状态。 
2. shape：打印形状并报告作为状态打印的字符数。

这个demo类非常简单，但它非常重要。它可用于测试，它实现了所有驱动模型的特征并提供了良好的代码覆盖率。它包含多个驱动程序，并具有参数和platdata（通知驱动程序如何在特定平台运行的数据），它也使用了私有数据信息。  

使用这个demo时，可参考下面的方法：  
```shell
=>demo hello 1
Hello '@' from 07981110: red 4
=>demo status 2
Status: 0
=>demo hello 2
g
r@
e@@
e@@@
n@@@@
g@@@@@
=>demo status 2
Status: 21
=>demo hello 4 ^
  y^^^
 e^^^^^
l^^^^^^^
l^^^^^^^
 o^^^^^
  w^^^
=>demo status 4
Status: 36
=>
```