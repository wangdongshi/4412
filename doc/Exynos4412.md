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
在virtualbox中，要想在虚拟机中使用宿主机的USB设备，需要安装一个virtualbox的插件：Oracle_VM_VirtualBox_Extension_Pack-X.X.XX。安装了这个扩展机能后，需要在连接SD卡读卡器的状态下，在virtualbox的Machine->settings中，在USB选项卡中设置相应的SD卡读卡器过滤器。然后断开SD卡读卡器，重启虚拟机。最后再连接SD卡读卡器，此时Windows宿主机应该会发现新设备（virtualbox的USB设备），安装驱动完成后，SD卡读卡器即可透过宿主机而变为虚拟机上的设备了。当然，在Linux下，需要用以下命令来挂载SD卡（假设SD卡被识别为mmcblk0）：  
mount /dev/mmcblk0p1 /mnt/sdcard

再来看dd命令。dd是Linux下的一个非常有用的命令，其作用是用指定大小的块拷贝一个文件，并在拷贝的同时进行指定的转换。该命令可以直接将数据拷贝至目标存储器特定的block，因此，它可以进行很多超越文件系统的磁盘操作。（基于文件系统的写操作不能指定Block。）那么，来看看真实的dd命令的用法吧。  
dd iflag=dsync oflag=dsync if=$1 of=$2 seek=$3  
iflag和oflag参数是指定为同步读写，到底怎么算同步，这个我没深入研究。后面的if和of是指定输入输出文件，在向SD卡写入时，of可以直接指定为/dev/sdb。这里sdb指向SD卡设备，Linux中一切都是文件的理念又一次发挥了超乎想象的作用。seek用来指定从输出文件开头跳过blocks个块后再开始复制。  

接下来，还需要知道Exynos4412从SD卡启动时，默认的SD映像是一个什么结构。下面的图3和图4说明了SD启动映像结构和eMMC启动映像结构。  
![图3](https://github.com/wangdongshi/4412/blob/master/res/SD_image_format.jpg)  
*图3 exynos4412的SD卡映像结构*  

![图4](https://github.com/wangdongshi/4412/blob/master/res/eMMC_image_format.jpg)  
*图4 exynos4412的eMMC卡映像结构*  

好了，闲言少序，来实际操作一下。现在的材料有三星提供的BL1，即E4412_N.bl1.bin文件，还有一个用来测试的裸机程序leds.bin文件，该怎么做呢？  
dd iflag=dsync oflag=dsync if=/root/E4412_N.bl1.bin of=/dev/sdb seek=1  
dd iflag=dsync oflag=dsync if=/root/leds.bin of=/dev/sdb seek=17  
sync

在这三个步骤中，BL1的写操作没啥可说的，sync是保证dd命令写SD卡操作完成，也没啥可说的。重要的是第二步，编译好的测试程序leds.bin并不能直接写入到17区，因为BL1的程序会首先校验BL2的checksum，这个checksum是根据原始的bin文件计算的，放在BL2的14KB的最后4字节。因此，实际上需要每次动态的计算这个checksum。为了简化这一系列操作，4412的开发者写了一个shell程序，叫做sd_fusing，它可以自动完成给BL2加checksum，和向SD卡写入BL1和BL2的所有操作，格式如下：  
./sd_fusing /dev/mmcblk0 leds.bin  
要注意，以上命令的第一个参数指向SD卡设备，这里一定要写对，不是mmcblk0p1，而是mmcblk0。在这里困扰了很久！  

另外一个要吐槽一下的事情是，本人手中的这块九鼎创展的开发板，参考资料整理得非常不友好，以上这些简单易懂的操作他统统不做说明，而是把整个烧写SD卡的过程封装在一个自己提供的Windows工具中，让开发者无从学起，鄙视这种行为！  

有了以上这些东东，一个最简4412裸机运行环境已经OK了！为了小小的纪念一下，拍张运行着流水灯测试程序的开发板照片放在这里。  
![图5](https://github.com/wangdongshi/4412/blob/master/res/water_light.jpg)  
*图5 运行着流水灯测试程序的4412开发板*  

有两个问题再在这里说明一下。  

第一个是电源按键的问题。一开始如果执行默认的测试程序，开发板上的电源键要一直按下方可运行程序，这个是按照Android的延迟开机准备这种方式设计的，可以理解，但对于裸机程序难道都要一直这样持续按着电源键吗？当然不可能设计成这个样子。其实，开发板上有一个电源置锁电路，这个置锁电路是通过一个专用的输出引脚XPSHOLD进行控制的，在系统启动的时候，只要人为的置上这个锁，就不用在开机以后一直按着电源按键了。  

第二个是中断向量表的问题。如果仔细看这里的裸机示例程序，似乎它并没有设定中断向量表，这与通常的ARM程序非常不同。但仔细思考一下便可知道，其实裸机程序对应的是ARM程序中最开始的初始化部分，而CPU最开始上电部分的运行顺序是由CPU厂商定义的，只有在CPU上电初始化完毕之后，才能以ARM规定的方式响应中断向量表。换句话说，在上电时候，为ARM准备的中断向量表还在SD卡的某个位置，即使三星的BL1程序将它Load至内部RAM的某个地址，它也无法完成中断时的路由作用，因为在那个时候，它还没有被搬移至相应的内存地址，程序也还没有设定VBAR。因此，结论是，CPU裸机程序的运行并不需要中断向量表！之所以有这种想法，是因为使用Cortex-M系列CPU的习惯，因为在Cortex-M系列CPU中，ARM通常可以在0地址的ROM处开始运行，而且，它的中断向量表也通常是一开始就放在相应的ROM地址处的。不同CPU体系架构的上电运行机制非常不同，不能想当然啊！  



### U-boot移植  

经过上面的裸机程序移植，我们已经对开发的基本情况有所了解，接下来直接搞个U-boot试一下吧！这个移植过程基本参照彭东林博客上的移植步骤，他写得比较全面了。  

不过在移植之前，有个关于环境的问题还想记录一下——如何使用diff和patch工具，来给自己的工程制作和打上补丁。  
diff -ruN u-boot-2018.07 u-boot-x4412 > x4412_uboot.patch  
patch –p1 < ../x4412_uboot.patch  

### 参考文章  

网上有一篇非常详细的介绍4412的U-boot移植的[文章](https://www.cnblogs.com/pengdonglin137/p/5080309.html)。  


