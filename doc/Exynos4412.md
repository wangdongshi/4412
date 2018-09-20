# X4412开发板学习笔记  
希望将其打造成一款学习嵌入式Linux、QT、Andriod的一款神兵利器！
---

### 启动模式  

Exynos4412的启动模式有4种：Nand-Flash存储设备、SD/MMC存储设备、eMMC设备、USB设备。  
eMMC的全称是Embedded-Multi-Media-Card，它是MMC协会说制定的一套标准。主要应用于手机、平板等消费电子，相比于原来的Nand-Flash存储介质，它的最大优点是集成了一个控制器，提高了数据读写效率，并简化了与CPU的连接。  
本质上，不管是从那种介质启动，最主要的过程仍然是把代码从某种存储介质中拷贝到内存中，而编写或移植与某种存储介质相适应的copy功能函数是uboot移植的关键所在。  

exynos4412上电复位时的启动流程，可参考图1。  
![图1](https://github.com/wangdongshi/4412/blob/master/res/4412_boot_sequence.png)    
*图1 exynos4412启动流程*  

具体流程如下：  
1. 执行内部只读存储器iROM中的一段代码BL0（厂家固化在iROM中，iROM大小为64KB），这段代码主要是初始化一些系统的基本配置，比如时钟、看门狗、堆栈、启动模式等。BL0根据启动模式（OM_STAT寄存器的值，由外部引脚电平决定，通常是由焊在核心板上的一个switch来控制），从相应的存储介质中拷贝BL1镜像到内部SRAM（256KB），并跳转至BL1的入口处。  
2. BL1是Samsung提供的镜像文件E4412_N.bl1.bin，它最主要的工作初始化外部DRAM，并加载后续程序BL2，当然，它也首先要进行进一步的初始化工作，如外部时钟的配置。  
3. BL1最后会加载BL2，即U-Boot的spl，到内部SRAM（256KB）的0x02023400地址处，并运行它。BL2在烧录位置上固定在BL1之后，大小为14k，并要求最后一个4字节是之前的checksum。BL2通常由用户自己做成，当然，有一个mkbl2工具可以帮助我们为自己的程序添加checksum。  
4. 现在最新的U-Boot尺寸通常往往大于256KB，将U-Boot全部加载至内部SRAM是不现实的，因此新版本的U-Boot都将自己分成了u-boot-spl和u-boot两部分，SPL是Secondondary program loader的意思。u-boot-spl作为BL2，在BL1的最后被加载至内部SRAM中执行，由它再把u-boot加载至外部DDR中，并跳转至u-boot。  

第二步中用户选择从哪种外部设备中启动是由iROM中的一段固化代码去检测OM_STAT寄存器来决定的。可参考图2。  
![图2](https://github.com/wangdongshi/4412/blob/master/res/4412_OM_STAT.JPG)  
*图2 exynos4412的OM_STAT寄存器定义*  


### 裸机移植  

在移植U-Boot之前，首先向开发板移植几个简单的裸机程序。一来作为热身，二来作为理解Exynos4412启动流程的一个准备。  

#### 使用virtualbox上的ubuntu系统来烧写SD卡  

开发板的eMMC上有一个烧写好的Andriod系统，虽然版本比较老，但好歹也是移植成功的一个系统，为了今后便于参照，，在开发途中尽量采用SD卡作为启动介质，这样可以完全不影响eMMC上的Andriod系统。  

Exynos4412从SD卡启动，需要在SD卡上写入一些RAW数据，即在不存在文件系统的情况下向SD卡写入信息，这个在Windows环境下比较困难，而Linux下由于有dd命令，因此可以轻松的胜任这一任务。因为我一直在virtualbox下使用Linux，因此首先要透过virtualbox来访问SD卡。  
在virtualbox中，要想在虚拟机中使用宿主机的USB设备，需要安装一个virtualbox的插件————Oracle_VM_VirtualBox_Extension_Pack-X.X.XX。安装了这个扩展机能后，需要在连接SD卡读卡器的状态下，在virtualbox的Machine->settings中，在USB选项卡中设置相应的SD卡读卡器过滤器。然后断开SD卡读卡器，重启虚拟机。最后再连接SD卡读卡器，此时Windows宿主机应该会发现新设备（virtualbox的USB设备），安装驱动完成后，SD卡读卡器即可透过宿主机而变为虚拟机上的设备了。当然，在Linux下，需要用以下命令来挂载SD卡（假设SD卡被识别为sdb）：  
mount -t vfat /dev/sdb1 /mnt/sdcard

再来看dd命令。dd是Linux下的一个非常有用的命令，其作用是用指定大小的块拷贝一个文件，并在拷贝的同时进行指定的转换。该命令可以直接将数据拷贝至目标存储器特定的block，因此，它可以进行很多超越文件系统的磁盘操作。（基于文件系统的写操作不能指定Block。）那么，来看看真实的dd命令的用法吧。  
dd iflag=dsync oflag=dsync if=$1 of=$2 seek=$3  
iflag和oflag参数是指定为同步读写，到底怎么算同步，这个我没深入研究。后面的if和of是指定输入输出文件，在向SD卡写入时，of可以直接指定为/dev/sdb。这里sdb指向SD卡设备，Linux中一切都是文件的理念又一次发挥了超乎想象的作用。seek用来指定从输出文件开头跳过blocks个块后再开始复制。  

接下来，还需要知道Exynos4412从SD卡启动时，默认的SD映像是一个什么结构。下面的图3和图4说明了SD启动映像结构和eMMC启动映像结构。  
![图3](https://github.com/wangdongshi/4412/blob/master/res/SD_image_format.jpg)  
*图3 exynos4412的SD卡映像结构*  

![图4](https://github.com/wangdongshi/4412/blob/master/res/eMMC_image_format.jpg)  
*图4 exynos4412的eMMC卡映像结构*  

好了，闲言少序。我们来实际操作一下。我们的材料有三星提供的BL1，即E4412_N.bl1.bin文件，还有开发板配套的裸机程序，比如测试LED的x4412_led.bin文件，该怎么做呢？  
dd iflag=dsync oflag=dsync if=/root/E4412_N.bl1.bin of=/dev/sdb seek=1  
dd iflag=dsync oflag=dsync if=/root/x4412_led.bin of=/dev/sdb seek=17  

这样应该就可以了吧。

### 参考文章  

网上有一篇非常详细的介绍4412的U-boot移植的[文章](https://www.cnblogs.com/pengdonglin137/p/5080309.html)。  

