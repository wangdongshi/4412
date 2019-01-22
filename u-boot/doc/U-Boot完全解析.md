# X4412 U-Boot详细解析

---

### 移植环境

- 开发环境 ： Win7（64位） + Virtualbox + Ubuntu16.04（64位）
- 主开发板 ： 九鼎创展X4412

| 器件 | 型号             | 厂商    | 描述                                          |
| ---- | ---------------- | ------- | --------------------------------------------- |
| CPU  | Exynos 4412      | Samsung | Cortex-A9, Quad Core                          |
| DDR  | NT5CB128M16FP-D1 | Nanya   | DDR3x4, 2Gb, 128Mx16, 800MHz, BGA96           |
| eMMC | THGBMBG6D1KBAIL  | Toshiba | MLC NAND, Serial, 3.3V, 64G-bit, 153-Pin FBGA |

- 基础u-boot版本 ： u-boot-2015-10
- 交叉编译工具链 ： 友善之臂提供的arm-linux-gcc-4.5.1-v6-vfp-20101103.tgz

### U-boot入口

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
这便是整个工程的入口了。但是这个文件中并不存在reset标号，reset在哪里呢？它在arch/arm/cpu/armv7/start.S这个文件中，从这里开始，该U-boot工程的流程便和以前的U-boot差不多了。记住，U-Boot工程中有很多start.S，但是arch（体系结构）下相应架构下的那个start.S才是自己工程的真正入口。

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

严格来说“中断向量表”这个叫法并不严谨，因为这里处理的是一些“异常”。通常“异常”比“中断”的优先级要高，异常是指CPU在运行期间遇到的一些有问题的状况，比如这里看到的指令异常、预取指异常等等，遇到这些问题时CPU必须停下来去做相应的处理，而不能“屏蔽”异常。而“中断”则不同，中断是一些正常的外设发来的，打断CPU正常处理顺序的一些指示信号，这些信号取决于用户的需要，是可以选择性进行屏蔽的。

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
```
可以看到对于中断向量的处理分为了spl（即定义了宏CONFIG_SPL_BUILD的情况）和非spl（未定义宏CONFIG_SPL_BUILD的情况）两种。其中spl的情况非常简单，就是将所有的异常处理都简单的设定为“死循环”，就是下面这个处理：
```armasm
1:
	bl	1b			/* hang and never return */
```
而非spl的处理才是真正的异常处理。那啥叫spl呢，这个必须从三星Exynos4412的启动方式说起。


这个reset在start.S中，它的定义如下：
```armasm
reset:
	/* Allow the board to save important registers */
	b	save_boot_params
	
……

ENTRY(save_boot_params)
	b	save_boot_params_ret		@ back to my caller
ENDPROC(save_boot_params)
	.weak	save_boot_params
```


https://blog.csdn.net/u013904227/article/details/51648179
