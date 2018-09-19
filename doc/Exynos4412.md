（事先说明一下，因为希望在文档中插入插图，因此采用Markdown进行书写。）  

### 启动模式

Exynos4412的启动模式有4种：Nand-Flash存储设备、SD/MMC存储设备、eMMC设备、USB设备。  
eMMC的全称是Embedded-Multi-Media-Card，它是MMC协会说制定的一套标准。主要应用于手机、平板等消费电子，相比于原来的Nand-Flash存储介质，它的最大优点是集成了一个控制器，提高了数据读写效率，并简化了与CPU的连接。  
本质上，不管是从那种介质启动，最主要的过程仍然是把代码从某种存储介质中拷贝到内存中，而编写或移植与某种存储介质相适应的copy功能函数是uboot移植的关键所在。  

exynos4412上电复位时的启动流程，可参考![图1](..\res\4412_boot_sequence.png)。具体流程如下：  
1. 执行内部只读存储器iROM中的一段代码BL0（厂家固化在iROM中，iROM大小为64KB），这段代码主要是初始化一些系统的基本配置，比如时钟、看门狗、堆栈、启动模式等。BL0根据启动模式（OM_STAT寄存器的值，由外部引脚电平决定，通常是由焊在核心板上的一个switch来控制），从相应的存储介质中拷贝BL1镜像到内部SRAM（256KB），并跳转至BL1的入口处。  
2. BL1是Samsung提供的镜像文件E4412_N.bl1.bin，它最主要的工作初始化外部DRAM，并加载后续程序BL2，当然，它也首先要进行进一步的初始化工作，如外部时钟的配置。  
3. BL1最后会加载BL2，即U-Boot的spl，到内部SRAM（256KB）的0x02023400地址处，并运行它。BL2在烧录位置上固定在BL1之后，大小为14k，并要求最后一个4字节是之前的checksum。BL2通常由用户自己做成，当然，有一个mkbl2工具可以帮助我们为自己的程序添加checksum。  
4. 现在最新的U-Boot尺寸通常往往大于256KB，将U-Boot全部加载至内部SRAM是不现实的，因此新版本的U-Boot都将自己分成了u-boot-spl和u-boot两部分，SPL是Secondondary program loader的意思。u-boot-spl作为BL2，在BL1的最后被加载至内部SRAM中执行，由它再把u-boot加载至外部DDR中，并跳转至u-boot。  

第二步中用户选择从哪种外部设备中启动是由iROM中的一段固化代码去检测OM_STAT寄存器来决定的。可参考![图2](..\res\4412_OM_STAT.JPG)。  


### 参考文章

网上有一篇非常详细的介绍4412的U-boot移植的[文章](https://www.cnblogs.com/pengdonglin137/p/5080309.html)。  


