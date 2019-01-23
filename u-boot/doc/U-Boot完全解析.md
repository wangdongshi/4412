# X4412 U-Boot详细解析

---
（本文大部分内容均来自麦子学院童佳音老师的讲解，如需引用，请注明出处，谢谢！）  
PS. 童老师的视频是我迄今见到过的所有讲解U-Boot的书籍和课程中最好的一份资料，没有之一！我本人从中获益良多，也借此表示对童老师深深的敬意！  

### 移植环境

- 开发环境 ： Win7（64位） + Virtualbox + Ubuntu16.04（64位）
- 主开发板 ： [九鼎创展X4412](http://www.9tripod.com/index.php)

| 器件 | 型号             | 厂商    | 描述                                          |
| ---- | ---------------- | ------- | --------------------------------------------- |
| CPU  | Exynos 4412      | Samsung | Cortex-A9, Quad Core                          |
| DDR  | NT5CB128M16FP-D1 | Nanya   | DDR3x4, 2Gb, 128Mx16, 800MHz, BGA96           |
| eMMC | THGBMBG6D1KBAIL  | Toshiba | MLC NAND, Serial, 3.3V, 64G-bit, 153-Pin FBGA |

- 基础u-boot版本 ： u-boot-2015-10
- 交叉编译工具链 ： 友善之臂提供的arm-linux-gcc-4.5.1-v6-vfp-20101103.tgz

简单说下，Exynos 4412这个CPU是Cortex-A9内核的，而网络上教程比较多的S5PV210是Cortex-A8内核的，这两款CPU都是基于ARMv7架构的。A9支持多核，市面上流行的ARM多核基本是A9起步。目前最新的Cortex-A系列已经是基于ARMv8架构的了，ARMv8架构开始支持64bit。

### 中断向量表

u-boot-2015-10工程中，入口地址应该是哪里？传统的U-Boot的入口都是arch/arm/cpu/armv7/start.S这个文件，但是打开u-boot-2015-10工程的这个文件，会发现最前面的部分竟然不是中断向量！入口地址处难道不是中断向量吗？绝无可能，那么想找到线索，还是要回头来查看arch/arm/cpu/u-boot.lds文件，在这个链接脚本文件会看到，整个工程的入口是“_start”，参考下面这句：
```
ENTRY(_start)
```
那么这个_start又在什么地方呢？全局搜索工程会发现这个标号在arh/arm/lib/vectors.S文件中。如下：
```armasm
_start:
#ifdef CONFIG_SYS_DV_NOR_BOOT_CFG
	.word	CONFIG_SYS_DV_NOR_BOOT_CFG
#endif
	b	reset
	ldr	pc, _undefined_instruction
	ldr	pc, _software_interrupt
	ldr	pc, _prefetch_abort
	ldr	pc, _data_abort
	ldr	pc, _not_used
	ldr	pc, _irq
	ldr	pc, _fiq
```
这便是整个工程的入口了。但是这个文件中并不存在reset标号，reset在哪里呢？它在arch/arm/cpu/armv7/start.S这个文件中，从这里开始，该U-boot工程的流程便和以前的U-boot差不多了。

严格来说“中断向量表”这个叫法并不严谨，因为这里处理的是一些“异常”。一般情况下，“异常”比“中断”的优先级要高，它是指CPU在运行期间遇到的一些有问题的状况，比如这里看到的指令异常、预取指异常等等。遇到这些问题时CPU必须停下来去做相应的处理，而不能“屏蔽”异常。但是“中断”则不同，中断是一些外设发来的打断CPU正常处理顺序的一些外部信号，这些信号取决于用户的需要，是可以选择性进行屏蔽的。

再来看这些异常处理的具体形式，比如：
```armasm
ldr	pc, _undefined_instruction
```

这里的ldr是一条ARM汇编伪指令，所谓伪指令，是说ARM机器指令中并不存在任何与其相对应的指令，但汇编器（软件）可以识别这些伪指令，在汇编器进行汇编时，它会将其翻译为等价的一句或是几句机器指令。比如ldr这条伪指令，它的意思是将内存地址中的某个内容加载至寄存器，也就是“load to register”的意思，因此，ldr指令的第二个参数的含义是取得这个标号所指示的内存地址处的内容，将其加载到第一个参数所指定的寄存器中去。注意，是加载第二个参数所指示的内存地址处的内容，而不是加载内存地址。这里非常容易搞错，其原因是该伪指令经常会和ARM的一条机器指令，即LDR搞混。LDR的用法如下：
```armasm
LDR	R0, [R1]
```
这里LDR的含义是将R1（R1本身是寄存器）指示的内存地址处的内容加载至R0。看上去好像和ldr伪指令区别不大，但是ldr伪指令的第二个参数是不写那个中括号的，它通常是代码中的一个标号，正因为实际汇编代码中经常要用到加载标号处内容的这种处理，因此LDR指令本身并不是太好用，所以才产生了ldr伪指令。但它们的写法不同，初学者经常会非常迷惑。

vectors.S文件中的处理其实并不多，主要都是关于中断向量表的直接处理，下面把vectors.S中的主要处理都列出来：
```armasm
_undefined_instruction:	.word undefined_instruction
_software_interrupt:	.word software_interrupt
_prefetch_abort:	.word prefetch_abort
_data_abort:		.word data_abort
_not_used:		.word not_used
_irq:			.word irq
_fiq:			.word fiq

	.balignl 16,0xdeadbeef

/* SPL interrupt handling: just hang */

#ifdef CONFIG_SPL_BUILD

	.align	5
undefined_instruction:
software_interrupt:
prefetch_abort:
data_abort:
not_used:
irq:
fiq:

1:
	bl	1b			/* hang and never return */

#else	/* !CONFIG_SPL_BUILD */

/* IRQ stack memory (calculated at run-time) + 8 bytes */
.globl IRQ_STACK_START_IN
IRQ_STACK_START_IN:
	.word	0x0badc0de

/*
 * exception handlers
 */

	.align  5
undefined_instruction:
	get_bad_stack
	bad_save_user_regs
	bl	do_undefined_instruction

	.align	5
software_interrupt:
	get_bad_stack
	bad_save_user_regs
	bl	do_software_interrupt

	.align	5
prefetch_abort:
	get_bad_stack
	bad_save_user_regs
	bl	do_prefetch_abort

	.align	5
data_abort:
	get_bad_stack
	bad_save_user_regs
	bl	do_data_abort

	.align	5
not_used:
	get_bad_stack
	bad_save_user_regs
	bl	do_not_used
	
#endif	/* CONFIG_SPL_BUILD */
```
可以看到对于中断向量的处理分为了spl（即定义了宏CONFIG_SPL_BUILD的情况）和非spl（未定义宏CONFIG_SPL_BUILD的情况）两种。其中spl的情况非常简单，就是将所有的异常处理都简单的设定为“死循环”，就是下面这个处理：
```armasm
1:
	bl	1b			/* hang and never return */
```
而非spl的处理才是真正的异常处理。那啥叫spl呢，这个必须从三星Exynos4412的启动方式说起。  

做过2410开发的程序员大都会有这么一个印象，三星采用了一种非常怪异的启动方式，即stepping stone方式（从Nand Flash）开始bootloader的运行。相对于这种方式，从Nor启动的方式则容易理解很多。为什么要设计出这么一个怪异的stepping stone的启动方式呢？直到我最近看到了一篇文章，才想明白了其中的关键。Nor Flash虽然支持随机访问，很适合用于固件的启动，但制造工艺决定了制作大容量的Nor Flash是一件非常麻烦的事情。不仅如此，Nor Flash的速度也是个大问题。因此三星从很早就开始考虑一种绕开Nor Flash的启动方式，即从Nand Flash启动的方式（stepping stone），当然Nand Flash是不支持随机访问的，因此在启动之初将Nand Flash中的先加载至内存再运行就成了一个非常合理的选择。  

这种stepping stone的方式在后来的6410、V110/210和4412等ARM系列CPU中都得到了发展。在这种启动机制下，三星的设想是这样，先将Nand Flash中的Bootloader代码先加载至片内RAM（通常是SRAM），在Bootloader中初始化片外RAM，然后再将Linux等操作系统之类的大型程序加载到片外RAM中运行。  

理想很丰满，现实很骨感。三星不曾想到U-boot之类的通用启动程序的尺寸越来越大，通常CPU片上SRAM的容量都在几十到几百KB这个量级，但目前U-Boot的整体尺寸通常超过500KB，因此这里就存在了一个矛盾，U-Boot根本无法整体装入片上SRAM！介于此，U-Boot设计者另辟蹊径，将U-Boot一分为二，第一部分称做uboot-spl，这个代码是先加载到片上RAM的，它的尺寸通常很小，主要完成片外RAM初始化的工作；第二部分才是真正具备Bootloader功能的代码，即通常意义的uboot，它的尺寸较大，通常被直接加载至片外RAM，完成Linux等后续程序的引导。  

具体的异常处理代码中还有一个要注意的ARM汇编语法，即汇编宏定义。如下：  
```armasm
.macro get_bad_stack
……
.endm
```
既然叫作宏，那么它和C/C++中的宏定义作用是一样的，用的时候直接展开就可以了。  

关于中断向量表还有一个必须要搞清楚的问题，那就是它的加载地址。熟悉MCU开发的程序员可能习惯了中断向量表被摆放在0x00000000或者0xFFFF0000这一做法，这也是ARM处理器规范定义的方式（两个地址的切换可以通过cp15协处理器进行配置）。但在4412中，这并不是常见的方式。为什么呢，因为在ARM9中，0x00000000地址通常对应的是内部iROM地址，这个地址是程序员无法修改的，而Bootloader程序（通常是U-Boot），也就是三星定义的BL2，它通常会被加载至0x02023400这一地址，也就是说，按照正常的加载方式，中断向量表（BL2的开始部分）将位于0x02023400这个地址，这怎么办呢？   

ARM处理器的设计者显然也考虑到了这个问题，因此他们借助于cp15协处理器搞了另外一套机制来规避这个头大的0地址悖论。该机制是这样来运行的，在cp15协处理器中设计了一个VBAR寄存器，用户可以通过这个寄存器来将中断向量表的首地址映射到内存的任意地址。开启这个VBAR后，异常发生时便不再跳转至0地址，而是跳转至VBAR中写好的地址，这样就不存在0地址不能访问的问题了。  

三星公司在稍早些的CPU，如S5PV210中还尝试了另外一种机制，即当程序在片内RAM运行时，处理器开辟一块自己的中断向量表映射区，用户可以将代码中的中断向量表拷贝至这里，当异常发生时，程序会跳转到这个片内RAM地址，这也也解决了0地址无法使用的问题。  

uboot-spl运行时，异常发生的情况比较少，后面的U-Boot主要关注在外存中运行时的情况，也就是设定并启动VBAR的动作，这可以在start.S的分析中看到。  

### 从start.S开始
先来看start.S文件最前面的include部分。
```armasm
#include <asm-offsets.h>
#include <config.h>
#include <asm/system.h>
#include <linux/linkage.h>
```
到哪里去找这些include头文件呢？一般是下面两个目录：
1. 根目录下的include目录
2. arch/arm/include目录
这两个目录都是直接在Makefile配置文件中显示指定的。

比如上面的system.h头文件，它保存在arch/arm/include/asm目录下，而linkage.h头文件则保存在include/linux目录下。

下面我们循着start.S中reset的运行轨迹，一步步的来解析这个start.S中究竟做了一些什么操作。  

先看第一段代码。start.S和中断向量表衔接的部分就是reset标号，它的相关处理如下：
```armasm
reset:
	/* Allow the board to save important registers */
	b	save_boot_params
save_boot_params_ret:
	mrs	r0, cpsr
……
ENTRY(save_boot_params)
	b	save_boot_params_ret		@ back to my caller
ENDPROC(save_boot_params)
	.weak	save_boot_params
```
这是一个非常怪的家伙，因为save_boot_params_ret又返回到最前面的reset函数那里去了。所以这个函数其实啥也没干。那它是干啥用的呢？其实它是在OMAP处理器的初始化中使用的，这里就不多关注它了。  

来看看ENTRY和ENDPROC两个宏会展开成什么样子。  

ENTRY这个宏是在include/linux/linkage.h中定义的。相关代码如下：
```armasm
#define ASM_NL		 `	/* define in asm/linkage.h, and use '`' to mark new line in macro */

#define SYMBOL_NAME(X)		X

#ifdef __STDC__
#define SYMBOL_NAME_LABEL(X)	X##:
#else
#define SYMBOL_NAME_LABEL(X)	X:
#endif

#ifndef __ALIGN
#define __ALIGN .align		4
#endif

#define ALIGN			__ALIGN

#define LENTRY(name) \
	ALIGN ASM_NL \
	SYMBOL_NAME_LABEL(name)

#define ENTRY(name) \
	.globl SYMBOL_NAME(name) ASM_NL \
	LENTRY(name)

#define WEAK(name) \
	.weak SYMBOL_NAME(name) ASM_NL \
	LENTRY(name)

#ifndef END
#define END(name) \
	.size name, .-name
#endif

#ifndef ENDPROC
#define ENDPROC(name) \
	.type name STT_FUNC ASM_NL \
	END(name)
#endif
```
有一个常用的知识点，像.type、.size和.weak这类定义应该在gcc的[汇编器as的手册](https://sourceware.org/binutils/docs/)中去查询，记住哦。  
所以，ENTRY和ENDPROC两个宏的部分全部展开后会是下面这个样子：  
```armasm
.globl save_boot_params
.align 4
save_boot_params
b	save_boot_params_ret
.type save_boot_params STT_FUNC
.size save_boot_params, .-save_boot_params
.weak save_boot_params
```
这里完整的意思应该是这样：
- 定义一个全局标号save_boot_params
- 该标号的首地址是4字节对齐的
- 执行命令（调用这个函数）
- 执行命令（返回）
- 该标号是一个函数名
- 该函数的长度可以计算出来
- 该标号是一个弱标号

再看第二段代码——save_boot_params_ret。这里注释写得很清楚，是要将CPU切换至超级用户（supervisor）模式，具体处理如下：
```armasm
save_boot_params_ret:
	/*
	 * disable interrupts (FIQ and IRQ), also set the cpu to SVC32 mode,
	 * except if in HYP mode already
	 */
	mrs	r0, cpsr
	and	r1, r0, #0x1f		@ mask mode bits
	teq	r1, #0x1a				@ test for HYP mode
	bicne	r0, r0, #0x1f		@ clear all mode bits
	orrne	r0, r0, #0x13		@ set SVC mode
	orr	r0, r0, #0xc0		@ disable FIQ and IRQ
	msr	cpsr,r0
```
这里主要是通过对cpsr寄存器的设定来完成的，这个寄存器是属于ARM内核的状态寄存器。说到这里，应该首先梳理一下ARM的寄存器设计。  

ARM处理器共有37个寄存器，这37个寄存器按照其在用户编程中的功能划分，可分为两类寄存器，即31个通用寄存器和6个状态寄存器。6个状态寄存器在ARM按照公司的名称分别为：CPSR、SPSR_svc、SPSR_abt、SPSR_und、SPSR_irq和SPSR_fig。所有处理器模式下都可访问当前程序状态寄存器CPSR。CPSR中包含条件码标志、中断禁止位、当前处理器模式以及其他状态和控制信息。每种异常模式下都有一个对应的程序状态寄存器SPSR。当异常出现时，SPSR用于保存CPSR的状态，以便异常返回后恢复异常发生时的工作状态。  

CPSR有4个8位区域：标志域（F）、状态域（S）、扩展域（X）、控制域（C）。通常会用MRS或MSR指令来读写CPSR寄存器的内容。  

关于CPSR寄存器的详细信息应该去《ARMv7 Architecture Reference Manual ARMv7-A and ARMv7-R edition》这个手册（以下简称ARMv7 ARM）中去查询（我的手册版本在1148页）。具体来说，CPSR的寄存器描述如下表所示：   

|31~28|  27 |26~25|  24 |23~20|19~16|15~10|  9  | 8~6 |  5  | 4~0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|N,Z,C,V|Q|IT[1:0]|J|Reserved|GE[3:0]|IT[7:2]|  E  | A,I,F |  T  |M[4:0]|

回头来看上面那段代码，mrs指令先将CPSR寄存器中的内容读至r0，然后中间的一堆and和orr操作主要做了两件事情：  
1. 将Mode（最低5位）置为Supervisor模式；  
2. 将I位（中断）和F位（快中断）禁止；  

然后在将r0的值写回到CPSR寄存器，这样就完成了这个函数的所有功能。  

下面来到第三段代码，这段代码有个条件编译选项，它的含义是除了OMAP的spl以外都需要编译，也就是说，这段代码在4412的U-Boot中肯定是有效的。详细的代码如下：  
```armasm
/*
 * Setup vector:
 * (OMAP4 spl TEXT_BASE is not 32 byte aligned.
 * Continue to use ROM code vector only in OMAP4 spl)
 */
#if !(defined(CONFIG_OMAP44XX) && defined(CONFIG_SPL_BUILD))
	/* Set V=0 in CP15 SCTLR register - for VBAR to point to vector */
	mrc	p15, 0, r0, c1, c0, 0	@ Read CP15 SCTLR Register
	bic	r0, #CR_V		@ V = 0
	mcr	p15, 0, r0, c1, c0, 0	@ Write CP15 SCTLR Register

	/* Set vector address in CP15 VBAR register */
	ldr	r0, =_start
	mcr	p15, 0, r0, c12, c0, 0	@Set VBAR
#endif
```
这段代码主要是做我们之前提到的一件事情，即设定VBAR，也就是将中断向量表重新定位。  

这部分处理牵涉到一个很重要的知识点，即cp15协处理器的设定。cp15是一个协处理器，这是ARM内核规范中就设计好的，这个协处理器中存在几十个寄存器，提供了花样繁多的控制功能。协处理器也不只有cp15，还有cp14（debug功能）、cp13/cp12（保留）、cp11（双精度计算）、cp10（单精度计算）、cp9/cp8（保留）、cp7~cp0（给厂商使用）等，只不过cp15协处理器中的功能我们编程时使用到的频率比较高，因为cp15涉及了MMU管理、Cache管理、中断向量管理等常用功能。  

观察上面关于cp15寄存器的操作指令，可以知道，读写协处理器寄存器的方法和读写通用寄存器基本是相同的，都是采用所谓“读/修改/写”方式，只不过具体的读写指令参数有些不同。  

mrc指令（读取协处理器寄存器的值，写入到通用寄存器中）的格式像下面这样：
```armasm
mrc p15, opc1, crn, crm, opc2
```
要了解这些参数的含义，还得借助手册。cp15寄存器的详细信息在ARMv7 ARM中有详细的描述，可以参考下图（我的手册版本在2526页）：  
![图1](./res/cp15.JPG)
*图1 cp15协处理器寄存器组成*     

其中crn从c0到c15的寄存器还有各自的详细图示，就不在此全部列举了。总的来说，可以这样来理解cp15协处理器中寄存器的组织。首先根据cr0将cp15协处理器中的寄存器分为了c0到c15，共计16组寄存器，然后根据cr1将每组寄存器又详细分为不同的子寄存器组。  

现在再来看上面的最先出现的一对mrc和mcr指令所对应的寄存器，因为crn=C1，ocp1=0，crm=c0，opc2=0，因此可以查询到对应的是要操作“System control registers”，继续看手册后面的说明，得知先头这几句主要是要将SCTLR的V位清空，也就是将中断向量表设定为使用低地址（0x00000000），此时系统可以进行Remap（中断向量表重映射）。  

后面还有一句mcr的操作：
```armasm
ldr	r0, =_start
mcr	p15, 0, r0, c12, c0, 0	@Set VBAR
```
它的作用是将“_start”标号处的地址放入cp15的c12寄存器中，这个VBAR就是重定位后的中断向量表地址。  

关于协处理器，由其是cp15的设定方法我们应该牢记心中，需要的时候应该能够迅速从手册中查找到相关信息，这样在分析ARM的系统级代码时方可从容不迫。  




### 参考文献  
[麦子学院：看懂uboot的神秘面容](http://www.maiziedu.com/course/34-2512/)  
[基于ARM Cortex A9的嵌入式Linux内核移植研究与实现](https://www.scribd.com/document/376681396/%E5%9F%BA%E4%BA%8EARM-Cortex-A9%E7%9A%84%E5%B5%8C%E5%85%A5%E5%BC%8FLinux%E5%86%85%E6%A0%B8%E7%A7%BB%E6%A4%8D%E7%A0%94%E7%A9%B6%E4%B8%8E%E5%AE%9E%E7%8E%B0)  
[uboot-2015-07的start.S的文件启动过程](https://blog.csdn.net/u013904227/article/details/51648179)  
