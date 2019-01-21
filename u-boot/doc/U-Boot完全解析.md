# X4412 U-Boot详细解析

---

### 移植环境

- 开发环境 ：Win7（64位） + Virtualbox + Ubuntu16.04（64位）
- 主开发板 ：九鼎创展X4412

| 器件 | 型号             | 厂商    | 描述                                          |
| ---- | ---------------- | ------- | --------------------------------------------- |
| CPU  | Exynos 4412      | Samsung | Cortex-A9, Quad Core                          |
| DDR  | NT5CB128M16FP-D1 | Nanya   | DDR3x4, 2Gb, 128Mx16, 800MHz, BGA96           |
| eMMC | THGBMBG6D1KBAIL  | Toshiba | MLC NAND, Serial, 3.3V, 64G-bit, 153-Pin FBGA |

- 基础u-boot版本 ：u-boot-2015-10
- 交叉编译工具链 ：友善之臂提供的arm-linux-gcc-4.5.1-v6-vfp-20101103.tgz

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
这两个目录都是直接在Makefile文件中显示指定的。


https://blog.csdn.net/u013904227/article/details/51648179
