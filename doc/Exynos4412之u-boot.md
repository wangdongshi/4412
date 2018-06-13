（事先说明一下，因为希望在文档中插入插图，但又不希望使用word这类无法进行差分的工具，因此决定采用在文本中混入标记语言的方式，这样可以做到在网页中查看时自动可以链接到插图。）

Exynos4412的启动模式有4种：Nand-Flash存储设备、SD/MMC存储设备、eMMC设备、USB设备。
eMMC的全称是Embedded-Multi-Media-Card，它是MMC协会说制定的一套标准。主要应用于手机、平板等消费电子，相比于原来的Nand-Flash存储介质，它的最大优点是集成了一个控制器，提高了数据读写效率，并简化了与CPU的连接。
本质上，不管是从那种介质启动，最主要的过程仍然是把代码从某种存储介质中拷贝到内存中，而编写或移植与某种存储介质相适应的copy功能函数是uboot移植的关键所在。

exynos4412上电复位时的启动流程，可参考<a href="https://github.com/wangdongshi/4412/blob/master/res/4412_boot_sequence.png">图1</a>。具体流程如下：
1)执行内部只读存储器iROM中的一段代码BL0（厂家固化在iROM中的），这段代码主要是初始化一些系统的基本配置，比如初步时钟配置、堆栈、启动模式。
2)BL0根据第1步获取的启动模式（OM_STAT寄存器），从相应的存储介质中拷贝BL1镜像到内部静态随机存储器SRAM，并运行它。BL1是Samsung提供的镜像文件E4412_N.bl1.bin，它主要是完善系统时钟的初始化工作、内存控制器一些时序的配置。
3)BL1最后会加载BL2到内部SRAM，并运行它。BL2在烧录位置上固定在BL1之后，大小为14k，并要求最后一个4字节是之前的checksum。BL2通常由用户自己做成，对Linux系统来说一般这里就是指U-Boot等引导程序。
3)跳转到OS中执行。

第二步中用户选择从哪种外部设备中启动是由iROM中的一段固化代码去检测OM_STAT寄存器来决定的。可参考<a href="https://github.com/wangdongshi/4412/blob/master/res/4412_OM_STAT.JPG">图2</a>。
