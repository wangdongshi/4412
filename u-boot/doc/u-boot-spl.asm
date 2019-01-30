
u-boot-spl:     file format elf32-littlearm


Disassembly of section .text:

02023400 <__start>:

#ifdef CONFIG_SYS_DV_NOR_BOOT_CFG
	.word	CONFIG_SYS_DV_NOR_BOOT_CFG
#endif

	b	reset
 2023400:	ea000016 	b	2023460 <reset>
	ldr	pc, _undefined_instruction
 2023404:	e59ff014 	ldr	pc, [pc, #20]	; 2023420 <_undefined_instruction>
	ldr	pc, _software_interrupt
 2023408:	e59ff014 	ldr	pc, [pc, #20]	; 2023424 <_software_interrupt>
	ldr	pc, _prefetch_abort
 202340c:	e59ff014 	ldr	pc, [pc, #20]	; 2023428 <_prefetch_abort>
	ldr	pc, _data_abort
 2023410:	e59ff014 	ldr	pc, [pc, #20]	; 202342c <_data_abort>
	ldr	pc, _not_used
 2023414:	e59ff014 	ldr	pc, [pc, #20]	; 2023430 <_not_used>
	ldr	pc, _irq
 2023418:	e59ff014 	ldr	pc, [pc, #20]	; 2023434 <_irq>
	ldr	pc, _fiq
 202341c:	e59ff014 	ldr	pc, [pc, #20]	; 2023438 <_fiq>

02023420 <_undefined_instruction>:
 2023420:	02023440 	.word	0x02023440

02023424 <_software_interrupt>:
 2023424:	02023440 	.word	0x02023440

02023428 <_prefetch_abort>:
 2023428:	02023440 	.word	0x02023440

0202342c <_data_abort>:
 202342c:	02023440 	.word	0x02023440

02023430 <_not_used>:
 2023430:	02023440 	.word	0x02023440

02023434 <_irq>:
 2023434:	02023440 	.word	0x02023440

02023438 <_fiq>:
 2023438:	02023440 	.word	0x02023440
 202343c:	deadbeef 	.word	0xdeadbeef

02023440 <data_abort>:
not_used:
irq:
fiq:

1:
	bl	1b			/* hang and never return */
 2023440:	ebfffffe 	bl	2023440 <data_abort>
 2023444:	e320f000 	nop	{0}
 2023448:	e320f000 	nop	{0}
 202344c:	e320f000 	nop	{0}
 2023450:	e320f000 	nop	{0}
 2023454:	e320f000 	nop	{0}
 2023458:	e320f000 	nop	{0}
 202345c:	e320f000 	nop	{0}

02023460 <reset>:
	.globl	reset
	.globl	save_boot_params_ret

reset:
	/* Allow the board to save important registers */
	b	save_boot_params
 2023460:	ea000024 	b	20234f8 <save_boot_params>

02023464 <save_boot_params_ret>:
save_boot_params_ret:
	/*
	 * disable interrupts (FIQ and IRQ), also set the cpu to SVC32 mode,
	 * except if in HYP mode already
	 */
	mrs	r0, cpsr
 2023464:	e10f0000 	mrs	r0, CPSR
	and	r1, r0, #0x1f		@ mask mode bits
 2023468:	e200101f 	and	r1, r0, #31
	teq	r1, #0x1a		@ test for HYP mode
 202346c:	e331001a 	teq	r1, #26
	bicne	r0, r0, #0x1f		@ clear all mode bits
 2023470:	13c0001f 	bicne	r0, r0, #31
	orrne	r0, r0, #0x13		@ set SVC mode
 2023474:	13800013 	orrne	r0, r0, #19
	orr	r0, r0, #0xc0		@ disable FIQ and IRQ
 2023478:	e38000c0 	orr	r0, r0, #192	; 0xc0
	msr	cpsr,r0
 202347c:	e129f000 	msr	CPSR_fc, r0
 * (OMAP4 spl TEXT_BASE is not 32 byte aligned.
 * Continue to use ROM code vector only in OMAP4 spl)
 */
#if !(defined(CONFIG_OMAP44XX) && defined(CONFIG_SPL_BUILD))
	/* Set V=0 in CP15 SCTLR register - for VBAR to point to vector */
	mrc	p15, 0, r0, c1, c0, 0	@ Read CP15 SCTLR Register
 2023480:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
	bic	r0, #CR_V		@ V = 0
 2023484:	e3c00a02 	bic	r0, r0, #8192	; 0x2000
	mcr	p15, 0, r0, c1, c0, 0	@ Write CP15 SCTLR Register
 2023488:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}

	/* Set vector address in CP15 VBAR register */
	ldr	r0, =_start
 202348c:	e59f00bc 	ldr	r0, [pc, #188]	; 2023550 <cpu_init_cp15+0x54>
	mcr	p15, 0, r0, c12, c0, 0	@Set VBAR
 2023490:	ee0c0f10 	mcr	15, 0, r0, cr12, cr0, {0}
	bl	cpu_init_cp15
	bl	cpu_init_crit
#endif

	/* PS-Hold high */
	ldr	r0, =0x1002330c
 2023494:	e59f00b8 	ldr	r0, [pc, #184]	; 2023554 <cpu_init_cp15+0x58>
	ldr	r1, [r0]
 2023498:	e5901000 	ldr	r1, [r0]
	orr	r1, r1, #0x300
 202349c:	e3811c03 	orr	r1, r1, #768	; 0x300
	str	r1, [r0]
 20234a0:	e5801000 	str	r1, [r0]

	/* initialize LED */
	ldr	r0, =0x11000C20 /* GPX1CON : LED22,LED23 */
 20234a4:	e59f00ac 	ldr	r0, [pc, #172]	; 2023558 <cpu_init_cp15+0x5c>
	ldr	r1, =0x11000000 /* D22:GPX1_6, D23:GPX1_7 */
 20234a8:	e3a01411 	mov	r1, #285212672	; 0x11000000
	str	r1, [r0]
 20234ac:	e5801000 	str	r1, [r0]
	ldr	r0, =0x11000C40 /* GPX2CON : LED24,LED25 */
 20234b0:	e59f00a4 	ldr	r0, [pc, #164]	; 202355c <cpu_init_cp15+0x60>
	ldr	r1, =0x11000000 /* D24:GPX2_6, D25:GPX2_7 */
 20234b4:	e3a01411 	mov	r1, #285212672	; 0x11000000
	str	r1, [r0]
 20234b8:	e5801000 	str	r1, [r0]
	
	/* switch on LED22 */
	ldr	r0, =0x11000C24 /* GPX1DAT */
 20234bc:	e59f009c 	ldr	r0, [pc, #156]	; 2023560 <cpu_init_cp15+0x64>
	ldr	r1, [r0]
 20234c0:	e5901000 	ldr	r1, [r0]
	bic	r1, r1, #0x40
 20234c4:	e3c11040 	bic	r1, r1, #64	; 0x40
	orr	r1, r1, #0x80
 20234c8:	e3811080 	orr	r1, r1, #128	; 0x80
	str	r1, [r0]
 20234cc:	e5801000 	str	r1, [r0]
	ldr	r0, =0x11000C44 /* GPX2DAT */
 20234d0:	e59f008c 	ldr	r0, [pc, #140]	; 2023564 <cpu_init_cp15+0x68>
	ldr	r1, [r0]
 20234d4:	e5901000 	ldr	r1, [r0]
	orr	r1, r1, #0x40
 20234d8:	e3811040 	orr	r1, r1, #64	; 0x40
	orr	r1, r1, #0x80
 20234dc:	e3811080 	orr	r1, r1, #128	; 0x80
	str	r1, [r0]
 20234e0:	e5801000 	str	r1, [r0]

	bl	_main
 20234e4:	eb000590 	bl	2024b2c <_main>

020234e8 <c_runtime_cpu_setup>:
ENTRY(c_runtime_cpu_setup)
/*
 * If I-cache is enabled invalidate it
 */
#ifndef CONFIG_SYS_ICACHE_OFF
	mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache
 20234e8:	ee070f15 	mcr	15, 0, r0, cr7, cr5, {0}
	mcr     p15, 0, r0, c7, c10, 4	@ DSB
 20234ec:	ee070f9a 	mcr	15, 0, r0, cr7, cr10, {4}
	mcr     p15, 0, r0, c7, c5, 4	@ ISB
 20234f0:	ee070f95 	mcr	15, 0, r0, cr7, cr5, {4}
#endif

	bx	lr
 20234f4:	e12fff1e 	bx	lr

020234f8 <save_boot_params>:
 * Stack pointer is not yet initialized at this moment
 * Don't save anything to stack even if compiled with -O0
 *
 *************************************************************************/
ENTRY(save_boot_params)
	b	save_boot_params_ret		@ back to my caller
 20234f8:	eaffffd9 	b	2023464 <save_boot_params_ret>

020234fc <cpu_init_cp15>:
 *************************************************************************/
ENTRY(cpu_init_cp15)
	/*
	 * Invalidate L1 I/D
	 */
	mov	r0, #0			@ set up for MCR
 20234fc:	e3a00000 	mov	r0, #0
	mcr	p15, 0, r0, c8, c7, 0	@ invalidate TLBs
 2023500:	ee080f17 	mcr	15, 0, r0, cr8, cr7, {0}
	mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache
 2023504:	ee070f15 	mcr	15, 0, r0, cr7, cr5, {0}
	mcr	p15, 0, r0, c7, c5, 6	@ invalidate BP array
 2023508:	ee070fd5 	mcr	15, 0, r0, cr7, cr5, {6}
	mcr     p15, 0, r0, c7, c10, 4	@ DSB
 202350c:	ee070f9a 	mcr	15, 0, r0, cr7, cr10, {4}
	mcr     p15, 0, r0, c7, c5, 4	@ ISB
 2023510:	ee070f95 	mcr	15, 0, r0, cr7, cr5, {4}

	/*
	 * disable MMU stuff and caches
	 */
	mrc	p15, 0, r0, c1, c0, 0
 2023514:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
	bic	r0, r0, #0x00002000	@ clear bits 13 (--V-)
 2023518:	e3c00a02 	bic	r0, r0, #8192	; 0x2000
	bic	r0, r0, #0x00000007	@ clear bits 2:0 (-CAM)
 202351c:	e3c00007 	bic	r0, r0, #7
	orr	r0, r0, #0x00000002	@ set bit 1 (--A-) Align
 2023520:	e3800002 	orr	r0, r0, #2
	orr	r0, r0, #0x00000800	@ set bit 11 (Z---) BTB
 2023524:	e3800b02 	orr	r0, r0, #2048	; 0x800
#ifdef CONFIG_SYS_ICACHE_OFF
	bic	r0, r0, #0x00001000	@ clear bit 12 (I) I-cache
#else
	orr	r0, r0, #0x00001000	@ set bit 12 (I) I-cache
 2023528:	e3800a01 	orr	r0, r0, #4096	; 0x1000
#endif
	mcr	p15, 0, r0, c1, c0, 0
 202352c:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
	mrc	p15, 0, r0, c15, c0, 1	@ read diagnostic register
	orr	r0, r0, #1 << 21	@ set bit #21
	mcr	p15, 0, r0, c15, c0, 1	@ write diagnostic register
#endif

	mov	r5, lr			@ Store my Caller
 2023530:	e1a0500e 	mov	r5, lr
	mrc	p15, 0, r1, c0, c0, 0	@ r1 has Read Main ID Register (MIDR)
 2023534:	ee101f10 	mrc	15, 0, r1, cr0, cr0, {0}
	mov	r3, r1, lsr #20		@ get variant field
 2023538:	e1a03a21 	lsr	r3, r1, #20
	and	r3, r3, #0xf		@ r3 has CPU variant
 202353c:	e203300f 	and	r3, r3, #15
	and	r4, r1, #0xf		@ r4 has CPU revision
 2023540:	e201400f 	and	r4, r1, #15
	mov	r2, r3, lsl #4		@ shift variant field for combined value
 2023544:	e1a02203 	lsl	r2, r3, #4
	orr	r2, r4, r2		@ r2 has combined CPU variant + revision
 2023548:	e1842002 	orr	r2, r4, r2
	pop	{r1-r5}			@ Restore the cpu info - fall through

skip_errata_621766:
#endif

	mov	pc, r5			@ back to my caller
 202354c:	e1a0f005 	mov	pc, r5
 2023550:	02023400 	.word	0x02023400
 2023554:	1002330c 	.word	0x1002330c
 2023558:	11000c20 	.word	0x11000c20
 202355c:	11000c40 	.word	0x11000c40
 2023560:	11000c24 	.word	0x11000c24
 2023564:	11000c44 	.word	0x11000c44

02023568 <set_ps_hold_ctrl>:
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
IS_SAMSUNG_TYPE(exynos5, 0x5)
 2023568:	e59f301c 	ldr	r3, [pc, #28]	; 202358c <set_ps_hold_ctrl+0x24>
 202356c:	e5933000 	ldr	r3, [r3]
 2023570:	e1a03623 	lsr	r3, r3, #12
 * after the initial power-on condition goes away
 * (e.g. power button).
 */
void set_ps_hold_ctrl(void)
{
	if (cpu_is_exynos5())
 2023574:	e3530005 	cmp	r3, #5
	struct exynos5_power *power =
		(struct exynos5_power *)samsung_get_base_power();

	/* Set PS-Hold high */
	setbits_le32(&power->ps_hold_control,
			EXYNOS_PS_HOLD_CONTROL_DATA_HIGH);
 2023578:	059f3010 	ldreq	r3, [pc, #16]	; 2023590 <set_ps_hold_ctrl+0x28>
 202357c:	05932000 	ldreq	r2, [r3]
 2023580:	03822c01 	orreq	r2, r2, #256	; 0x100
 2023584:	05832000 	streq	r2, [r3]
 2023588:	e12fff1e 	bx	lr
 202358c:	02024dc8 	.word	0x02024dc8
 2023590:	1004330c 	.word	0x1004330c

02023594 <get_reset_status>:
 2023594:	e59f302c 	ldr	r3, [pc, #44]	; 20235c8 <get_reset_status+0x34>
 2023598:	e5933000 	ldr	r3, [r3]
 202359c:	e1a03623 	lsr	r3, r3, #12
	return power->inform1;
}

uint32_t get_reset_status(void)
{
	if (cpu_is_exynos5())
 20235a0:	e3530005 	cmp	r3, #5
static uint32_t exynos5_get_reset_status(void)
{
	struct exynos5_power *power =
		(struct exynos5_power *)samsung_get_base_power();

	return power->inform1;
 20235a4:	059f3020 	ldreq	r3, [pc, #32]	; 20235cc <get_reset_status+0x38>
 20235a8:	05930804 	ldreq	r0, [r3, #2052]	; 0x804
	return power->inform1;
}

uint32_t get_reset_status(void)
{
	if (cpu_is_exynos5())
 20235ac:	012fff1e 	bxeq	lr
SAMSUNG_BASE(usb3_phy, USB3PHY_BASE)
SAMSUNG_BASE(usb_ehci, USB_HOST_EHCI_BASE)
SAMSUNG_BASE(usb_xhci, USB_HOST_XHCI_BASE)
SAMSUNG_BASE(usb_otg, USBOTG_BASE)
SAMSUNG_BASE(watchdog, WATCHDOG_BASE)
SAMSUNG_BASE(power, POWER_BASE)
 20235b0:	e59f2018 	ldr	r2, [pc, #24]	; 20235d0 <get_reset_status+0x3c>
 20235b4:	e3530004 	cmp	r3, #4
 20235b8:	01a03002 	moveq	r3, r2
 20235bc:	13a03000 	movne	r3, #0
static uint32_t exynos4_get_reset_status(void)
{
	struct exynos4_power *power =
		(struct exynos4_power *)samsung_get_base_power();

	return power->inform1;
 20235c0:	e5930804 	ldr	r0, [r3, #2052]	; 0x804
{
	if (cpu_is_exynos5())
		return exynos5_get_reset_status();
	else
		return  exynos4_get_reset_status();
}
 20235c4:	e12fff1e 	bx	lr
 20235c8:	02024dc8 	.word	0x02024dc8
 20235cc:	10040000 	.word	0x10040000
 20235d0:	10020000 	.word	0x10020000

020235d4 <power_exit_wakeup>:

	((resume_func)power->inform0)();
}

void power_exit_wakeup(void)
{
 20235d4:	e92d4008 	push	{r3, lr}
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
IS_SAMSUNG_TYPE(exynos5, 0x5)
 20235d8:	e59f302c 	ldr	r3, [pc, #44]	; 202360c <power_exit_wakeup+0x38>
 20235dc:	e5933000 	ldr	r3, [r3]
 20235e0:	e1a03623 	lsr	r3, r3, #12
	if (cpu_is_exynos5())
 20235e4:	e3530005 	cmp	r3, #5
{
	struct exynos5_power *power =
		(struct exynos5_power *)samsung_get_base_power();
	typedef void (*resume_func)(void);

	((resume_func)power->inform0)();
 20235e8:	059f3020 	ldreq	r3, [pc, #32]	; 2023610 <power_exit_wakeup+0x3c>
	((resume_func)power->inform0)();
}

void power_exit_wakeup(void)
{
	if (cpu_is_exynos5())
 20235ec:	0a000003 	beq	2023600 <power_exit_wakeup+0x2c>
SAMSUNG_BASE(usb3_phy, USB3PHY_BASE)
SAMSUNG_BASE(usb_ehci, USB_HOST_EHCI_BASE)
SAMSUNG_BASE(usb_xhci, USB_HOST_XHCI_BASE)
SAMSUNG_BASE(usb_otg, USBOTG_BASE)
SAMSUNG_BASE(watchdog, WATCHDOG_BASE)
SAMSUNG_BASE(power, POWER_BASE)
 20235f0:	e59f201c 	ldr	r2, [pc, #28]	; 2023614 <power_exit_wakeup+0x40>
 20235f4:	e3530004 	cmp	r3, #4
 20235f8:	01a03002 	moveq	r3, r2
 20235fc:	13a03000 	movne	r3, #0
{
	struct exynos4_power *power =
		(struct exynos4_power *)samsung_get_base_power();
	typedef void (*resume_func)(void);

	((resume_func)power->inform0)();
 2023600:	e5933800 	ldr	r3, [r3, #2048]	; 0x800
 2023604:	e12fff33 	blx	r3
 2023608:	e8bd8008 	pop	{r3, pc}
 202360c:	02024dc8 	.word	0x02024dc8
 2023610:	10040000 	.word	0x10040000
 2023614:	10020000 	.word	0x10020000

02023618 <get_boot_mode>:
static inline int __attribute__((no_instrument_function)) cpu_is_##type(void) \
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
 2023618:	e59f302c 	ldr	r3, [pc, #44]	; 202364c <get_boot_mode+0x34>
 202361c:	e5933000 	ldr	r3, [r3]
 2023620:	e1a03623 	lsr	r3, r3, #12
SAMSUNG_BASE(usb3_phy, USB3PHY_BASE)
SAMSUNG_BASE(usb_ehci, USB_HOST_EHCI_BASE)
SAMSUNG_BASE(usb_xhci, USB_HOST_XHCI_BASE)
SAMSUNG_BASE(usb_otg, USBOTG_BASE)
SAMSUNG_BASE(watchdog, WATCHDOG_BASE)
SAMSUNG_BASE(power, POWER_BASE)
 2023624:	e3530004 	cmp	r3, #4
 2023628:	059f3020 	ldreq	r3, [pc, #32]	; 2023650 <get_boot_mode+0x38>
 202362c:	0a000003 	beq	2023640 <get_boot_mode+0x28>
 2023630:	e59f201c 	ldr	r2, [pc, #28]	; 2023654 <get_boot_mode+0x3c>
 2023634:	e3530005 	cmp	r3, #5
 2023638:	01a03002 	moveq	r3, r2
 202363c:	13a03000 	movne	r3, #0

unsigned int get_boot_mode(void)
{
	unsigned int om_pin = samsung_get_base_power();

	return readl(om_pin) & OM_PIN_MASK;
 2023640:	e5930000 	ldr	r0, [r3]
}
 2023644:	e200003e 	and	r0, r0, #62	; 0x3e
 2023648:	e12fff1e 	bx	lr
 202364c:	02024dc8 	.word	0x02024dc8
 2023650:	10020000 	.word	0x10020000
 2023654:	10040000 	.word	0x10040000

02023658 <exynos5_spi_config>:

void exynos5_spi_config(int peripheral)
{
	int cfg = 0, pin = 0, i;

	switch (peripheral) {
 2023658:	e3500046 	cmp	r0, #70	; 0x46
		break;
	}
}

void exynos5_spi_config(int peripheral)
{
 202365c:	e92d4070 	push	{r4, r5, r6, lr}
	int cfg = 0, pin = 0, i;

	switch (peripheral) {
 2023660:	0a000016 	beq	20236c0 <exynos5_spi_config+0x68>
 2023664:	ca000004 	bgt	202367c <exynos5_spi_config+0x24>
 2023668:	e3500044 	cmp	r0, #68	; 0x44
 202366c:	0a000025 	beq	2023708 <exynos5_spi_config+0xb0>
 2023670:	e3500045 	cmp	r0, #69	; 0x45
 2023674:	1a000016 	bne	20236d4 <exynos5_spi_config+0x7c>
 2023678:	ea000024 	b	2023710 <exynos5_spi_config+0xb8>
 202367c:	e3500081 	cmp	r0, #129	; 0x81
 2023680:	0a000011 	beq	20236cc <exynos5_spi_config+0x74>
 2023684:	e3500082 	cmp	r0, #130	; 0x82
 2023688:	1a000013 	bne	20236dc <exynos5_spi_config+0x84>
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_F10;
		break;
	case PERIPH_ID_SPI4:
		for (i = 0; i < 2; i++) {
			gpio_cfg_pin(EXYNOS5_GPIO_F02 + i, S5P_GPIO_FUNC(0x4));
 202368c:	e2800058 	add	r0, r0, #88	; 0x58
 2023690:	e3a01004 	mov	r1, #4
 2023694:	eb000593 	bl	2024ce8 <gpio_cfg_pin>
			gpio_cfg_pin(EXYNOS5_GPIO_E04 + i, S5P_GPIO_FUNC(0x4));
 2023698:	e3a000cc 	mov	r0, #204	; 0xcc
 202369c:	e3a01004 	mov	r1, #4
 20236a0:	eb000590 	bl	2024ce8 <gpio_cfg_pin>
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_F10;
		break;
	case PERIPH_ID_SPI4:
		for (i = 0; i < 2; i++) {
			gpio_cfg_pin(EXYNOS5_GPIO_F02 + i, S5P_GPIO_FUNC(0x4));
 20236a4:	e3a000db 	mov	r0, #219	; 0xdb
 20236a8:	e3a01004 	mov	r1, #4
 20236ac:	eb00058d 	bl	2024ce8 <gpio_cfg_pin>
			gpio_cfg_pin(EXYNOS5_GPIO_E04 + i, S5P_GPIO_FUNC(0x4));
 20236b0:	e3a000cd 	mov	r0, #205	; 0xcd
 20236b4:	e3a01004 	mov	r1, #4
	}
	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
			gpio_cfg_pin(i, cfg);
	}
}
 20236b8:	e8bd4070 	pop	{r4, r5, r6, lr}
		pin = EXYNOS5_GPIO_F10;
		break;
	case PERIPH_ID_SPI4:
		for (i = 0; i < 2; i++) {
			gpio_cfg_pin(EXYNOS5_GPIO_F02 + i, S5P_GPIO_FUNC(0x4));
			gpio_cfg_pin(EXYNOS5_GPIO_E04 + i, S5P_GPIO_FUNC(0x4));
 20236bc:	ea000589 	b	2024ce8 <gpio_cfg_pin>
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_A24;
		break;
	case PERIPH_ID_SPI2:
		cfg = S5P_GPIO_FUNC(0x5);
		pin = EXYNOS5_GPIO_B11;
 20236c0:	e3a05021 	mov	r5, #33	; 0x21
	case PERIPH_ID_SPI1:
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_A24;
		break;
	case PERIPH_ID_SPI2:
		cfg = S5P_GPIO_FUNC(0x5);
 20236c4:	e3a04005 	mov	r4, #5
		pin = EXYNOS5_GPIO_B11;
		break;
 20236c8:	ea000005 	b	20236e4 <exynos5_spi_config+0x8c>
	case PERIPH_ID_SPI3:
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_F10;
 20236cc:	e3a050e0 	mov	r5, #224	; 0xe0
 20236d0:	ea00000f 	b	2023714 <exynos5_spi_config+0xbc>
			gpio_cfg_pin(EXYNOS5_GPIO_F02 + i, S5P_GPIO_FUNC(0x4));
			gpio_cfg_pin(EXYNOS5_GPIO_E04 + i, S5P_GPIO_FUNC(0x4));
		}
		break;
	}
	if (peripheral != PERIPH_ID_SPI4) {
 20236d4:	e3500082 	cmp	r0, #130	; 0x82
 20236d8:	08bd8070 	popeq	{r4, r5, r6, pc}
	}
}

void exynos5_spi_config(int peripheral)
{
	int cfg = 0, pin = 0, i;
 20236dc:	e3a04000 	mov	r4, #0
 20236e0:	e1a05004 	mov	r5, r4
			gpio_cfg_pin(EXYNOS5_GPIO_E04 + i, S5P_GPIO_FUNC(0x4));
		}
		break;
	}
	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
 20236e4:	e2856003 	add	r6, r5, #3
 20236e8:	ea000003 	b	20236fc <exynos5_spi_config+0xa4>
			gpio_cfg_pin(i, cfg);
 20236ec:	e1a00005 	mov	r0, r5
 20236f0:	e1a01004 	mov	r1, r4
 20236f4:	eb00057b 	bl	2024ce8 <gpio_cfg_pin>
			gpio_cfg_pin(EXYNOS5_GPIO_E04 + i, S5P_GPIO_FUNC(0x4));
		}
		break;
	}
	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
 20236f8:	e2855001 	add	r5, r5, #1
 20236fc:	e1560005 	cmp	r6, r5
 2023700:	aafffff9 	bge	20236ec <exynos5_spi_config+0x94>
 2023704:	e8bd8070 	pop	{r4, r5, r6, pc}
	int cfg = 0, pin = 0, i;

	switch (peripheral) {
	case PERIPH_ID_SPI0:
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_A20;
 2023708:	e3a05010 	mov	r5, #16
 202370c:	ea000000 	b	2023714 <exynos5_spi_config+0xbc>
		break;
	case PERIPH_ID_SPI1:
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_A24;
 2023710:	e3a05014 	mov	r5, #20
	case PERIPH_ID_SPI0:
		cfg = S5P_GPIO_FUNC(0x2);
		pin = EXYNOS5_GPIO_A20;
		break;
	case PERIPH_ID_SPI1:
		cfg = S5P_GPIO_FUNC(0x2);
 2023714:	e3a04002 	mov	r4, #2
 2023718:	eafffff1 	b	20236e4 <exynos5_spi_config+0x8c>

0202371c <exynos5420_spi_config>:

void exynos5420_spi_config(int peripheral)
{
	int cfg, pin, i;

	switch (peripheral) {
 202371c:	e3500046 	cmp	r0, #70	; 0x46
			gpio_cfg_pin(i, cfg);
	}
}

void exynos5420_spi_config(int peripheral)
{
 2023720:	e92d4070 	push	{r4, r5, r6, lr}
	int cfg, pin, i;

	switch (peripheral) {
 2023724:	0a00000c 	beq	202375c <exynos5420_spi_config+0x40>
 2023728:	ca000004 	bgt	2023740 <exynos5420_spi_config+0x24>
 202372c:	e3500044 	cmp	r0, #68	; 0x44
 2023730:	0a00000e 	beq	2023770 <exynos5420_spi_config+0x54>
 2023734:	e3500045 	cmp	r0, #69	; 0x45
 2023738:	18bd8070 	popne	{r4, r5, r6, pc}
 202373c:	ea000004 	b	2023754 <exynos5420_spi_config+0x38>
 2023740:	e3500081 	cmp	r0, #129	; 0x81
 2023744:	0a000007 	beq	2023768 <exynos5420_spi_config+0x4c>
 2023748:	e3500082 	cmp	r0, #130	; 0x82
 202374c:	18bd8070 	popne	{r4, r5, r6, pc}
 2023750:	ea00000a 	b	2023780 <exynos5420_spi_config+0x64>
	case PERIPH_ID_SPI0:
		pin = EXYNOS5420_GPIO_A20;
		cfg = S5P_GPIO_FUNC(0x2);
		break;
	case PERIPH_ID_SPI1:
		pin = EXYNOS5420_GPIO_A24;
 2023754:	e3a04014 	mov	r4, #20
 2023758:	ea000005 	b	2023774 <exynos5420_spi_config+0x58>
		cfg = S5P_GPIO_FUNC(0x2);
		break;
	case PERIPH_ID_SPI2:
		pin = EXYNOS5420_GPIO_B11;
 202375c:	e3a04021 	mov	r4, #33	; 0x21
		cfg = S5P_GPIO_FUNC(0x5);
 2023760:	e3a05005 	mov	r5, #5
		break;
 2023764:	ea000003 	b	2023778 <exynos5420_spi_config+0x5c>
	case PERIPH_ID_SPI3:
		pin = EXYNOS5420_GPIO_F10;
 2023768:	e3a040f0 	mov	r4, #240	; 0xf0
 202376c:	ea000000 	b	2023774 <exynos5420_spi_config+0x58>
{
	int cfg, pin, i;

	switch (peripheral) {
	case PERIPH_ID_SPI0:
		pin = EXYNOS5420_GPIO_A20;
 2023770:	e3a04010 	mov	r4, #16
		cfg = S5P_GPIO_FUNC(0x2);
 2023774:	e3a05002 	mov	r5, #2
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}

	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
 2023778:	e2846003 	add	r6, r4, #3
 202377c:	ea000010 	b	20237c4 <exynos5420_spi_config+0xa8>
			gpio_cfg_pin(i, cfg);
	} else {
		for (i = 0; i < 2; i++) {
			gpio_cfg_pin(EXYNOS5420_GPIO_F02 + i,
 2023780:	e3a000ea 	mov	r0, #234	; 0xea
 2023784:	e3a01004 	mov	r1, #4
 2023788:	eb000556 	bl	2024ce8 <gpio_cfg_pin>
				     S5P_GPIO_FUNC(0x4));
			gpio_cfg_pin(EXYNOS5420_GPIO_E04 + i,
 202378c:	e3a000dc 	mov	r0, #220	; 0xdc
 2023790:	e3a01004 	mov	r1, #4
 2023794:	eb000553 	bl	2024ce8 <gpio_cfg_pin>
	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
			gpio_cfg_pin(i, cfg);
	} else {
		for (i = 0; i < 2; i++) {
			gpio_cfg_pin(EXYNOS5420_GPIO_F02 + i,
 2023798:	e3a000eb 	mov	r0, #235	; 0xeb
 202379c:	e3a01004 	mov	r1, #4
 20237a0:	eb000550 	bl	2024ce8 <gpio_cfg_pin>
				     S5P_GPIO_FUNC(0x4));
			gpio_cfg_pin(EXYNOS5420_GPIO_E04 + i,
 20237a4:	e3a000dd 	mov	r0, #221	; 0xdd
 20237a8:	e3a01004 	mov	r1, #4
				     S5P_GPIO_FUNC(0x4));
		}
	}
}
 20237ac:	e8bd4070 	pop	{r4, r5, r6, lr}
			gpio_cfg_pin(i, cfg);
	} else {
		for (i = 0; i < 2; i++) {
			gpio_cfg_pin(EXYNOS5420_GPIO_F02 + i,
				     S5P_GPIO_FUNC(0x4));
			gpio_cfg_pin(EXYNOS5420_GPIO_E04 + i,
 20237b0:	ea00054c 	b	2024ce8 <gpio_cfg_pin>
		return;
	}

	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
			gpio_cfg_pin(i, cfg);
 20237b4:	e1a00004 	mov	r0, r4
 20237b8:	e1a01005 	mov	r1, r5
 20237bc:	eb000549 	bl	2024ce8 <gpio_cfg_pin>
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}

	if (peripheral != PERIPH_ID_SPI4) {
		for (i = pin; i < pin + 4; i++)
 20237c0:	e2844001 	add	r4, r4, #1
 20237c4:	e1560004 	cmp	r6, r4
 20237c8:	aafffff9 	bge	20237b4 <exynos5420_spi_config+0x98>
 20237cc:	e8bd8070 	pop	{r4, r5, r6, pc}

020237d0 <exynos_pinmux_config>:
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
IS_SAMSUNG_TYPE(exynos5, 0x5)
 20237d0:	e59f3aa4 	ldr	r3, [pc, #2724]	; 202427c <exynos_pinmux_config+0xaac>

	return 0;
}

int exynos_pinmux_config(int peripheral, int flags)
{
 20237d4:	e92d4df0 	push	{r4, r5, r6, r7, r8, sl, fp, lr}
 20237d8:	e5932000 	ldr	r2, [r3]
 20237dc:	e1a04000 	mov	r4, r0
 20237e0:	e1a03622 	lsr	r3, r2, #12
	if (cpu_is_exynos5()) {
 20237e4:	e3530005 	cmp	r3, #5

	return 0;
}

int exynos_pinmux_config(int peripheral, int flags)
{
 20237e8:	e1a05001 	mov	r5, r1
	if (cpu_is_exynos5()) {
 20237ec:	1a0001a9 	bne	2023e98 <exynos_pinmux_config+0x6c8>
		if (proid_is_exynos5420() || proid_is_exynos5800())
 20237f0:	e3053420 	movw	r3, #21536	; 0x5420
 20237f4:	e1520003 	cmp	r2, r3
 20237f8:	0a000001 	beq	2023804 <exynos_pinmux_config+0x34>
 20237fc:	e3520b16 	cmp	r2, #22528	; 0x5800
 2023800:	1a0000b0 	bne	2023ac8 <exynos_pinmux_config+0x2f8>
	return 0;
}

static int exynos5420_pinmux_config(int peripheral, int flags)
{
	switch (peripheral) {
 2023804:	e354004e 	cmp	r4, #78	; 0x4e
 2023808:	ca00000d 	bgt	2023844 <exynos_pinmux_config+0x74>
 202380c:	e354004b 	cmp	r4, #75	; 0x4b
 2023810:	aa00002f 	bge	20238d4 <exynos_pinmux_config+0x104>
 2023814:	e354003f 	cmp	r4, #63	; 0x3f
 2023818:	ca000005 	bgt	2023834 <exynos_pinmux_config+0x64>
 202381c:	e3540038 	cmp	r4, #56	; 0x38
 2023820:	aa00007c 	bge	2023a18 <exynos_pinmux_config+0x248>
 2023824:	e2443033 	sub	r3, r4, #51	; 0x33
 2023828:	e3530003 	cmp	r3, #3
 202382c:	8a00028e 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023830:	ea00000e 	b	2023870 <exynos_pinmux_config+0xa0>
 2023834:	e2443044 	sub	r3, r4, #68	; 0x44
 2023838:	e3530002 	cmp	r3, #2
 202383c:	8a00028a 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023840:	ea000071 	b	2023a0c <exynos_pinmux_config+0x23c>
 2023844:	e3540082 	cmp	r4, #130	; 0x82
 2023848:	ca000005 	bgt	2023864 <exynos_pinmux_config+0x94>
 202384c:	e3540081 	cmp	r4, #129	; 0x81
 2023850:	aa00006d 	bge	2023a0c <exynos_pinmux_config+0x23c>
 2023854:	e2443057 	sub	r3, r4, #87	; 0x57
 2023858:	e3530001 	cmp	r3, #1
 202385c:	8a000282 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023860:	ea00006c 	b	2023a18 <exynos_pinmux_config+0x248>
 2023864:	e35400cb 	cmp	r4, #203	; 0xcb
 2023868:	1a00027f 	bne	202426c <exynos_pinmux_config+0xa9c>
 202386c:	ea000069 	b	2023a18 <exynos_pinmux_config+0x248>

static void exynos5420_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023870:	e3540035 	cmp	r4, #53	; 0x35
		start = EXYNOS5420_GPIO_A04;
		count = 4;
		break;
	case PERIPH_ID_UART2:
		start = EXYNOS5420_GPIO_A10;
		count = 4;
 2023874:	03a05004 	moveq	r5, #4
	case PERIPH_ID_UART1:
		start = EXYNOS5420_GPIO_A04;
		count = 4;
		break;
	case PERIPH_ID_UART2:
		start = EXYNOS5420_GPIO_A10;
 2023878:	03a04008 	moveq	r4, #8

static void exynos5420_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 202387c:	0a000008 	beq	20238a4 <exynos_pinmux_config+0xd4>
 2023880:	e3540036 	cmp	r4, #54	; 0x36
		start = EXYNOS5420_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS5420_GPIO_A14;
		count = 2;
 2023884:	03a05002 	moveq	r5, #2
	case PERIPH_ID_UART2:
		start = EXYNOS5420_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS5420_GPIO_A14;
 2023888:	03a0400c 	moveq	r4, #12

static void exynos5420_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 202388c:	0a000004 	beq	20238a4 <exynos_pinmux_config+0xd4>
 2023890:	e3540034 	cmp	r4, #52	; 0x34
	case PERIPH_ID_UART0:
		start = EXYNOS5420_GPIO_A00;
		count = 4;
 2023894:	13a05004 	movne	r5, #4
{
	int i, start, count;

	switch (peripheral) {
	case PERIPH_ID_UART0:
		start = EXYNOS5420_GPIO_A00;
 2023898:	13a04000 	movne	r4, #0
		count = 4;
		break;
	case PERIPH_ID_UART1:
		start = EXYNOS5420_GPIO_A04;
		count = 4;
 202389c:	03a05004 	moveq	r5, #4
	case PERIPH_ID_UART0:
		start = EXYNOS5420_GPIO_A00;
		count = 4;
		break;
	case PERIPH_ID_UART1:
		start = EXYNOS5420_GPIO_A04;
 20238a0:	01a04005 	moveq	r4, r5
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}

	for (i = start; i < start + count; i++) {
 20238a4:	e0855004 	add	r5, r5, r4
 20238a8:	ea000006 	b	20238c8 <exynos_pinmux_config+0xf8>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 20238ac:	e1a00004 	mov	r0, r4
 20238b0:	e3a01000 	mov	r1, #0
 20238b4:	eb0004ed 	bl	2024c70 <gpio_set_pull>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 20238b8:	e1a00004 	mov	r0, r4
 20238bc:	e3a01002 	mov	r1, #2
 20238c0:	eb000508 	bl	2024ce8 <gpio_cfg_pin>
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}

	for (i = start; i < start + count; i++) {
 20238c4:	e2844001 	add	r4, r4, #1
 20238c8:	e1540005 	cmp	r4, r5
 20238cc:	bafffff6 	blt	20238ac <exynos_pinmux_config+0xdc>
 20238d0:	ea000263 	b	2024264 <exynos_pinmux_config+0xa94>

static int exynos5420_mmc_config(int peripheral, int flags)
{
	int i, start = 0, start_ext = 0;

	switch (peripheral) {
 20238d4:	e354004c 	cmp	r4, #76	; 0x4c
 20238d8:	0a000009 	beq	2023904 <exynos_pinmux_config+0x134>
 20238dc:	e354004d 	cmp	r4, #77	; 0x4d
 20238e0:	0a000004 	beq	20238f8 <exynos_pinmux_config+0x128>
 20238e4:	e354004b 	cmp	r4, #75	; 0x4b
	case PERIPH_ID_SDMMC0:
		start = EXYNOS5420_GPIO_C00;
		start_ext = EXYNOS5420_GPIO_C30;
 20238e8:	03a03088 	moveq	r3, #136	; 0x88
{
	int i, start = 0, start_ext = 0;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS5420_GPIO_C00;
 20238ec:	03a06070 	moveq	r6, #112	; 0x70

static int exynos5420_mmc_config(int peripheral, int flags)
{
	int i, start = 0, start_ext = 0;

	switch (peripheral) {
 20238f0:	1a00025d 	bne	202426c <exynos_pinmux_config+0xa9c>
 20238f4:	ea000004 	b	202390c <exynos_pinmux_config+0x13c>
		start = EXYNOS5420_GPIO_C10;
		start_ext = EXYNOS5420_GPIO_D14;
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS5420_GPIO_C20;
		start_ext = 0;
 20238f8:	e3a03000 	mov	r3, #0
	case PERIPH_ID_SDMMC1:
		start = EXYNOS5420_GPIO_C10;
		start_ext = EXYNOS5420_GPIO_D14;
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS5420_GPIO_C20;
 20238fc:	e3a06080 	mov	r6, #128	; 0x80
 2023900:	ea000001 	b	202390c <exynos_pinmux_config+0x13c>
		start = EXYNOS5420_GPIO_C00;
		start_ext = EXYNOS5420_GPIO_C30;
		break;
	case PERIPH_ID_SDMMC1:
		start = EXYNOS5420_GPIO_C10;
		start_ext = EXYNOS5420_GPIO_D14;
 2023904:	e3a0309c 	mov	r3, #156	; 0x9c
	case PERIPH_ID_SDMMC0:
		start = EXYNOS5420_GPIO_C00;
		start_ext = EXYNOS5420_GPIO_C30;
		break;
	case PERIPH_ID_SDMMC1:
		start = EXYNOS5420_GPIO_C10;
 2023908:	e3a06078 	mov	r6, #120	; 0x78
		start = 0;
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return -1;
	}

	if ((flags & PINMUX_FLAG_8BIT_MODE) && !start_ext) {
 202390c:	e2055001 	and	r5, r5, #1
 2023910:	e3530000 	cmp	r3, #0
 2023914:	13a02000 	movne	r2, #0
 2023918:	02052001 	andeq	r2, r5, #1
 202391c:	e3520000 	cmp	r2, #0
 2023920:	1a000251 	bne	202426c <exynos_pinmux_config+0xa9c>
		debug("SDMMC device %d does not support 8bit mode",
		      peripheral);
		return -1;
	}

	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2023924:	e3550000 	cmp	r5, #0
 2023928:	11a05003 	movne	r5, r3
		for (i = start_ext; i <= (start_ext + 3); i++) {
 202392c:	12857003 	addne	r7, r5, #3
		debug("SDMMC device %d does not support 8bit mode",
		      peripheral);
		return -1;
	}

	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2023930:	1a00000c 	bne	2023968 <exynos_pinmux_config+0x198>
 2023934:	e1a05006 	mov	r5, r6
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
		}
	}

	for (i = start; i < (start + 3); i++) {
 2023938:	e2867002 	add	r7, r6, #2
 202393c:	ea000020 	b	20239c4 <exynos_pinmux_config+0x1f4>
		return -1;
	}

	if (flags & PINMUX_FLAG_8BIT_MODE) {
		for (i = start_ext; i <= (start_ext + 3); i++) {
			gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 2023940:	e1a00005 	mov	r0, r5
 2023944:	e3a01002 	mov	r1, #2
 2023948:	eb0004e6 	bl	2024ce8 <gpio_cfg_pin>
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
 202394c:	e1a00005 	mov	r0, r5
 2023950:	e3a01003 	mov	r1, #3
 2023954:	eb0004c5 	bl	2024c70 <gpio_set_pull>
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2023958:	e1a00005 	mov	r0, r5
 202395c:	e3a01003 	mov	r1, #3
 2023960:	eb0004d2 	bl	2024cb0 <gpio_set_drv>
		      peripheral);
		return -1;
	}

	if (flags & PINMUX_FLAG_8BIT_MODE) {
		for (i = start_ext; i <= (start_ext + 3); i++) {
 2023964:	e2855001 	add	r5, r5, #1
 2023968:	e1550007 	cmp	r5, r7
 202396c:	dafffff3 	ble	2023940 <exynos_pinmux_config+0x170>
 2023970:	eaffffef 	b	2023934 <exynos_pinmux_config+0x164>
		 * MMC0 is intended to be used for eMMC. The
		 * card detect pin is used as a VDDEN signal to
		 * power on the eMMC. The 5420 iROM makes
		 * this same assumption.
		 */
		if ((peripheral == PERIPH_ID_SDMMC0) && (i == (start + 2))) {
 2023974:	e354004b 	cmp	r4, #75	; 0x4b
 2023978:	1a000007 	bne	202399c <exynos_pinmux_config+0x1cc>
 202397c:	e1550007 	cmp	r5, r7
 2023980:	1a000005 	bne	202399c <exynos_pinmux_config+0x1cc>
#ifndef CONFIG_SPL_BUILD
			gpio_request(i, "sdmmc0_vdden");
#endif
			gpio_set_value(i, 1);
 2023984:	e3a01001 	mov	r1, #1
 2023988:	e1a00005 	mov	r0, r5
 202398c:	eb0004a9 	bl	2024c38 <gpio_set_value>
			gpio_cfg_pin(i, S5P_GPIO_OUTPUT);
 2023990:	e1a00005 	mov	r0, r5
 2023994:	e3a01001 	mov	r1, #1
 2023998:	ea000001 	b	20239a4 <exynos_pinmux_config+0x1d4>
		} else {
			gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 202399c:	e1a00005 	mov	r0, r5
 20239a0:	e3a01002 	mov	r1, #2
 20239a4:	eb0004cf 	bl	2024ce8 <gpio_cfg_pin>
		}
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 20239a8:	e1a00005 	mov	r0, r5
 20239ac:	e3a01000 	mov	r1, #0
 20239b0:	eb0004ae 	bl	2024c70 <gpio_set_pull>
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
 20239b4:	e1a00005 	mov	r0, r5
 20239b8:	e3a01003 	mov	r1, #3
 20239bc:	eb0004bb 	bl	2024cb0 <gpio_set_drv>
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
		}
	}

	for (i = start; i < (start + 3); i++) {
 20239c0:	e2855001 	add	r5, r5, #1
 20239c4:	e1570005 	cmp	r7, r5
 20239c8:	aaffffe9 	bge	2023974 <exynos_pinmux_config+0x1a4>
		}
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}

	for (i = (start + 3); i <= (start + 6); i++) {
 20239cc:	e2864003 	add	r4, r6, #3
 20239d0:	e2866006 	add	r6, r6, #6
 20239d4:	ea000009 	b	2023a00 <exynos_pinmux_config+0x230>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 20239d8:	e1a00004 	mov	r0, r4
 20239dc:	e3a01002 	mov	r1, #2
 20239e0:	eb0004c0 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(i, S5P_GPIO_PULL_UP);
 20239e4:	e1a00004 	mov	r0, r4
 20239e8:	e3a01003 	mov	r1, #3
 20239ec:	eb00049f 	bl	2024c70 <gpio_set_pull>
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
 20239f0:	e1a00004 	mov	r0, r4
 20239f4:	e3a01003 	mov	r1, #3
 20239f8:	eb0004ac 	bl	2024cb0 <gpio_set_drv>
		}
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}

	for (i = (start + 3); i <= (start + 6); i++) {
 20239fc:	e2844001 	add	r4, r4, #1
 2023a00:	e1540006 	cmp	r4, r6
 2023a04:	dafffff3 	ble	20239d8 <exynos_pinmux_config+0x208>
 2023a08:	ea000215 	b	2024264 <exynos_pinmux_config+0xa94>
	case PERIPH_ID_SPI0:
	case PERIPH_ID_SPI1:
	case PERIPH_ID_SPI2:
	case PERIPH_ID_SPI3:
	case PERIPH_ID_SPI4:
		exynos5420_spi_config(peripheral);
 2023a0c:	e1a00004 	mov	r0, r4
 2023a10:	ebffff41 	bl	202371c <exynos5420_spi_config>
 2023a14:	ea000212 	b	2024264 <exynos_pinmux_config+0xa94>
	}
}

static void exynos5420_i2c_config(int peripheral)
{
	switch (peripheral) {
 2023a18:	e354003d 	cmp	r4, #61	; 0x3d
 2023a1c:	0a0001c3 	beq	2024130 <exynos_pinmux_config+0x960>
 2023a20:	ca00000c 	bgt	2023a58 <exynos_pinmux_config+0x288>
 2023a24:	e354003a 	cmp	r4, #58	; 0x3a
 2023a28:	0a0001b6 	beq	2024108 <exynos_pinmux_config+0x938>
 2023a2c:	ca000004 	bgt	2023a44 <exynos_pinmux_config+0x274>
 2023a30:	e3540038 	cmp	r4, #56	; 0x38
 2023a34:	0a0001a8 	beq	20240dc <exynos_pinmux_config+0x90c>
 2023a38:	e3540039 	cmp	r4, #57	; 0x39
 2023a3c:	1a000208 	bne	2024264 <exynos_pinmux_config+0xa94>
 2023a40:	ea0001aa 	b	20240f0 <exynos_pinmux_config+0x920>
 2023a44:	e354003b 	cmp	r4, #59	; 0x3b
 2023a48:	0a0001b3 	beq	202411c <exynos_pinmux_config+0x94c>
 2023a4c:	e354003c 	cmp	r4, #60	; 0x3c
 2023a50:	1a000203 	bne	2024264 <exynos_pinmux_config+0xa94>
 2023a54:	ea0000ed 	b	2023e10 <exynos_pinmux_config+0x640>
 2023a58:	e3540057 	cmp	r4, #87	; 0x57
 2023a5c:	0a00000a 	beq	2023a8c <exynos_pinmux_config+0x2bc>
 2023a60:	ca000004 	bgt	2023a78 <exynos_pinmux_config+0x2a8>
 2023a64:	e354003e 	cmp	r4, #62	; 0x3e
 2023a68:	0a0001ba 	beq	2024158 <exynos_pinmux_config+0x988>
 2023a6c:	e354003f 	cmp	r4, #63	; 0x3f
 2023a70:	1a0001fb 	bne	2024264 <exynos_pinmux_config+0xa94>
 2023a74:	ea0001bd 	b	2024170 <exynos_pinmux_config+0x9a0>
 2023a78:	e3540058 	cmp	r4, #88	; 0x58
 2023a7c:	0a000007 	beq	2023aa0 <exynos_pinmux_config+0x2d0>
 2023a80:	e35400cb 	cmp	r4, #203	; 0xcb
 2023a84:	1a0001f6 	bne	2024264 <exynos_pinmux_config+0xa94>
 2023a88:	ea000009 	b	2023ab4 <exynos_pinmux_config+0x2e4>
	case PERIPH_ID_I2C7:
		gpio_cfg_pin(EXYNOS5420_GPIO_B22, S5P_GPIO_FUNC(0x3));
		gpio_cfg_pin(EXYNOS5420_GPIO_B23, S5P_GPIO_FUNC(0x3));
		break;
	case PERIPH_ID_I2C8:
		gpio_cfg_pin(EXYNOS5420_GPIO_B34, S5P_GPIO_FUNC(0x2));
 2023a8c:	e3a00034 	mov	r0, #52	; 0x34
 2023a90:	e3a01002 	mov	r1, #2
 2023a94:	eb000493 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5420_GPIO_B35, S5P_GPIO_FUNC(0x2));
 2023a98:	e3a00035 	mov	r0, #53	; 0x35
 2023a9c:	ea000197 	b	2024100 <exynos_pinmux_config+0x930>
		break;
	case PERIPH_ID_I2C9:
		gpio_cfg_pin(EXYNOS5420_GPIO_B36, S5P_GPIO_FUNC(0x2));
 2023aa0:	e3a00036 	mov	r0, #54	; 0x36
 2023aa4:	e3a01002 	mov	r1, #2
 2023aa8:	eb00048e 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5420_GPIO_B37, S5P_GPIO_FUNC(0x2));
 2023aac:	e3a00037 	mov	r0, #55	; 0x37
 2023ab0:	ea000192 	b	2024100 <exynos_pinmux_config+0x930>
		break;
	case PERIPH_ID_I2C10:
		gpio_cfg_pin(EXYNOS5420_GPIO_B40, S5P_GPIO_FUNC(0x2));
 2023ab4:	e3a00038 	mov	r0, #56	; 0x38
 2023ab8:	e3a01002 	mov	r1, #2
 2023abc:	eb000489 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5420_GPIO_B41, S5P_GPIO_FUNC(0x2));
 2023ac0:	e3a00039 	mov	r0, #57	; 0x39
 2023ac4:	ea00018d 	b	2024100 <exynos_pinmux_config+0x930>
int exynos_pinmux_config(int peripheral, int flags)
{
	if (cpu_is_exynos5()) {
		if (proid_is_exynos5420() || proid_is_exynos5800())
			return exynos5420_pinmux_config(peripheral, flags);
		else if (proid_is_exynos5250())
 2023ac8:	e3053250 	movw	r3, #21072	; 0x5250
 2023acc:	e1520003 	cmp	r2, r3
 2023ad0:	1a0001e5 	bne	202426c <exynos_pinmux_config+0xa9c>
	}
}

static int exynos5_pinmux_config(int peripheral, int flags)
{
	switch (peripheral) {
 2023ad4:	e350004e 	cmp	r0, #78	; 0x4e
 2023ad8:	ca00000d 	bgt	2023b14 <exynos_pinmux_config+0x344>
 2023adc:	e350004b 	cmp	r0, #75	; 0x4b
 2023ae0:	aa00002f 	bge	2023ba4 <exynos_pinmux_config+0x3d4>
 2023ae4:	e350003f 	cmp	r0, #63	; 0x3f
 2023ae8:	ca000005 	bgt	2023b04 <exynos_pinmux_config+0x334>
 2023aec:	e3500038 	cmp	r0, #56	; 0x38
 2023af0:	aa0000a0 	bge	2023d78 <exynos_pinmux_config+0x5a8>
 2023af4:	e2403033 	sub	r3, r0, #51	; 0x33
 2023af8:	e3530003 	cmp	r3, #3
 2023afc:	8a0001da 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023b00:	ea00000f 	b	2023b44 <exynos_pinmux_config+0x374>
 2023b04:	e2403044 	sub	r3, r0, #68	; 0x44
 2023b08:	e3530002 	cmp	r3, #2
 2023b0c:	8a0001d6 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023b10:	ea0000d6 	b	2023e70 <exynos_pinmux_config+0x6a0>
 2023b14:	e3500080 	cmp	r0, #128	; 0x80
 2023b18:	0a000068 	beq	2023cc0 <exynos_pinmux_config+0x4f0>
 2023b1c:	ca000003 	bgt	2023b30 <exynos_pinmux_config+0x360>
 2023b20:	e2403062 	sub	r3, r0, #98	; 0x62
 2023b24:	e3530001 	cmp	r3, #1
 2023b28:	8a0001cf 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023b2c:	ea0000bc 	b	2023e24 <exynos_pinmux_config+0x654>
 2023b30:	e3500082 	cmp	r0, #130	; 0x82
 2023b34:	da0000cd 	ble	2023e70 <exynos_pinmux_config+0x6a0>
 2023b38:	e3500089 	cmp	r0, #137	; 0x89
 2023b3c:	1a0001ca 	bne	202426c <exynos_pinmux_config+0xa9c>
 2023b40:	ea0000cd 	b	2023e7c <exynos_pinmux_config+0x6ac>

static void exynos5_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023b44:	e3500035 	cmp	r0, #53	; 0x35
		start = EXYNOS5_GPIO_D00;
		count = 4;
		break;
	case PERIPH_ID_UART2:
		start = EXYNOS5_GPIO_A10;
		count = 4;
 2023b48:	03a05004 	moveq	r5, #4
	case PERIPH_ID_UART1:
		start = EXYNOS5_GPIO_D00;
		count = 4;
		break;
	case PERIPH_ID_UART2:
		start = EXYNOS5_GPIO_A10;
 2023b4c:	03a04008 	moveq	r4, #8

static void exynos5_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023b50:	0a000007 	beq	2023b74 <exynos_pinmux_config+0x3a4>
 2023b54:	e3540036 	cmp	r4, #54	; 0x36
		start = EXYNOS5_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS5_GPIO_A14;
		count = 2;
 2023b58:	03a05002 	moveq	r5, #2
	case PERIPH_ID_UART2:
		start = EXYNOS5_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS5_GPIO_A14;
 2023b5c:	03a0400c 	moveq	r4, #12

static void exynos5_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023b60:	0a000003 	beq	2023b74 <exynos_pinmux_config+0x3a4>
	case PERIPH_ID_UART0:
		start = EXYNOS5_GPIO_A00;
		count = 4;
 2023b64:	e3540034 	cmp	r4, #52	; 0x34
 2023b68:	e3a05004 	mov	r5, #4
 2023b6c:	03a04058 	moveq	r4, #88	; 0x58
 2023b70:	13a04000 	movne	r4, #0
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}
	for (i = start; i < start + count; i++) {
 2023b74:	e0855004 	add	r5, r5, r4
 2023b78:	ea000006 	b	2023b98 <exynos_pinmux_config+0x3c8>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2023b7c:	e1a00004 	mov	r0, r4
 2023b80:	e3a01000 	mov	r1, #0
 2023b84:	eb000439 	bl	2024c70 <gpio_set_pull>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 2023b88:	e1a00004 	mov	r0, r4
 2023b8c:	e3a01002 	mov	r1, #2
 2023b90:	eb000454 	bl	2024ce8 <gpio_cfg_pin>
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}
	for (i = start; i < start + count; i++) {
 2023b94:	e2844001 	add	r4, r4, #1
 2023b98:	e1540005 	cmp	r4, r5
 2023b9c:	bafffff6 	blt	2023b7c <exynos_pinmux_config+0x3ac>
 2023ba0:	ea0001af 	b	2024264 <exynos_pinmux_config+0xa94>

static int exynos5_mmc_config(int peripheral, int flags)
{
	int i, start, start_ext, gpio_func = 0;

	switch (peripheral) {
 2023ba4:	e350004d 	cmp	r0, #77	; 0x4d
		start_ext = 0;
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS5_GPIO_C30;
		start_ext = EXYNOS5_GPIO_C43;
		gpio_func = S5P_GPIO_FUNC(0x3);
 2023ba8:	03a06003 	moveq	r6, #3
		start = EXYNOS5_GPIO_C20;
		start_ext = 0;
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS5_GPIO_C30;
		start_ext = EXYNOS5_GPIO_C43;
 2023bac:	03a030a3 	moveq	r3, #163	; 0xa3
	case PERIPH_ID_SDMMC1:
		start = EXYNOS5_GPIO_C20;
		start_ext = 0;
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS5_GPIO_C30;
 2023bb0:	03a04050 	moveq	r4, #80	; 0x50

static int exynos5_mmc_config(int peripheral, int flags)
{
	int i, start, start_ext, gpio_func = 0;

	switch (peripheral) {
 2023bb4:	0a00000b 	beq	2023be8 <exynos_pinmux_config+0x418>
 2023bb8:	e354004e 	cmp	r4, #78	; 0x4e
	}
}

static int exynos5_mmc_config(int peripheral, int flags)
{
	int i, start, start_ext, gpio_func = 0;
 2023bbc:	03a06000 	moveq	r6, #0
		start_ext = EXYNOS5_GPIO_C43;
		gpio_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC3:
		start = EXYNOS5_GPIO_C40;
		start_ext = 0;
 2023bc0:	01a03006 	moveq	r3, r6
		start = EXYNOS5_GPIO_C30;
		start_ext = EXYNOS5_GPIO_C43;
		gpio_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC3:
		start = EXYNOS5_GPIO_C40;
 2023bc4:	03a040a0 	moveq	r4, #160	; 0xa0

static int exynos5_mmc_config(int peripheral, int flags)
{
	int i, start, start_ext, gpio_func = 0;

	switch (peripheral) {
 2023bc8:	0a000006 	beq	2023be8 <exynos_pinmux_config+0x418>
 2023bcc:	e354004c 	cmp	r4, #76	; 0x4c
	case PERIPH_ID_SDMMC0:
		start = EXYNOS5_GPIO_C00;
		start_ext = EXYNOS5_GPIO_C10;
		gpio_func = S5P_GPIO_FUNC(0x2);
 2023bd0:	13a06002 	movne	r6, #2
	int i, start, start_ext, gpio_func = 0;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS5_GPIO_C00;
		start_ext = EXYNOS5_GPIO_C10;
 2023bd4:	13a03040 	movne	r3, #64	; 0x40
{
	int i, start, start_ext, gpio_func = 0;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS5_GPIO_C00;
 2023bd8:	13a04038 	movne	r4, #56	; 0x38
	}
}

static int exynos5_mmc_config(int peripheral, int flags)
{
	int i, start, start_ext, gpio_func = 0;
 2023bdc:	03a06000 	moveq	r6, #0
		start_ext = EXYNOS5_GPIO_C10;
		gpio_func = S5P_GPIO_FUNC(0x2);
		break;
	case PERIPH_ID_SDMMC1:
		start = EXYNOS5_GPIO_C20;
		start_ext = 0;
 2023be0:	01a03006 	moveq	r3, r6
		start = EXYNOS5_GPIO_C00;
		start_ext = EXYNOS5_GPIO_C10;
		gpio_func = S5P_GPIO_FUNC(0x2);
		break;
	case PERIPH_ID_SDMMC1:
		start = EXYNOS5_GPIO_C20;
 2023be4:	03a04048 	moveq	r4, #72	; 0x48
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return -1;
	}
	if ((flags & PINMUX_FLAG_8BIT_MODE) && !start_ext) {
 2023be8:	e2055001 	and	r5, r5, #1
 2023bec:	e3530000 	cmp	r3, #0
 2023bf0:	13a02000 	movne	r2, #0
 2023bf4:	02052001 	andeq	r2, r5, #1
 2023bf8:	e3520000 	cmp	r2, #0
 2023bfc:	1a00019a 	bne	202426c <exynos_pinmux_config+0xa9c>
		debug("SDMMC device %d does not support 8bit mode",
				peripheral);
		return -1;
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2023c00:	e3550000 	cmp	r5, #0
 2023c04:	11a05003 	movne	r5, r3
		for (i = start_ext; i <= (start_ext + 3); i++) {
 2023c08:	12857003 	addne	r7, r5, #3
	if ((flags & PINMUX_FLAG_8BIT_MODE) && !start_ext) {
		debug("SDMMC device %d does not support 8bit mode",
				peripheral);
		return -1;
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2023c0c:	1a00000c 	bne	2023c44 <exynos_pinmux_config+0x474>
 2023c10:	e1a05004 	mov	r5, r4
			gpio_cfg_pin(i, gpio_func);
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
		}
	}
	for (i = start; i < (start + 2); i++) {
 2023c14:	e2846001 	add	r6, r4, #1
 2023c18:	ea000016 	b	2023c78 <exynos_pinmux_config+0x4a8>
				peripheral);
		return -1;
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
		for (i = start_ext; i <= (start_ext + 3); i++) {
			gpio_cfg_pin(i, gpio_func);
 2023c1c:	e1a00005 	mov	r0, r5
 2023c20:	e1a01006 	mov	r1, r6
 2023c24:	eb00042f 	bl	2024ce8 <gpio_cfg_pin>
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
 2023c28:	e1a00005 	mov	r0, r5
 2023c2c:	e3a01003 	mov	r1, #3
 2023c30:	eb00040e 	bl	2024c70 <gpio_set_pull>
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2023c34:	e1a00005 	mov	r0, r5
 2023c38:	e3a01003 	mov	r1, #3
 2023c3c:	eb00041b 	bl	2024cb0 <gpio_set_drv>
		debug("SDMMC device %d does not support 8bit mode",
				peripheral);
		return -1;
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
		for (i = start_ext; i <= (start_ext + 3); i++) {
 2023c40:	e2855001 	add	r5, r5, #1
 2023c44:	e1550007 	cmp	r5, r7
 2023c48:	dafffff3 	ble	2023c1c <exynos_pinmux_config+0x44c>
 2023c4c:	eaffffef 	b	2023c10 <exynos_pinmux_config+0x440>
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
		}
	}
	for (i = start; i < (start + 2); i++) {
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 2023c50:	e1a00005 	mov	r0, r5
 2023c54:	e3a01002 	mov	r1, #2
 2023c58:	eb000422 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2023c5c:	e1a00005 	mov	r0, r5
 2023c60:	e3a01000 	mov	r1, #0
 2023c64:	eb000401 	bl	2024c70 <gpio_set_pull>
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2023c68:	e1a00005 	mov	r0, r5
 2023c6c:	e3a01003 	mov	r1, #3
 2023c70:	eb00040e 	bl	2024cb0 <gpio_set_drv>
			gpio_cfg_pin(i, gpio_func);
			gpio_set_pull(i, S5P_GPIO_PULL_UP);
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
		}
	}
	for (i = start; i < (start + 2); i++) {
 2023c74:	e2855001 	add	r5, r5, #1
 2023c78:	e1560005 	cmp	r6, r5
 2023c7c:	aafffff3 	bge	2023c50 <exynos_pinmux_config+0x480>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	for (i = (start + 3); i <= (start + 6); i++) {
 2023c80:	e2845003 	add	r5, r4, #3
 2023c84:	e2844006 	add	r4, r4, #6
 2023c88:	ea000009 	b	2023cb4 <exynos_pinmux_config+0x4e4>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 2023c8c:	e1a00005 	mov	r0, r5
 2023c90:	e3a01002 	mov	r1, #2
 2023c94:	eb000413 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(i, S5P_GPIO_PULL_UP);
 2023c98:	e1a00005 	mov	r0, r5
 2023c9c:	e3a01003 	mov	r1, #3
 2023ca0:	eb0003f2 	bl	2024c70 <gpio_set_pull>
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2023ca4:	e1a00005 	mov	r0, r5
 2023ca8:	e3a01003 	mov	r1, #3
 2023cac:	eb0003ff 	bl	2024cb0 <gpio_set_drv>
	for (i = start; i < (start + 2); i++) {
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	for (i = (start + 3); i <= (start + 6); i++) {
 2023cb0:	e2855001 	add	r5, r5, #1
 2023cb4:	e1550004 	cmp	r5, r4
 2023cb8:	dafffff3 	ble	2023c8c <exynos_pinmux_config+0x4bc>
 2023cbc:	ea000168 	b	2024264 <exynos_pinmux_config+0xa94>
	 * GPY1[0]	EBI_BEn[0](2)
	 * GPY1[1]	EBI_BEn[1](2)
	 * GPY1[2]	SROM_WAIT(2)
	 * GPY1[3]	EBI_DATA_RDn(2)
	 */
	gpio_cfg_pin(EXYNOS5_GPIO_Y00 + (flags & PINMUX_FLAG_BANK),
 2023cc0:	e2010003 	and	r0, r1, #3
 2023cc4:	e2800068 	add	r0, r0, #104	; 0x68
 2023cc8:	e3a01002 	mov	r1, #2
 2023ccc:	eb000405 	bl	2024ce8 <gpio_cfg_pin>
		     S5P_GPIO_FUNC(2));
	gpio_cfg_pin(EXYNOS5_GPIO_Y04, S5P_GPIO_FUNC(2));
 2023cd0:	e3a0006c 	mov	r0, #108	; 0x6c
 2023cd4:	e3a01002 	mov	r1, #2
 2023cd8:	eb000402 	bl	2024ce8 <gpio_cfg_pin>
	gpio_cfg_pin(EXYNOS5_GPIO_Y05, S5P_GPIO_FUNC(2));
 2023cdc:	e3a0006d 	mov	r0, #109	; 0x6d
 2023ce0:	e3a01002 	mov	r1, #2
 2023ce4:	eb0003ff 	bl	2024ce8 <gpio_cfg_pin>

	for (i = 0; i < 4; i++)
		gpio_cfg_pin(EXYNOS5_GPIO_Y10 + i, S5P_GPIO_FUNC(2));
 2023ce8:	e3a00070 	mov	r0, #112	; 0x70
 2023cec:	e3a01002 	mov	r1, #2
 2023cf0:	eb0003fc 	bl	2024ce8 <gpio_cfg_pin>
 2023cf4:	e3a00071 	mov	r0, #113	; 0x71
 2023cf8:	e3a01002 	mov	r1, #2
 2023cfc:	eb0003f9 	bl	2024ce8 <gpio_cfg_pin>
 2023d00:	e3a00072 	mov	r0, #114	; 0x72
 2023d04:	e3a01002 	mov	r1, #2
 2023d08:	eb0003f6 	bl	2024ce8 <gpio_cfg_pin>
 2023d0c:	e3a00073 	mov	r0, #115	; 0x73
 2023d10:	e3a01002 	mov	r1, #2
 2023d14:	eb0003f3 	bl	2024ce8 <gpio_cfg_pin>
	 * GPY6[5]	EBI_DATA[13](2)
	 * GPY6[6]	EBI_DATA[14](2)
	 * GPY6[7]	EBI_DATA[15](2)
	 */
	for (i = 0; i < 8; i++) {
		gpio_cfg_pin(EXYNOS5_GPIO_Y30 + i, S5P_GPIO_FUNC(2));
 2023d18:	e1a00004 	mov	r0, r4
 2023d1c:	e3a01002 	mov	r1, #2
 2023d20:	eb0003f0 	bl	2024ce8 <gpio_cfg_pin>
	}

	return 0;
}

int exynos_pinmux_config(int peripheral, int flags)
 2023d24:	e2845010 	add	r5, r4, #16
	 * GPY6[6]	EBI_DATA[14](2)
	 * GPY6[7]	EBI_DATA[15](2)
	 */
	for (i = 0; i < 8; i++) {
		gpio_cfg_pin(EXYNOS5_GPIO_Y30 + i, S5P_GPIO_FUNC(2));
		gpio_set_pull(EXYNOS5_GPIO_Y30 + i, S5P_GPIO_PULL_UP);
 2023d28:	e1a00004 	mov	r0, r4
 2023d2c:	e3a01003 	mov	r1, #3
 2023d30:	eb0003ce 	bl	2024c70 <gpio_set_pull>

		gpio_cfg_pin(EXYNOS5_GPIO_Y50 + i, S5P_GPIO_FUNC(2));
 2023d34:	e1a00005 	mov	r0, r5
 2023d38:	e3a01002 	mov	r1, #2
 2023d3c:	eb0003e9 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(EXYNOS5_GPIO_Y50 + i, S5P_GPIO_PULL_UP);
 2023d40:	e1a00005 	mov	r0, r5
 2023d44:	e3a01003 	mov	r1, #3
	}

	return 0;
}

int exynos_pinmux_config(int peripheral, int flags)
 2023d48:	e2845018 	add	r5, r4, #24
	for (i = 0; i < 8; i++) {
		gpio_cfg_pin(EXYNOS5_GPIO_Y30 + i, S5P_GPIO_FUNC(2));
		gpio_set_pull(EXYNOS5_GPIO_Y30 + i, S5P_GPIO_PULL_UP);

		gpio_cfg_pin(EXYNOS5_GPIO_Y50 + i, S5P_GPIO_FUNC(2));
		gpio_set_pull(EXYNOS5_GPIO_Y50 + i, S5P_GPIO_PULL_UP);
 2023d4c:	eb0003c7 	bl	2024c70 <gpio_set_pull>

		gpio_cfg_pin(EXYNOS5_GPIO_Y60 + i, S5P_GPIO_FUNC(2));
 2023d50:	e1a00005 	mov	r0, r5
 2023d54:	e3a01002 	mov	r1, #2
 2023d58:	eb0003e2 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(EXYNOS5_GPIO_Y60 + i, S5P_GPIO_PULL_UP);
 2023d5c:	e2844001 	add	r4, r4, #1
 2023d60:	e1a00005 	mov	r0, r5
 2023d64:	e3a01003 	mov	r1, #3
 2023d68:	eb0003c0 	bl	2024c70 <gpio_set_pull>
	 * GPY6[4]	EBI_DATA[12](2)
	 * GPY6[5]	EBI_DATA[13](2)
	 * GPY6[6]	EBI_DATA[14](2)
	 * GPY6[7]	EBI_DATA[15](2)
	 */
	for (i = 0; i < 8; i++) {
 2023d6c:	e3540088 	cmp	r4, #136	; 0x88
 2023d70:	1affffe8 	bne	2023d18 <exynos_pinmux_config+0x548>
 2023d74:	ea00013a 	b	2024264 <exynos_pinmux_config+0xa94>
static void exynos5_i2c_config(int peripheral, int flags)
{
	int func01, func23;

	 /* High-Speed I2C */
	if (flags & PINMUX_FLAG_HS_MODE) {
 2023d78:	e3110002 	tst	r1, #2
		func01 = 4;
		func23 = 4;
 2023d7c:	13a05004 	movne	r5, #4
	} else {
		func01 = 2;
		func23 = 3;
	}

	switch (peripheral) {
 2023d80:	e2404039 	sub	r4, r0, #57	; 0x39
{
	int func01, func23;

	 /* High-Speed I2C */
	if (flags & PINMUX_FLAG_HS_MODE) {
		func01 = 4;
 2023d84:	11a06005 	movne	r6, r5
		func23 = 4;
	} else {
		func01 = 2;
		func23 = 3;
 2023d88:	03a05003 	moveq	r5, #3
	 /* High-Speed I2C */
	if (flags & PINMUX_FLAG_HS_MODE) {
		func01 = 4;
		func23 = 4;
	} else {
		func01 = 2;
 2023d8c:	03a06002 	moveq	r6, #2
		func23 = 3;
	}

	switch (peripheral) {
 2023d90:	e3540006 	cmp	r4, #6
 2023d94:	979ff104 	ldrls	pc, [pc, r4, lsl #2]
 2023d98:	ea000006 	b	2023db8 <exynos_pinmux_config+0x5e8>
 2023d9c:	02023dcc 	.word	0x02023dcc
 2023da0:	02023de4 	.word	0x02023de4
 2023da4:	02023df8 	.word	0x02023df8
 2023da8:	02023e10 	.word	0x02023e10
 2023dac:	02024130 	.word	0x02024130
 2023db0:	02024158 	.word	0x02024158
 2023db4:	02024170 	.word	0x02024170
	case PERIPH_ID_I2C0:
		gpio_cfg_pin(EXYNOS5_GPIO_B30, S5P_GPIO_FUNC(func01));
 2023db8:	e3a00030 	mov	r0, #48	; 0x30
 2023dbc:	e1a01006 	mov	r1, r6
 2023dc0:	eb0003c8 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5_GPIO_B31, S5P_GPIO_FUNC(func01));
 2023dc4:	e3a00031 	mov	r0, #49	; 0x31
 2023dc8:	ea000003 	b	2023ddc <exynos_pinmux_config+0x60c>
		break;
	case PERIPH_ID_I2C1:
		gpio_cfg_pin(EXYNOS5_GPIO_B32, S5P_GPIO_FUNC(func01));
 2023dcc:	e3a00032 	mov	r0, #50	; 0x32
 2023dd0:	e1a01006 	mov	r1, r6
 2023dd4:	eb0003c3 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5_GPIO_B33, S5P_GPIO_FUNC(func01));
 2023dd8:	e3a00033 	mov	r0, #51	; 0x33
 2023ddc:	e1a01006 	mov	r1, r6
 2023de0:	ea0000e7 	b	2024184 <exynos_pinmux_config+0x9b4>
		break;
	case PERIPH_ID_I2C2:
		gpio_cfg_pin(EXYNOS5_GPIO_A06, S5P_GPIO_FUNC(func23));
 2023de4:	e3a00006 	mov	r0, #6
 2023de8:	e1a01005 	mov	r1, r5
 2023dec:	eb0003bd 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5_GPIO_A07, S5P_GPIO_FUNC(func23));
 2023df0:	e3a00007 	mov	r0, #7
 2023df4:	ea000003 	b	2023e08 <exynos_pinmux_config+0x638>
		break;
	case PERIPH_ID_I2C3:
		gpio_cfg_pin(EXYNOS5_GPIO_A12, S5P_GPIO_FUNC(func23));
 2023df8:	e3a0000a 	mov	r0, #10
 2023dfc:	e1a01005 	mov	r1, r5
 2023e00:	eb0003b8 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5_GPIO_A13, S5P_GPIO_FUNC(func23));
 2023e04:	e3a0000b 	mov	r0, #11
 2023e08:	e1a01005 	mov	r1, r5
 2023e0c:	ea0000dc 	b	2024184 <exynos_pinmux_config+0x9b4>
		break;
	case PERIPH_ID_I2C4:
		gpio_cfg_pin(EXYNOS5_GPIO_A20, S5P_GPIO_FUNC(0x3));
 2023e10:	e3a00010 	mov	r0, #16
 2023e14:	e3a01003 	mov	r1, #3
 2023e18:	eb0003b2 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS5_GPIO_A21, S5P_GPIO_FUNC(0x3));
 2023e1c:	e3a00011 	mov	r0, #17
 2023e20:	ea0000d6 	b	2024180 <exynos_pinmux_config+0x9b0>

static void exynos5_i2s_config(int peripheral)
{
	int i;

	switch (peripheral) {
 2023e24:	e3500063 	cmp	r0, #99	; 0x63
 2023e28:	0a000008 	beq	2023e50 <exynos_pinmux_config+0x680>
 2023e2c:	e3a04f4e 	mov	r4, #312	; 0x138
	case PERIPH_ID_I2S0:
		for (i = 0; i < 5; i++)
 2023e30:	e300513d 	movw	r5, #317	; 0x13d
			gpio_cfg_pin(EXYNOS5_GPIO_Z0 + i, S5P_GPIO_FUNC(0x02));
 2023e34:	e1a00004 	mov	r0, r4
 2023e38:	e3a01002 	mov	r1, #2
 2023e3c:	e2844001 	add	r4, r4, #1
 2023e40:	eb0003a8 	bl	2024ce8 <gpio_cfg_pin>
{
	int i;

	switch (peripheral) {
	case PERIPH_ID_I2S0:
		for (i = 0; i < 5; i++)
 2023e44:	e1540005 	cmp	r4, r5
 2023e48:	1afffff9 	bne	2023e34 <exynos_pinmux_config+0x664>
 2023e4c:	ea000104 	b	2024264 <exynos_pinmux_config+0xa94>

static void exynos5_i2s_config(int peripheral)
{
	int i;

	switch (peripheral) {
 2023e50:	e3a04018 	mov	r4, #24
		for (i = 0; i < 5; i++)
			gpio_cfg_pin(EXYNOS5_GPIO_Z0 + i, S5P_GPIO_FUNC(0x02));
		break;
	case PERIPH_ID_I2S1:
		for (i = 0; i < 5; i++)
			gpio_cfg_pin(EXYNOS5_GPIO_B00 + i, S5P_GPIO_FUNC(0x02));
 2023e54:	e1a00004 	mov	r0, r4
 2023e58:	e3a01002 	mov	r1, #2
 2023e5c:	e2844001 	add	r4, r4, #1
 2023e60:	eb0003a0 	bl	2024ce8 <gpio_cfg_pin>
	case PERIPH_ID_I2S0:
		for (i = 0; i < 5; i++)
			gpio_cfg_pin(EXYNOS5_GPIO_Z0 + i, S5P_GPIO_FUNC(0x02));
		break;
	case PERIPH_ID_I2S1:
		for (i = 0; i < 5; i++)
 2023e64:	e354001d 	cmp	r4, #29
 2023e68:	1afffff9 	bne	2023e54 <exynos_pinmux_config+0x684>
 2023e6c:	ea0000fc 	b	2024264 <exynos_pinmux_config+0xa94>
	case PERIPH_ID_SPI0:
	case PERIPH_ID_SPI1:
	case PERIPH_ID_SPI2:
	case PERIPH_ID_SPI3:
	case PERIPH_ID_SPI4:
		exynos5_spi_config(peripheral);
 2023e70:	e1a00004 	mov	r0, r4
 2023e74:	ebfffdf7 	bl	2023658 <exynos5_spi_config>
 2023e78:	ea0000f9 	b	2024264 <exynos_pinmux_config+0xa94>
		break;
	case PERIPH_ID_DPHPD:
		/* Set Hotplug detect for DP */
		gpio_cfg_pin(EXYNOS5_GPIO_X07, S5P_GPIO_FUNC(0x3));
 2023e7c:	e3a000af 	mov	r0, #175	; 0xaf
 2023e80:	e3a01003 	mov	r1, #3
 2023e84:	eb000397 	bl	2024ce8 <gpio_cfg_pin>

		/*
		 * Hotplug detect should have an external pullup; disable the
		 * internal pulldown so they don't fight.
		 */
		gpio_set_pull(EXYNOS5_GPIO_X07, S5P_GPIO_PULL_NONE);
 2023e88:	e3a000af 	mov	r0, #175	; 0xaf
 2023e8c:	e3a01000 	mov	r1, #0
 2023e90:	eb000376 	bl	2024c70 <gpio_set_pull>
 2023e94:	ea0000f2 	b	2024264 <exynos_pinmux_config+0xa94>
	if (cpu_is_exynos5()) {
		if (proid_is_exynos5420() || proid_is_exynos5800())
			return exynos5420_pinmux_config(peripheral, flags);
		else if (proid_is_exynos5250())
			return exynos5_pinmux_config(peripheral, flags);
	} else if (cpu_is_exynos4()) {
 2023e98:	e3530004 	cmp	r3, #4
 2023e9c:	1a0000f4 	bne	2024274 <exynos_pinmux_config+0xaa4>
		if (proid_is_exynos4412())
 2023ea0:	e3041412 	movw	r1, #17426	; 0x4412
 2023ea4:	e1520001 	cmp	r2, r1
 2023ea8:	1a00005b 	bne	202401c <exynos_pinmux_config+0x84c>
	return 0;
}

static int exynos4x12_pinmux_config(int peripheral, int flags)
{
	switch (peripheral) {
 2023eac:	e350003f 	cmp	r0, #63	; 0x3f
 2023eb0:	ca000005 	bgt	2023ecc <exynos_pinmux_config+0x6fc>
 2023eb4:	e3500038 	cmp	r0, #56	; 0x38
 2023eb8:	aa00007c 	bge	20240b0 <exynos_pinmux_config+0x8e0>
 2023ebc:	e2402033 	sub	r2, r0, #51	; 0x33
 2023ec0:	e3520003 	cmp	r2, #3
 2023ec4:	8a0000e8 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2023ec8:	ea000006 	b	2023ee8 <exynos_pinmux_config+0x718>
 2023ecc:	e350004d 	cmp	r0, #77	; 0x4d
 2023ed0:	0a00002a 	beq	2023f80 <exynos_pinmux_config+0x7b0>
 2023ed4:	e3500083 	cmp	r0, #131	; 0x83
 2023ed8:	0a000018 	beq	2023f40 <exynos_pinmux_config+0x770>
 2023edc:	e350004b 	cmp	r0, #75	; 0x4b
 2023ee0:	1a0000e1 	bne	202426c <exynos_pinmux_config+0xa9c>
 2023ee4:	ea000015 	b	2023f40 <exynos_pinmux_config+0x770>

static void exynos4x12_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023ee8:	e3500035 	cmp	r0, #53	; 0x35
	case PERIPH_ID_UART1:
		start = EXYNOS4X12_GPIO_A04;
		count = 4;
		break;
	case PERIPH_ID_UART2:
		start = EXYNOS4X12_GPIO_A10;
 2023eec:	03a04008 	moveq	r4, #8

static void exynos4x12_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023ef0:	0a000006 	beq	2023f10 <exynos_pinmux_config+0x740>
 2023ef4:	e3540036 	cmp	r4, #54	; 0x36
		start = EXYNOS4X12_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS4X12_GPIO_A14;
		count = 2;
 2023ef8:	03a03002 	moveq	r3, #2
	case PERIPH_ID_UART2:
		start = EXYNOS4X12_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS4X12_GPIO_A14;
 2023efc:	03a0400c 	moveq	r4, #12

static void exynos4x12_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2023f00:	0a000002 	beq	2023f10 <exynos_pinmux_config+0x740>
 2023f04:	e3540034 	cmp	r4, #52	; 0x34
	case PERIPH_ID_UART0:
		start = EXYNOS4X12_GPIO_A00;
 2023f08:	13a04000 	movne	r4, #0
		count = 4;
		break;
	case PERIPH_ID_UART1:
		start = EXYNOS4X12_GPIO_A04;
 2023f0c:	01a04003 	moveq	r4, r3
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}
	for (i = start; i < (start + count); i++) {
 2023f10:	e0835004 	add	r5, r3, r4
 2023f14:	ea000006 	b	2023f34 <exynos_pinmux_config+0x764>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2023f18:	e1a00004 	mov	r0, r4
 2023f1c:	e3a01000 	mov	r1, #0
 2023f20:	eb000352 	bl	2024c70 <gpio_set_pull>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 2023f24:	e1a00004 	mov	r0, r4
 2023f28:	e3a01002 	mov	r1, #2
 2023f2c:	eb00036d 	bl	2024ce8 <gpio_cfg_pin>
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}
	for (i = start; i < (start + count); i++) {
 2023f30:	e2844001 	add	r4, r4, #1
 2023f34:	e1540005 	cmp	r4, r5
 2023f38:	bafffff6 	blt	2023f18 <exynos_pinmux_config+0x748>
 2023f3c:	ea0000c8 	b	2024264 <exynos_pinmux_config+0xa94>
static int exynos4x12_mmc_config(int peripheral, int flags)
{
	int i, start = 0, start_ext = 0;
	unsigned int func, ext_func;

	switch (peripheral) {
 2023f40:	e354004d 	cmp	r4, #77	; 0x4d
 2023f44:	0a00000d 	beq	2023f80 <exynos_pinmux_config+0x7b0>
 2023f48:	e3540083 	cmp	r4, #131	; 0x83
 2023f4c:	0a000006 	beq	2023f6c <exynos_pinmux_config+0x79c>
 2023f50:	e354004b 	cmp	r4, #75	; 0x4b
 2023f54:	1a0000c4 	bne	202426c <exynos_pinmux_config+0xa9c>
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4X12_GPIO_K00;
		start_ext = EXYNOS4X12_GPIO_K13;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
 2023f58:	e3a07003 	mov	r7, #3

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4X12_GPIO_K00;
		start_ext = EXYNOS4X12_GPIO_K13;
		func = S5P_GPIO_FUNC(0x2);
 2023f5c:	e3a08002 	mov	r8, #2
	unsigned int func, ext_func;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4X12_GPIO_K00;
		start_ext = EXYNOS4X12_GPIO_K13;
 2023f60:	e3a06073 	mov	r6, #115	; 0x73
	int i, start = 0, start_ext = 0;
	unsigned int func, ext_func;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4X12_GPIO_K00;
 2023f64:	e284401d 	add	r4, r4, #29
 2023f68:	ea000008 	b	2023f90 <exynos_pinmux_config+0x7c0>
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4X12_GPIO_K00;
		start_ext = EXYNOS4X12_GPIO_K13;
		func = S5P_GPIO_FUNC(0x3);
		ext_func = S5P_GPIO_FUNC(0x4);
 2023f6c:	e3a07004 	mov	r7, #4
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4X12_GPIO_K00;
		start_ext = EXYNOS4X12_GPIO_K13;
		func = S5P_GPIO_FUNC(0x3);
 2023f70:	e3a08003 	mov	r8, #3
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4X12_GPIO_K00;
		start_ext = EXYNOS4X12_GPIO_K13;
 2023f74:	e3a06073 	mov	r6, #115	; 0x73
		start_ext = EXYNOS4X12_GPIO_K33;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4X12_GPIO_K00;
 2023f78:	e3a04068 	mov	r4, #104	; 0x68
 2023f7c:	ea000003 	b	2023f90 <exynos_pinmux_config+0x7c0>
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4X12_GPIO_K20;
		start_ext = EXYNOS4X12_GPIO_K33;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
 2023f80:	e3a07003 	mov	r7, #3
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4X12_GPIO_K20;
		start_ext = EXYNOS4X12_GPIO_K33;
		func = S5P_GPIO_FUNC(0x2);
 2023f84:	e3a08002 	mov	r8, #2
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4X12_GPIO_K20;
		start_ext = EXYNOS4X12_GPIO_K33;
 2023f88:	e3a06083 	mov	r6, #131	; 0x83
		start_ext = EXYNOS4X12_GPIO_K13;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4X12_GPIO_K20;
 2023f8c:	e3a04078 	mov	r4, #120	; 0x78
		ext_func = S5P_GPIO_FUNC(0x4);
		break;
	default:
		return -1;
	}
	for (i = start; i < (start + 7); i++) {
 2023f90:	e284b006 	add	fp, r4, #6
		if (i == (start + 2))
 2023f94:	e284a002 	add	sl, r4, #2
 2023f98:	ea00000b 	b	2023fcc <exynos_pinmux_config+0x7fc>
 2023f9c:	e154000a 	cmp	r4, sl
 2023fa0:	0a000008 	beq	2023fc8 <exynos_pinmux_config+0x7f8>
			continue;
		gpio_cfg_pin(i,  func);
 2023fa4:	e1a00004 	mov	r0, r4
 2023fa8:	e1a01008 	mov	r1, r8
 2023fac:	eb00034d 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2023fb0:	e1a00004 	mov	r0, r4
 2023fb4:	e3a01000 	mov	r1, #0
 2023fb8:	eb00032c 	bl	2024c70 <gpio_set_pull>
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2023fbc:	e1a00004 	mov	r0, r4
 2023fc0:	e3a01003 	mov	r1, #3
 2023fc4:	eb000339 	bl	2024cb0 <gpio_set_drv>
		ext_func = S5P_GPIO_FUNC(0x4);
		break;
	default:
		return -1;
	}
	for (i = start; i < (start + 7); i++) {
 2023fc8:	e2844001 	add	r4, r4, #1
 2023fcc:	e15b0004 	cmp	fp, r4
 2023fd0:	aafffff1 	bge	2023f9c <exynos_pinmux_config+0x7cc>
			continue;
		gpio_cfg_pin(i,  func);
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2023fd4:	e2150001 	ands	r0, r5, #1
 2023fd8:	11a04006 	movne	r4, r6
		for (i = start_ext; i < (start_ext + 4); i++) {
 2023fdc:	12845003 	addne	r5, r4, #3
			continue;
		gpio_cfg_pin(i,  func);
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2023fe0:	08bd8df0 	popeq	{r4, r5, r6, r7, r8, sl, fp, pc}
 2023fe4:	ea000009 	b	2024010 <exynos_pinmux_config+0x840>
		for (i = start_ext; i < (start_ext + 4); i++) {
			gpio_cfg_pin(i,  ext_func);
 2023fe8:	e1a00004 	mov	r0, r4
 2023fec:	e1a01007 	mov	r1, r7
 2023ff0:	eb00033c 	bl	2024ce8 <gpio_cfg_pin>
			gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2023ff4:	e1a00004 	mov	r0, r4
 2023ff8:	e3a01000 	mov	r1, #0
 2023ffc:	eb00031b 	bl	2024c70 <gpio_set_pull>
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2024000:	e1a00004 	mov	r0, r4
 2024004:	e3a01003 	mov	r1, #3
 2024008:	eb000328 	bl	2024cb0 <gpio_set_drv>
		gpio_cfg_pin(i,  func);
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	if (flags & PINMUX_FLAG_8BIT_MODE) {
		for (i = start_ext; i < (start_ext + 4); i++) {
 202400c:	e2844001 	add	r4, r4, #1
 2024010:	e1550004 	cmp	r5, r4
 2024014:	aafffff3 	bge	2023fe8 <exynos_pinmux_config+0x818>
 2024018:	ea000091 	b	2024264 <exynos_pinmux_config+0xa94>
	}
}

static int exynos4_pinmux_config(int peripheral, int flags)
{
	switch (peripheral) {
 202401c:	e350003f 	cmp	r0, #63	; 0x3f
 2024020:	ca000005 	bgt	202403c <exynos_pinmux_config+0x86c>
 2024024:	e3500038 	cmp	r0, #56	; 0x38
 2024028:	aa000020 	bge	20240b0 <exynos_pinmux_config+0x8e0>
 202402c:	e2402033 	sub	r2, r0, #51	; 0x33
 2024030:	e3520003 	cmp	r2, #3
 2024034:	8a00008c 	bhi	202426c <exynos_pinmux_config+0xa9c>
 2024038:	ea000006 	b	2024058 <exynos_pinmux_config+0x888>
 202403c:	e350004d 	cmp	r0, #77	; 0x4d
 2024040:	0a000061 	beq	20241cc <exynos_pinmux_config+0x9fc>
 2024044:	e3500083 	cmp	r0, #131	; 0x83
 2024048:	0a00004f 	beq	202418c <exynos_pinmux_config+0x9bc>
 202404c:	e350004b 	cmp	r0, #75	; 0x4b
 2024050:	1a000085 	bne	202426c <exynos_pinmux_config+0xa9c>
 2024054:	ea00004c 	b	202418c <exynos_pinmux_config+0x9bc>

static void exynos4_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2024058:	e3500035 	cmp	r0, #53	; 0x35
	case PERIPH_ID_UART1:
		start = EXYNOS4_GPIO_A04;
		count = 4;
		break;
	case PERIPH_ID_UART2:
		start = EXYNOS4_GPIO_A10;
 202405c:	03a04008 	moveq	r4, #8

static void exynos4_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2024060:	0a000006 	beq	2024080 <exynos_pinmux_config+0x8b0>
 2024064:	e3540036 	cmp	r4, #54	; 0x36
		start = EXYNOS4_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS4_GPIO_A14;
		count = 2;
 2024068:	03a03002 	moveq	r3, #2
	case PERIPH_ID_UART2:
		start = EXYNOS4_GPIO_A10;
		count = 4;
		break;
	case PERIPH_ID_UART3:
		start = EXYNOS4_GPIO_A14;
 202406c:	03a0400c 	moveq	r4, #12

static void exynos4_uart_config(int peripheral)
{
	int i, start, count;

	switch (peripheral) {
 2024070:	0a000002 	beq	2024080 <exynos_pinmux_config+0x8b0>
 2024074:	e3540034 	cmp	r4, #52	; 0x34
	case PERIPH_ID_UART0:
		start = EXYNOS4_GPIO_A00;
 2024078:	13a04000 	movne	r4, #0
		count = 4;
		break;
	case PERIPH_ID_UART1:
		start = EXYNOS4_GPIO_A04;
 202407c:	01a04003 	moveq	r4, r3
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}
	for (i = start; i < (start + count); i++) {
 2024080:	e0835004 	add	r5, r3, r4
 2024084:	ea000006 	b	20240a4 <exynos_pinmux_config+0x8d4>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2024088:	e1a00004 	mov	r0, r4
 202408c:	e3a01000 	mov	r1, #0
 2024090:	eb0002f6 	bl	2024c70 <gpio_set_pull>
		gpio_cfg_pin(i, S5P_GPIO_FUNC(0x2));
 2024094:	e1a00004 	mov	r0, r4
 2024098:	e3a01002 	mov	r1, #2
 202409c:	eb000311 	bl	2024ce8 <gpio_cfg_pin>
		break;
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return;
	}
	for (i = start; i < (start + count); i++) {
 20240a0:	e2844001 	add	r4, r4, #1
 20240a4:	e1540005 	cmp	r4, r5
 20240a8:	bafffff6 	blt	2024088 <exynos_pinmux_config+0x8b8>
 20240ac:	ea00006c 	b	2024264 <exynos_pinmux_config+0xa94>
	return 0;
}

static void exynos4_i2c_config(int peripheral, int flags)
{
	switch (peripheral) {
 20240b0:	e2444039 	sub	r4, r4, #57	; 0x39
 20240b4:	e3540006 	cmp	r4, #6
 20240b8:	979ff104 	ldrls	pc, [pc, r4, lsl #2]
 20240bc:	ea000006 	b	20240dc <exynos_pinmux_config+0x90c>
 20240c0:	020240f0 	.word	0x020240f0
 20240c4:	02024108 	.word	0x02024108
 20240c8:	0202411c 	.word	0x0202411c
 20240cc:	02024130 	.word	0x02024130
 20240d0:	02024144 	.word	0x02024144
 20240d4:	02024158 	.word	0x02024158
 20240d8:	02024170 	.word	0x02024170
	case PERIPH_ID_I2C0:
		gpio_cfg_pin(EXYNOS4_GPIO_D10, S5P_GPIO_FUNC(0x2));
 20240dc:	e3a00030 	mov	r0, #48	; 0x30
 20240e0:	e3a01002 	mov	r1, #2
 20240e4:	eb0002ff 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_D11, S5P_GPIO_FUNC(0x2));
 20240e8:	e3a00031 	mov	r0, #49	; 0x31
 20240ec:	ea000003 	b	2024100 <exynos_pinmux_config+0x930>
		break;
	case PERIPH_ID_I2C1:
		gpio_cfg_pin(EXYNOS4_GPIO_D12, S5P_GPIO_FUNC(0x2));
 20240f0:	e3a00032 	mov	r0, #50	; 0x32
 20240f4:	e3a01002 	mov	r1, #2
 20240f8:	eb0002fa 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_D13, S5P_GPIO_FUNC(0x2));
 20240fc:	e3a00033 	mov	r0, #51	; 0x33
 2024100:	e3a01002 	mov	r1, #2
 2024104:	ea00001e 	b	2024184 <exynos_pinmux_config+0x9b4>
		break;
	case PERIPH_ID_I2C2:
		gpio_cfg_pin(EXYNOS4_GPIO_A06, S5P_GPIO_FUNC(0x3));
 2024108:	e3a00006 	mov	r0, #6
 202410c:	e3a01003 	mov	r1, #3
 2024110:	eb0002f4 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_A07, S5P_GPIO_FUNC(0x3));
 2024114:	e3a00007 	mov	r0, #7
 2024118:	ea000018 	b	2024180 <exynos_pinmux_config+0x9b0>
		break;
	case PERIPH_ID_I2C3:
		gpio_cfg_pin(EXYNOS4_GPIO_A12, S5P_GPIO_FUNC(0x3));
 202411c:	e3a0000a 	mov	r0, #10
 2024120:	e3a01003 	mov	r1, #3
 2024124:	eb0002ef 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_A13, S5P_GPIO_FUNC(0x3));
 2024128:	e3a0000b 	mov	r0, #11
 202412c:	ea000013 	b	2024180 <exynos_pinmux_config+0x9b0>
		break;
	case PERIPH_ID_I2C4:
		gpio_cfg_pin(EXYNOS4_GPIO_B2, S5P_GPIO_FUNC(0x3));
 2024130:	e3a00012 	mov	r0, #18
 2024134:	e3a01003 	mov	r1, #3
 2024138:	eb0002ea 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_B3, S5P_GPIO_FUNC(0x3));
 202413c:	e3a00013 	mov	r0, #19
 2024140:	ea00000e 	b	2024180 <exynos_pinmux_config+0x9b0>
		break;
	case PERIPH_ID_I2C5:
		gpio_cfg_pin(EXYNOS4_GPIO_B6, S5P_GPIO_FUNC(0x3));
 2024144:	e3a00016 	mov	r0, #22
 2024148:	e3a01003 	mov	r1, #3
 202414c:	eb0002e5 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_B7, S5P_GPIO_FUNC(0x3));
 2024150:	e3a00017 	mov	r0, #23
 2024154:	ea000009 	b	2024180 <exynos_pinmux_config+0x9b0>
		break;
	case PERIPH_ID_I2C6:
		gpio_cfg_pin(EXYNOS4_GPIO_C13, S5P_GPIO_FUNC(0x4));
 2024158:	e3a00023 	mov	r0, #35	; 0x23
 202415c:	e3a01004 	mov	r1, #4
 2024160:	eb0002e0 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_C14, S5P_GPIO_FUNC(0x4));
 2024164:	e3a00024 	mov	r0, #36	; 0x24
 2024168:	e3a01004 	mov	r1, #4
 202416c:	ea000004 	b	2024184 <exynos_pinmux_config+0x9b4>
		break;
	case PERIPH_ID_I2C7:
		gpio_cfg_pin(EXYNOS4_GPIO_D02, S5P_GPIO_FUNC(0x3));
 2024170:	e3a0002a 	mov	r0, #42	; 0x2a
 2024174:	e3a01003 	mov	r1, #3
 2024178:	eb0002da 	bl	2024ce8 <gpio_cfg_pin>
		gpio_cfg_pin(EXYNOS4_GPIO_D03, S5P_GPIO_FUNC(0x3));
 202417c:	e3a0002b 	mov	r0, #43	; 0x2b
 2024180:	e3a01003 	mov	r1, #3
 2024184:	eb0002d7 	bl	2024ce8 <gpio_cfg_pin>
 2024188:	ea000035 	b	2024264 <exynos_pinmux_config+0xa94>
static int exynos4_mmc_config(int peripheral, int flags)
{
	int i, start = 0, start_ext = 0;
	unsigned int func, ext_func;

	switch (peripheral) {
 202418c:	e354004d 	cmp	r4, #77	; 0x4d
 2024190:	0a00000d 	beq	20241cc <exynos_pinmux_config+0x9fc>
 2024194:	e3540083 	cmp	r4, #131	; 0x83
 2024198:	0a000006 	beq	20241b8 <exynos_pinmux_config+0x9e8>
 202419c:	e354004b 	cmp	r4, #75	; 0x4b
 20241a0:	1a000031 	bne	202426c <exynos_pinmux_config+0xa9c>
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4_GPIO_K00;
		start_ext = EXYNOS4_GPIO_K13;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
 20241a4:	e3a07003 	mov	r7, #3

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4_GPIO_K00;
		start_ext = EXYNOS4_GPIO_K13;
		func = S5P_GPIO_FUNC(0x2);
 20241a8:	e3a08002 	mov	r8, #2
	unsigned int func, ext_func;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4_GPIO_K00;
		start_ext = EXYNOS4_GPIO_K13;
 20241ac:	e3a0609b 	mov	r6, #155	; 0x9b
	int i, start = 0, start_ext = 0;
	unsigned int func, ext_func;

	switch (peripheral) {
	case PERIPH_ID_SDMMC0:
		start = EXYNOS4_GPIO_K00;
 20241b0:	e2844045 	add	r4, r4, #69	; 0x45
 20241b4:	ea000008 	b	20241dc <exynos_pinmux_config+0xa0c>
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4_GPIO_K00;
		start_ext = EXYNOS4_GPIO_K13;
		func = S5P_GPIO_FUNC(0x3);
		ext_func = S5P_GPIO_FUNC(0x4);
 20241b8:	e3a07004 	mov	r7, #4
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4_GPIO_K00;
		start_ext = EXYNOS4_GPIO_K13;
		func = S5P_GPIO_FUNC(0x3);
 20241bc:	e3a08003 	mov	r8, #3
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4_GPIO_K00;
		start_ext = EXYNOS4_GPIO_K13;
 20241c0:	e3a0609b 	mov	r6, #155	; 0x9b
		start_ext = EXYNOS4_GPIO_K33;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC4:
		start = EXYNOS4_GPIO_K00;
 20241c4:	e3a04090 	mov	r4, #144	; 0x90
 20241c8:	ea000003 	b	20241dc <exynos_pinmux_config+0xa0c>
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4_GPIO_K20;
		start_ext = EXYNOS4_GPIO_K33;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
 20241cc:	e3a07003 	mov	r7, #3
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4_GPIO_K20;
		start_ext = EXYNOS4_GPIO_K33;
		func = S5P_GPIO_FUNC(0x2);
 20241d0:	e3a08002 	mov	r8, #2
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4_GPIO_K20;
		start_ext = EXYNOS4_GPIO_K33;
 20241d4:	e3a060ab 	mov	r6, #171	; 0xab
		start_ext = EXYNOS4_GPIO_K13;
		func = S5P_GPIO_FUNC(0x2);
		ext_func = S5P_GPIO_FUNC(0x3);
		break;
	case PERIPH_ID_SDMMC2:
		start = EXYNOS4_GPIO_K20;
 20241d8:	e3a040a0 	mov	r4, #160	; 0xa0
		ext_func = S5P_GPIO_FUNC(0x4);
		break;
	default:
		return -1;
	}
	for (i = start; i < (start + 7); i++) {
 20241dc:	e284b006 	add	fp, r4, #6
		if (i == (start + 2))
 20241e0:	e284a002 	add	sl, r4, #2
 20241e4:	ea00000b 	b	2024218 <exynos_pinmux_config+0xa48>
 20241e8:	e154000a 	cmp	r4, sl
 20241ec:	0a000008 	beq	2024214 <exynos_pinmux_config+0xa44>
			continue;
		gpio_cfg_pin(i,  func);
 20241f0:	e1a00004 	mov	r0, r4
 20241f4:	e1a01008 	mov	r1, r8
 20241f8:	eb0002ba 	bl	2024ce8 <gpio_cfg_pin>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 20241fc:	e1a00004 	mov	r0, r4
 2024200:	e3a01000 	mov	r1, #0
 2024204:	eb000299 	bl	2024c70 <gpio_set_pull>
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
 2024208:	e1a00004 	mov	r0, r4
 202420c:	e3a01003 	mov	r1, #3
 2024210:	eb0002a6 	bl	2024cb0 <gpio_set_drv>
		ext_func = S5P_GPIO_FUNC(0x4);
		break;
	default:
		return -1;
	}
	for (i = start; i < (start + 7); i++) {
 2024214:	e2844001 	add	r4, r4, #1
 2024218:	e15b0004 	cmp	fp, r4
 202421c:	aafffff1 	bge	20241e8 <exynos_pinmux_config+0xa18>
		gpio_cfg_pin(i,  func);
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	/* SDMMC2 do not use 8bit mode at exynos4 */
	if (flags & PINMUX_FLAG_8BIT_MODE) {
 2024220:	e2150001 	ands	r0, r5, #1
 2024224:	11a04006 	movne	r4, r6
		for (i = start_ext; i < (start_ext + 4); i++) {
 2024228:	12845003 	addne	r5, r4, #3
		gpio_cfg_pin(i,  func);
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	/* SDMMC2 do not use 8bit mode at exynos4 */
	if (flags & PINMUX_FLAG_8BIT_MODE) {
 202422c:	08bd8df0 	popeq	{r4, r5, r6, r7, r8, sl, fp, pc}
 2024230:	ea000009 	b	202425c <exynos_pinmux_config+0xa8c>
		for (i = start_ext; i < (start_ext + 4); i++) {
			gpio_cfg_pin(i,  ext_func);
 2024234:	e1a00004 	mov	r0, r4
 2024238:	e1a01007 	mov	r1, r7
 202423c:	eb0002a9 	bl	2024ce8 <gpio_cfg_pin>
			gpio_set_pull(i, S5P_GPIO_PULL_NONE);
 2024240:	e1a00004 	mov	r0, r4
 2024244:	e3a01000 	mov	r1, #0
 2024248:	eb000288 	bl	2024c70 <gpio_set_pull>
			gpio_set_drv(i, S5P_GPIO_DRV_4X);
 202424c:	e1a00004 	mov	r0, r4
 2024250:	e3a01003 	mov	r1, #3
 2024254:	eb000295 	bl	2024cb0 <gpio_set_drv>
		gpio_set_pull(i, S5P_GPIO_PULL_NONE);
		gpio_set_drv(i, S5P_GPIO_DRV_4X);
	}
	/* SDMMC2 do not use 8bit mode at exynos4 */
	if (flags & PINMUX_FLAG_8BIT_MODE) {
		for (i = start_ext; i < (start_ext + 4); i++) {
 2024258:	e2844001 	add	r4, r4, #1
 202425c:	e1550004 	cmp	r5, r4
 2024260:	aafffff3 	bge	2024234 <exynos_pinmux_config+0xa64>
	default:
		debug("%s: invalid peripheral %d", __func__, peripheral);
		return -1;
	}

	return 0;
 2024264:	e3a00000 	mov	r0, #0
 2024268:	e8bd8df0 	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
			return exynos4_pinmux_config(peripheral, flags);
	}

	debug("pinmux functionality not supported\n");

	return -1;
 202426c:	e3e00000 	mvn	r0, #0
 2024270:	e8bd8df0 	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
 2024274:	e3e00000 	mvn	r0, #0
}
 2024278:	e8bd8df0 	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
 202427c:	02024dc8 	.word	0x02024dc8

02024280 <tzpc_init>:
static inline int __attribute__((no_instrument_function)) cpu_is_##type(void) \
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
 2024280:	e59f30a8 	ldr	r3, [pc, #168]	; 2024330 <tzpc_init+0xb0>
#include <asm/arch/tzpc.h>
#include <asm/io.h>

/* Setting TZPC[TrustZone Protection Controller] */
void tzpc_init(void)
{
 2024284:	e92d4030 	push	{r4, r5, lr}
 2024288:	e5933000 	ldr	r3, [r3]
 202428c:	e1a02623 	lsr	r2, r3, #12
SAMSUNG_BASE(usb_otg, USBOTG_BASE)
SAMSUNG_BASE(watchdog, WATCHDOG_BASE)
SAMSUNG_BASE(power, POWER_BASE)
SAMSUNG_BASE(spi, SPI_BASE)
SAMSUNG_BASE(spi_isp, SPI_ISP_BASE)
SAMSUNG_BASE(tzpc, TZPC_BASE)
 2024290:	e3520004 	cmp	r2, #4
 2024294:	0a00000d 	beq	20242d0 <tzpc_init+0x50>
 2024298:	e3520005 	cmp	r2, #5
 202429c:	13a02000 	movne	r2, #0
	struct exynos_tzpc *tzpc;
	unsigned int addr, start = 0, end = 0;
 20242a0:	11a00002 	movne	r0, r2
 20242a4:	1a00000b 	bne	20242d8 <tzpc_init+0x58>
 20242a8:	e3052420 	movw	r2, #21536	; 0x5420
 20242ac:	e1530002 	cmp	r3, r2
 20242b0:	059f207c 	ldreq	r2, [pc, #124]	; 2024334 <tzpc_init+0xb4>
 20242b4:	0a000003 	beq	20242c8 <tzpc_init+0x48>
 20242b8:	e59f1078 	ldr	r1, [pc, #120]	; 2024338 <tzpc_init+0xb8>
 20242bc:	e3530b16 	cmp	r3, #22528	; 0x5800
 20242c0:	e59f206c 	ldr	r2, [pc, #108]	; 2024334 <tzpc_init+0xb4>
 20242c4:	11a02001 	movne	r2, r1

	start = samsung_get_base_tzpc();

	if (cpu_is_exynos5())
		end = start + ((EXYNOS5_NR_TZPC_BANKS - 1) * TZPC_BASE_OFFSET);
 20242c8:	e2820809 	add	r0, r2, #589824	; 0x90000
 20242cc:	ea000001 	b	20242d8 <tzpc_init+0x58>
 20242d0:	e59f2064 	ldr	r2, [pc, #100]	; 202433c <tzpc_init+0xbc>
	else if (cpu_is_exynos4())
		end = start + ((EXYNOS4_NR_TZPC_BANKS - 1) * TZPC_BASE_OFFSET);
 20242d4:	e59f0064 	ldr	r0, [pc, #100]	; 2024340 <tzpc_init+0xc0>

	for (addr = start; addr <= end; addr += TZPC_BASE_OFFSET) {
 20242d8:	e1a03002 	mov	r3, r2
		tzpc = (struct exynos_tzpc *)addr;

		if (addr == start)
			writel(R0SIZE, &tzpc->r0size);
 20242dc:	e3a04000 	mov	r4, #0

		writel(DECPROTXSET, &tzpc->decprot0set);
 20242e0:	e3a010ff 	mov	r1, #255	; 0xff
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
IS_SAMSUNG_TYPE(exynos5, 0x5)
 20242e4:	e59fc044 	ldr	ip, [pc, #68]	; 2024330 <tzpc_init+0xb0>
	if (cpu_is_exynos5())
		end = start + ((EXYNOS5_NR_TZPC_BANKS - 1) * TZPC_BASE_OFFSET);
	else if (cpu_is_exynos4())
		end = start + ((EXYNOS4_NR_TZPC_BANKS - 1) * TZPC_BASE_OFFSET);

	for (addr = start; addr <= end; addr += TZPC_BASE_OFFSET) {
 20242e8:	ea00000d 	b	2024324 <tzpc_init+0xa4>
		tzpc = (struct exynos_tzpc *)addr;

		if (addr == start)
 20242ec:	e1530002 	cmp	r3, r2
 20242f0:	1a000000 	bne	20242f8 <tzpc_init+0x78>
			writel(R0SIZE, &tzpc->r0size);
 20242f4:	e5834000 	str	r4, [r3]

		writel(DECPROTXSET, &tzpc->decprot0set);
 20242f8:	e5831804 	str	r1, [r3, #2052]	; 0x804
		writel(DECPROTXSET, &tzpc->decprot1set);
 20242fc:	e5831810 	str	r1, [r3, #2064]	; 0x810
 2024300:	e59c5000 	ldr	r5, [ip]
 2024304:	e1a05625 	lsr	r5, r5, #12

		if (cpu_is_exynos5() && (addr == end))
 2024308:	e3550005 	cmp	r5, #5
 202430c:	1a000001 	bne	2024318 <tzpc_init+0x98>
 2024310:	e1530000 	cmp	r3, r0
 2024314:	08bd8030 	popeq	{r4, r5, pc}
			break;

		writel(DECPROTXSET, &tzpc->decprot2set);
 2024318:	e583181c 	str	r1, [r3, #2076]	; 0x81c
		writel(DECPROTXSET, &tzpc->decprot3set);
 202431c:	e5831828 	str	r1, [r3, #2088]	; 0x828
	if (cpu_is_exynos5())
		end = start + ((EXYNOS5_NR_TZPC_BANKS - 1) * TZPC_BASE_OFFSET);
	else if (cpu_is_exynos4())
		end = start + ((EXYNOS4_NR_TZPC_BANKS - 1) * TZPC_BASE_OFFSET);

	for (addr = start; addr <= end; addr += TZPC_BASE_OFFSET) {
 2024320:	e2833801 	add	r3, r3, #65536	; 0x10000
 2024324:	e1530000 	cmp	r3, r0
 2024328:	9affffef 	bls	20242ec <tzpc_init+0x6c>
 202432c:	e8bd8030 	pop	{r4, r5, pc}
 2024330:	02024dc8 	.word	0x02024dc8
 2024334:	100e0000 	.word	0x100e0000
 2024338:	10100000 	.word	0x10100000
 202433c:	10110000 	.word	0x10110000
 2024340:	10160000 	.word	0x10160000

02024344 <phy_control_reset>:
};
#endif

static void phy_control_reset(int ctrl_no, struct exynos4_dmc *dmc)
{
	if (ctrl_no) {
 2024344:	e3500000 	cmp	r0, #0
 2024348:	e59f3040 	ldr	r3, [pc, #64]	; 2024390 <phy_control_reset+0x4c>
 202434c:	0a000007 	beq	2024370 <phy_control_reset+0x2c>
		writel((mem.control1 | (1 << mem.dll_resync)),
 2024350:	e5932044 	ldr	r2, [r3, #68]	; 0x44
 2024354:	e5930028 	ldr	r0, [r3, #40]	; 0x28
 2024358:	e3a0c001 	mov	ip, #1
 202435c:	e180221c 	orr	r2, r0, ip, lsl r2
 2024360:	e581201c 	str	r2, [r1, #28]
		       &dmc->phycontrol1);
		writel((mem.control1 | (0 << mem.dll_resync)),
 2024364:	e5933028 	ldr	r3, [r3, #40]	; 0x28
 2024368:	e581301c 	str	r3, [r1, #28]
 202436c:	e12fff1e 	bx	lr
		       &dmc->phycontrol1);
	} else {
		writel((mem.control0 | (0 << mem.dll_on)),
 2024370:	e5932024 	ldr	r2, [r3, #36]	; 0x24
 2024374:	e5812018 	str	r2, [r1, #24]
		       &dmc->phycontrol0);
		writel((mem.control0 | (1 << mem.dll_on)),
 2024378:	e5930048 	ldr	r0, [r3, #72]	; 0x48
 202437c:	e5932024 	ldr	r2, [r3, #36]	; 0x24
 2024380:	e3a03001 	mov	r3, #1
 2024384:	e1823013 	orr	r3, r2, r3, lsl r0
 2024388:	e5813018 	str	r3, [r1, #24]
 202438c:	e12fff1e 	bx	lr
 2024390:	02024d68 	.word	0x02024d68

02024394 <dmc_config_mrs>:
static void dmc_config_mrs(struct exynos4_dmc *dmc, int chip)
{
	int i;
	unsigned long mask = 0;

	if (chip)
 2024394:	e59f3024 	ldr	r3, [pc, #36]	; 20243c0 <dmc_config_mrs+0x2c>
}

static void dmc_config_mrs(struct exynos4_dmc *dmc, int chip)
{
	int i;
	unsigned long mask = 0;
 2024398:	e3510000 	cmp	r1, #0
 202439c:	13a01601 	movne	r1, #1048576	; 0x100000
 20243a0:	03a01000 	moveq	r1, #0
		writel((mem.control0 | (1 << mem.dll_on)),
		       &dmc->phycontrol0);
	}
}

static void dmc_config_mrs(struct exynos4_dmc *dmc, int chip)
 20243a4:	e2832010 	add	r2, r3, #16

	if (chip)
		mask = DIRECT_CMD_CHIP1_SHIFT;

	for (i = 0; i < MEM_TIMINGS_MSR_COUNT; i++) {
		writel(mem.direct_cmd_msr[i] | mask,
 20243a8:	e5b3c004 	ldr	ip, [r3, #4]!
 20243ac:	e181c00c 	orr	ip, r1, ip
	unsigned long mask = 0;

	if (chip)
		mask = DIRECT_CMD_CHIP1_SHIFT;

	for (i = 0; i < MEM_TIMINGS_MSR_COUNT; i++) {
 20243b0:	e1530002 	cmp	r3, r2
		writel(mem.direct_cmd_msr[i] | mask,
 20243b4:	e580c010 	str	ip, [r0, #16]
	unsigned long mask = 0;

	if (chip)
		mask = DIRECT_CMD_CHIP1_SHIFT;

	for (i = 0; i < MEM_TIMINGS_MSR_COUNT; i++) {
 20243b8:	1afffffa 	bne	20243a8 <dmc_config_mrs+0x14>
		writel(mem.direct_cmd_msr[i] | mask,
		       &dmc->directcmd);
	}
}
 20243bc:	e12fff1e 	bx	lr
 20243c0:	02024d64 	.word	0x02024d64

020243c4 <dmc_init>:

static void dmc_init(struct exynos4_dmc *dmc)
{
 20243c4:	e92d4038 	push	{r3, r4, r5, lr}
	/*
	 * DLL Parameter Setting:
	 * Termination: Enable R/W
	 * Phase Delay for DQS Cleaning: 180' Shift
	 */
	writel(mem.control1, &dmc->phycontrol1);
 20243c8:	e59f5128 	ldr	r5, [pc, #296]	; 20244f8 <dmc_init+0x134>
		       &dmc->directcmd);
	}
}

static void dmc_init(struct exynos4_dmc *dmc)
{
 20243cc:	e1a04000 	mov	r4, r0
	/*
	 * DLL Parameter Setting:
	 * Termination: Enable R/W
	 * Phase Delay for DQS Cleaning: 180' Shift
	 */
	writel(mem.control1, &dmc->phycontrol1);
 20243d0:	e5953028 	ldr	r3, [r5, #40]	; 0x28
 20243d4:	e580301c 	str	r3, [r0, #28]
	/*
	 * ZQ Calibration
	 * Termination: Disable
	 * Auto Calibration Start: Enable
	 */
	writel(mem.zqcontrol, &dmc->phyzqcontrol);
 20243d8:	e5953020 	ldr	r3, [r5, #32]
 20243dc:	e5803044 	str	r3, [r0, #68]	; 0x44
	sdelay(0x100000);
 20243e0:	e3a00601 	mov	r0, #1048576	; 0x100000
 20243e4:	eb0001a1 	bl	2024a70 <sdelay>

	/*
	 * Update DLL Information:
	 * Force DLL Resyncronization
	 */
	phy_control_reset(1, dmc);
 20243e8:	e1a01004 	mov	r1, r4
 20243ec:	e3a00001 	mov	r0, #1
 20243f0:	ebffffd3 	bl	2024344 <phy_control_reset>
	phy_control_reset(0, dmc);
 20243f4:	e3a00000 	mov	r0, #0
 20243f8:	e1a01004 	mov	r1, r4
 20243fc:	ebffffd0 	bl	2024344 <phy_control_reset>

	/* Set DLL Parameters */
	writel(mem.control1, &dmc->phycontrol1);
 2024400:	e5953028 	ldr	r3, [r5, #40]	; 0x28
 2024404:	e584301c 	str	r3, [r4, #28]

	/* DLL Start */
	writel((mem.control0 | CTRL_START | CTRL_DLL_ON), &dmc->phycontrol0);
 2024408:	e5953024 	ldr	r3, [r5, #36]	; 0x24
 202440c:	e3833003 	orr	r3, r3, #3
 2024410:	e5843018 	str	r3, [r4, #24]

	writel(mem.control2, &dmc->phycontrol2);
 2024414:	e595302c 	ldr	r3, [r5, #44]	; 0x2c
 2024418:	e5843020 	str	r3, [r4, #32]

	/* Set Clock Ratio of Bus clock to Memory Clock */
	writel(mem.concontrol, &dmc->concontrol);
 202441c:	e5953030 	ldr	r3, [r5, #48]	; 0x30
 2024420:	e5843000 	str	r3, [r4]
	 * Number of chips: 2
	 * Memory Bus width: 32 bit
	 * Memory Type: DDR3
	 * Additional Latancy for PLL: 1 Cycle
	 */
	writel(mem.memcontrol, &dmc->memcontrol);
 2024424:	e5953038 	ldr	r3, [r5, #56]	; 0x38
 2024428:	e5843004 	str	r3, [r4, #4]

	writel(mem.memconfig0, &dmc->memconfig0);
 202442c:	e595303c 	ldr	r3, [r5, #60]	; 0x3c
 2024430:	e5843008 	str	r3, [r4, #8]
	writel(mem.memconfig1, &dmc->memconfig1);
 2024434:	e5953040 	ldr	r3, [r5, #64]	; 0x40
 2024438:	e584300c 	str	r3, [r4, #12]

#ifdef CONFIG_X4412
	writel(0x8000001F, &dmc->ivcontrol);
 202443c:	e3a0317e 	mov	r3, #-2147483617	; 0x8000001f
 2024440:	e58430f0 	str	r3, [r4, #240]	; 0xf0
#endif

	/* Config Precharge Policy */
	writel(mem.prechconfig, &dmc->prechconfig);
 2024444:	e5953034 	ldr	r3, [r5, #52]	; 0x34
 2024448:	e5843014 	str	r3, [r4, #20]
	/*
	 * TimingAref, TimingRow, TimingData, TimingPower Setting:
	 * Values as per Memory AC Parameters
	 */
	writel(mem.timingref, &dmc->timingref);
 202444c:	e5953010 	ldr	r3, [r5, #16]
 2024450:	e5843030 	str	r3, [r4, #48]	; 0x30
	writel(mem.timingrow, &dmc->timingrow);
 2024454:	e5953014 	ldr	r3, [r5, #20]
 2024458:	e5843034 	str	r3, [r4, #52]	; 0x34
	writel(mem.timingdata, &dmc->timingdata);
 202445c:	e5953018 	ldr	r3, [r5, #24]
 2024460:	e5843038 	str	r3, [r4, #56]	; 0x38
	writel(mem.timingpower, &dmc->timingpower);
 2024464:	e595301c 	ldr	r3, [r5, #28]
 2024468:	e584303c 	str	r3, [r4, #60]	; 0x3c

	/* Chip0: NOP Command: Assert and Hold CKE to high level */
	writel(DIRECT_CMD_NOP, &dmc->directcmd);
 202446c:	e3a03407 	mov	r3, #117440512	; 0x7000000
 2024470:	e5843010 	str	r3, [r4, #16]
	sdelay(0x100000);
 2024474:	e3a00601 	mov	r0, #1048576	; 0x100000
 2024478:	eb00017c 	bl	2024a70 <sdelay>

	/* Chip0: EMRS2, EMRS3, EMRS, MRS Commands Using Direct Command */
	dmc_config_mrs(dmc, 0);
 202447c:	e1a00004 	mov	r0, r4
 2024480:	e3a01000 	mov	r1, #0
 2024484:	ebffffc2 	bl	2024394 <dmc_config_mrs>
	sdelay(0x100000);
 2024488:	e3a00601 	mov	r0, #1048576	; 0x100000
 202448c:	eb000177 	bl	2024a70 <sdelay>

	/* Chip0: ZQINIT */
	writel(DIRECT_CMD_ZQ, &dmc->directcmd);
 2024490:	e3a0340a 	mov	r3, #167772160	; 0xa000000
 2024494:	e5843010 	str	r3, [r4, #16]
	sdelay(0x100000);
 2024498:	e3a00601 	mov	r0, #1048576	; 0x100000
 202449c:	eb000173 	bl	2024a70 <sdelay>

	writel((DIRECT_CMD_NOP | DIRECT_CMD_CHIP1_SHIFT), &dmc->directcmd);
 20244a0:	e3a03671 	mov	r3, #118489088	; 0x7100000
 20244a4:	e5843010 	str	r3, [r4, #16]
	sdelay(0x100000);
 20244a8:	e3a00601 	mov	r0, #1048576	; 0x100000
 20244ac:	eb00016f 	bl	2024a70 <sdelay>

	/* Chip1: EMRS2, EMRS3, EMRS, MRS Commands Using Direct Command */
	dmc_config_mrs(dmc, 1);
 20244b0:	e1a00004 	mov	r0, r4
 20244b4:	e3a01001 	mov	r1, #1
 20244b8:	ebffffb5 	bl	2024394 <dmc_config_mrs>
	sdelay(0x100000);
 20244bc:	e3a00601 	mov	r0, #1048576	; 0x100000
 20244c0:	eb00016a 	bl	2024a70 <sdelay>

	/* Chip1: ZQINIT */
	writel((DIRECT_CMD_ZQ | DIRECT_CMD_CHIP1_SHIFT), &dmc->directcmd);
 20244c4:	e3a036a1 	mov	r3, #168820736	; 0xa100000
 20244c8:	e5843010 	str	r3, [r4, #16]
	sdelay(0x100000);
 20244cc:	e3a00601 	mov	r0, #1048576	; 0x100000
 20244d0:	eb000166 	bl	2024a70 <sdelay>

	phy_control_reset(1, dmc);
 20244d4:	e1a01004 	mov	r1, r4
 20244d8:	e3a00001 	mov	r0, #1
 20244dc:	ebffff98 	bl	2024344 <phy_control_reset>
	sdelay(0x100000);
 20244e0:	e3a00601 	mov	r0, #1048576	; 0x100000
 20244e4:	eb000161 	bl	2024a70 <sdelay>

	/* turn on DREX0, DREX1 */
	writel((mem.concontrol | AREF_EN), &dmc->concontrol);
 20244e8:	e5953030 	ldr	r3, [r5, #48]	; 0x30
 20244ec:	e3833020 	orr	r3, r3, #32
 20244f0:	e5843000 	str	r3, [r4]
}
 20244f4:	e8bd8038 	pop	{r3, r4, r5, pc}
 20244f8:	02024d68 	.word	0x02024d68

020244fc <mem_ctrl_init>:

void mem_ctrl_init(int reset)
{
 20244fc:	e92d4010 	push	{r4, lr}
	/*
	 * Async bridge configuration at CPU_core:
	 * 1: half_sync
	 * 0: full_sync
	 */
	writel(1, ASYNC_CONFIG);
 2024500:	e59f30c4 	ldr	r3, [pc, #196]	; 20245cc <mem_ctrl_init+0xd0>
 2024504:	e3a02001 	mov	r2, #1
 2024508:	e5832350 	str	r2, [r3, #848]	; 0x350
static inline int __attribute__((no_instrument_function)) cpu_is_##type(void) \
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
 202450c:	e59f30bc 	ldr	r3, [pc, #188]	; 20245d0 <mem_ctrl_init+0xd4>
 2024510:	e5933000 	ldr	r3, [r3]
 2024514:	e1a02623 	lsr	r2, r3, #12
SAMSUNG_BASE(watchdog, WATCHDOG_BASE)
SAMSUNG_BASE(power, POWER_BASE)
SAMSUNG_BASE(spi, SPI_BASE)
SAMSUNG_BASE(spi_isp, SPI_ISP_BASE)
SAMSUNG_BASE(tzpc, TZPC_BASE)
SAMSUNG_BASE(dmc_ctrl, DMC_CTRL_BASE)
 2024518:	e3520004 	cmp	r2, #4
 202451c:	1a000005 	bne	2024538 <mem_ctrl_init+0x3c>
 2024520:	e3040412 	movw	r0, #17426	; 0x4412
 2024524:	e59f20a8 	ldr	r2, [pc, #168]	; 20245d4 <mem_ctrl_init+0xd8>
 2024528:	e1530000 	cmp	r3, r0
 202452c:	01a00002 	moveq	r0, r2
 2024530:	13a00541 	movne	r0, #272629760	; 0x10400000
 2024534:	ea00000a 	b	2024564 <mem_ctrl_init+0x68>
 2024538:	e3520005 	cmp	r2, #5
 202453c:	13a00000 	movne	r0, #0
 2024540:	1a000007 	bne	2024564 <mem_ctrl_init+0x68>
 2024544:	e3052420 	movw	r2, #21536	; 0x5420
 2024548:	e1530002 	cmp	r3, r2
 202454c:	059f0084 	ldreq	r0, [pc, #132]	; 20245d8 <mem_ctrl_init+0xdc>
 2024550:	0a000003 	beq	2024564 <mem_ctrl_init+0x68>
 2024554:	e59f207c 	ldr	r2, [pc, #124]	; 20245d8 <mem_ctrl_init+0xdc>
 2024558:	e3530b16 	cmp	r3, #22528	; 0x5800
 202455c:	e59f0078 	ldr	r0, [pc, #120]	; 20245dc <mem_ctrl_init+0xe0>
 2024560:	01a00002 	moveq	r0, r2
#endif
#endif
#endif
	/* DREX0 */
	dmc = (struct exynos4_dmc *)samsung_get_base_dmc_ctrl();
	dmc_init(dmc);
 2024564:	ebffff96 	bl	20243c4 <dmc_init>
static inline int __attribute__((no_instrument_function)) cpu_is_##type(void) \
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
 2024568:	e59f3060 	ldr	r3, [pc, #96]	; 20245d0 <mem_ctrl_init+0xd4>
 202456c:	e5933000 	ldr	r3, [r3]
 2024570:	e1a02623 	lsr	r2, r3, #12
SAMSUNG_BASE(watchdog, WATCHDOG_BASE)
SAMSUNG_BASE(power, POWER_BASE)
SAMSUNG_BASE(spi, SPI_BASE)
SAMSUNG_BASE(spi_isp, SPI_ISP_BASE)
SAMSUNG_BASE(tzpc, TZPC_BASE)
SAMSUNG_BASE(dmc_ctrl, DMC_CTRL_BASE)
 2024574:	e3520004 	cmp	r2, #4
 2024578:	1a000005 	bne	2024594 <mem_ctrl_init+0x98>
 202457c:	e3040412 	movw	r0, #17426	; 0x4412
 2024580:	e59f204c 	ldr	r2, [pc, #76]	; 20245d4 <mem_ctrl_init+0xd8>
 2024584:	e1530000 	cmp	r3, r0
 2024588:	01a00002 	moveq	r0, r2
 202458c:	13a00541 	movne	r0, #272629760	; 0x10400000
 2024590:	ea00000a 	b	20245c0 <mem_ctrl_init+0xc4>
 2024594:	e3520005 	cmp	r2, #5
 2024598:	13a00000 	movne	r0, #0
 202459c:	1a000007 	bne	20245c0 <mem_ctrl_init+0xc4>
 20245a0:	e3052420 	movw	r2, #21536	; 0x5420
 20245a4:	e1530002 	cmp	r3, r2
 20245a8:	059f0028 	ldreq	r0, [pc, #40]	; 20245d8 <mem_ctrl_init+0xdc>
 20245ac:	0a000003 	beq	20245c0 <mem_ctrl_init+0xc4>
 20245b0:	e59f2020 	ldr	r2, [pc, #32]	; 20245d8 <mem_ctrl_init+0xdc>
 20245b4:	e3530b16 	cmp	r3, #22528	; 0x5800
 20245b8:	e59f001c 	ldr	r0, [pc, #28]	; 20245dc <mem_ctrl_init+0xe0>
 20245bc:	01a00002 	moveq	r0, r2
	dmc = (struct exynos4_dmc *)(samsung_get_base_dmc_ctrl()
					+ DMC_OFFSET);
	dmc_init(dmc);
 20245c0:	e2800801 	add	r0, r0, #65536	; 0x10000
}
 20245c4:	e8bd4010 	pop	{r4, lr}
	/* DREX0 */
	dmc = (struct exynos4_dmc *)samsung_get_base_dmc_ctrl();
	dmc_init(dmc);
	dmc = (struct exynos4_dmc *)(samsung_get_base_dmc_ctrl()
					+ DMC_OFFSET);
	dmc_init(dmc);
 20245c8:	eaffff7d 	b	20243c4 <dmc_init>
 20245cc:	10010000 	.word	0x10010000
 20245d0:	02024dc8 	.word	0x02024dc8
 20245d4:	10600000 	.word	0x10600000
 20245d8:	10c20000 	.word	0x10c20000
 20245dc:	10dd0000 	.word	0x10dd0000

020245e0 <system_clock_init>:
static inline int __attribute__((no_instrument_function)) cpu_is_##type(void) \
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
 20245e0:	e59f3294 	ldr	r3, [pc, #660]	; 202487c <system_clock_init+0x29c>
 20245e4:	e5933000 	ldr	r3, [r3]
 20245e8:	e1a03623 	lsr	r3, r3, #12
	}							\
	return 0;						\
}

SAMSUNG_BASE(adc, ADC_BASE)
SAMSUNG_BASE(clock, CLOCK_BASE)
 20245ec:	e3530004 	cmp	r3, #4
 20245f0:	059f3288 	ldreq	r3, [pc, #648]	; 2024880 <system_clock_init+0x2a0>
 20245f4:	0a000003 	beq	2024608 <system_clock_init+0x28>
 20245f8:	e59f2284 	ldr	r2, [pc, #644]	; 2024884 <system_clock_init+0x2a4>
 20245fc:	e3530005 	cmp	r3, #5
 2024600:	01a03002 	moveq	r3, r2
 2024604:	13a03000 	movne	r3, #0
	clr_src_cpu = MUX_APLL_SEL(1) | MUX_CORE_SEL(1) |
		MUX_HPM_SEL(1) | MUX_MPLL_USER_SEL_C(1);
	set = MUX_APLL_SEL(0) | MUX_CORE_SEL(1) | MUX_HPM_SEL(1) |
		MUX_MPLL_USER_SEL_C(1);

	clrsetbits_le32(&clk->src_cpu, clr_src_cpu, set);
 2024608:	e2832905 	add	r2, r3, #81920	; 0x14000
 202460c:	e5920200 	ldr	r0, [r2, #512]	; 0x200
 2024610:	e59f1270 	ldr	r1, [pc, #624]	; 2024888 <system_clock_init+0x2a8>
 2024614:	e282cc02 	add	ip, r2, #512	; 0x200
 2024618:	e0001001 	and	r1, r0, r1
 202461c:	e3811611 	orr	r1, r1, #17825792	; 0x1100000
 2024620:	e3811801 	orr	r1, r1, #65536	; 0x10000
 2024624:	e5821200 	str	r1, [r2, #512]	; 0x200

	/* Set APLL to 1400MHz */
	clr_pll_con0 = SDIV(7) | PDIV(63) | MDIV(1023) | FSEL(1);
	set = SDIV(0x0) | PDIV(0x3) | MDIV(0xAF) | FSEL(1);

	clrsetbits_le32(&clk->apll_con0, clr_pll_con0, set);
 2024628:	e59f025c 	ldr	r0, [pc, #604]	; 202488c <system_clock_init+0x2ac>
 202462c:	e5921100 	ldr	r1, [r2, #256]	; 0x100
 2024630:	e0010000 	and	r0, r1, r0
 2024634:	e59f1254 	ldr	r1, [pc, #596]	; 2024890 <system_clock_init+0x2b0>
 2024638:	e1801001 	orr	r1, r0, r1
 202463c:	e5821100 	str	r1, [r2, #256]	; 0x100

	/* Wait for PLL to be locked */
	while (!(readl(&clk->apll_con0) & PLL_LOCKED_BIT))
 2024640:	e59f224c 	ldr	r2, [pc, #588]	; 2024894 <system_clock_init+0x2b4>
 2024644:	e7931002 	ldr	r1, [r3, r2]
 2024648:	e3110202 	tst	r1, #536870912	; 0x20000000
 202464c:	0afffffc 	beq	2024644 <system_clock_init+0x64>
		continue;

	/* Set CMU_CPU clocks src to APLL */
	set = MUX_APLL_SEL(1) | MUX_CORE_SEL(0) | MUX_HPM_SEL(0) |
		MUX_MPLL_USER_SEL_C(1);
	clrsetbits_le32(&clk->src_cpu, clr_src_cpu, set);
 2024650:	e59c1000 	ldr	r1, [ip]
 2024654:	e59f222c 	ldr	r2, [pc, #556]	; 2024888 <system_clock_init+0x2a8>
 2024658:	e0012002 	and	r2, r1, r2
 202465c:	e3822401 	orr	r2, r2, #16777216	; 0x1000000
 2024660:	e3822001 	orr	r2, r2, #1
 2024664:	e58c2000 	str	r2, [ip]
	*/
	clr = CORE_RATIO(7) | COREM0_RATIO(7) | COREM1_RATIO(7) |
		PERIPH_RATIO(7) | ATB_RATIO(7) | PCLK_DBG_RATIO(7) |
		APLL_RATIO(7) | CORE2_RATIO(7);

	clrsetbits_le32(&clk->div_cpu0, clr, set);
 2024668:	e2831b51 	add	r1, r3, #82944	; 0x14400
 202466c:	e5910100 	ldr	r0, [r1, #256]	; 0x100
 2024670:	e59f2220 	ldr	r2, [pc, #544]	; 2024898 <system_clock_init+0x2b8>
 2024674:	e0002002 	and	r2, r0, r2
 2024678:	e3822705 	orr	r2, r2, #1310720	; 0x140000
 202467c:	e3822e52 	orr	r2, r2, #1312	; 0x520
 2024680:	e5812100 	str	r2, [r1, #256]	; 0x100

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_cpu0) & DIV_STAT_CPU0_CHANGING)
 2024684:	e59f1210 	ldr	r1, [pc, #528]	; 202489c <system_clock_init+0x2bc>
 2024688:	e7930001 	ldr	r0, [r3, r1]
 202468c:	e59f220c 	ldr	r2, [pc, #524]	; 20248a0 <system_clock_init+0x2c0>
 2024690:	e0002002 	and	r2, r0, r2
 2024694:	e3520000 	cmp	r2, #0
 2024698:	1afffffa 	bne	2024688 <system_clock_init+0xa8>
	 * cores_out 	= armclk / (ratio + 1) = 280 (4)
	 */
	clr = COPY_RATIO(7) | HPM_RATIO(7) | CORES_RATIO(7);
	set = COPY_RATIO(4) | HPM_RATIO(4) | CORES_RATIO(4);

	clrsetbits_le32(&clk->div_cpu1, clr, set);
 202469c:	e2832b51 	add	r2, r3, #82944	; 0x14400
 20246a0:	e5921104 	ldr	r1, [r2, #260]	; 0x104
 20246a4:	e3c11e77 	bic	r1, r1, #1904	; 0x770
 20246a8:	e3c11007 	bic	r1, r1, #7
 20246ac:	e3811d11 	orr	r1, r1, #1088	; 0x440
 20246b0:	e3811004 	orr	r1, r1, #4
 20246b4:	e5821104 	str	r1, [r2, #260]	; 0x104

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_cpu1) & DIV_STAT_CPU1_CHANGING)
 20246b8:	e59f11e4 	ldr	r1, [pc, #484]	; 20248a4 <system_clock_init+0x2c4>
 20246bc:	e7930001 	ldr	r0, [r3, r1]
 20246c0:	e3002111 	movw	r2, #273	; 0x111
 20246c4:	e0002002 	and	r2, r0, r2
 20246c8:	e3520000 	cmp	r2, #0
 20246cc:	1afffffa 	bne	20246bc <system_clock_init+0xdc>
		MUX_G2D_ACP1_SEL(1) | MUX_G2D_ACP_SEL(1);
	set = MUX_C2C_SEL(1) | MUX_DMC_BUS_SEL(1) | MUX_DPHY_SEL(1) |
		MUX_MPLL_SEL(0) | MUX_PWI_SEL(0) | MUX_G2D_ACP0_SEL(1) |
		MUX_G2D_ACP1_SEL(1) | MUX_G2D_ACP_SEL(1);

	clrsetbits_le32(&clk->src_dmc, clr_src_dmc, set);
 20246d0:	e2832801 	add	r2, r3, #65536	; 0x10000
 20246d4:	e5921200 	ldr	r1, [r2, #512]	; 0x200
 20246d8:	e59f01c8 	ldr	r0, [pc, #456]	; 20248a8 <system_clock_init+0x2c8>
 20246dc:	e0010000 	and	r0, r1, r0
 20246e0:	e59f11c4 	ldr	r1, [pc, #452]	; 20248ac <system_clock_init+0x2cc>
 20246e4:	e1801001 	orr	r1, r0, r1
 20246e8:	e5821200 	str	r1, [r2, #512]	; 0x200
		continue;

	/* Set MPLL to 800MHz */
	set = SDIV(0) | PDIV(3) | MDIV(100) | FSEL(0) | PLL_ENABLE(1);

	clrsetbits_le32(&clk->mpll_con0, clr_pll_con0, set);
 20246ec:	e59f0198 	ldr	r0, [pc, #408]	; 202488c <system_clock_init+0x2ac>
 20246f0:	e5921108 	ldr	r1, [r2, #264]	; 0x108
 20246f4:	e0010000 	and	r0, r1, r0
 20246f8:	e59f11b0 	ldr	r1, [pc, #432]	; 20248b0 <system_clock_init+0x2d0>
 20246fc:	e1801001 	orr	r1, r0, r1
 2024700:	e5821108 	str	r1, [r2, #264]	; 0x108

	/* Wait for PLL to be locked */
	while (!(readl(&clk->mpll_con0) & PLL_LOCKED_BIT))
 2024704:	e59f11a8 	ldr	r1, [pc, #424]	; 20248b4 <system_clock_init+0x2d4>
 2024708:	e7930001 	ldr	r0, [r3, r1]
 202470c:	e3100202 	tst	r0, #536870912	; 0x20000000
 2024710:	0afffffc 	beq	2024708 <system_clock_init+0x128>
	/* Switch back CMU_DMC mux */
	set = MUX_C2C_SEL(0) | MUX_DMC_BUS_SEL(0) | MUX_DPHY_SEL(0) |
		MUX_MPLL_SEL(1) | MUX_PWI_SEL(6) | MUX_G2D_ACP0_SEL(0) |
		MUX_G2D_ACP1_SEL(0) | MUX_G2D_ACP_SEL(0);

	clrsetbits_le32(&clk->src_dmc, clr_src_dmc, set);
 2024714:	e5920200 	ldr	r0, [r2, #512]	; 0x200
 2024718:	e59f1188 	ldr	r1, [pc, #392]	; 20248a8 <system_clock_init+0x2c8>
 202471c:	e0001001 	and	r1, r0, r1
 2024720:	e3811a61 	orr	r1, r1, #397312	; 0x61000
 2024724:	e5821200 	str	r1, [r2, #512]	; 0x200
	 * aclk_dmcp 	= aclk_dmcd / (ratio + 1) = 100 (1)
	 */
	set = ACP_RATIO(3) | ACP_PCLK_RATIO(1) | DPHY_RATIO(1) |
		DMC_RATIO(1) | DMCD_RATIO(1) | DMCP_RATIO(1);

	clrsetbits_le32(&clk->div_dmc0, clr, set);
 2024728:	e2830b41 	add	r0, r3, #66560	; 0x10400
 202472c:	e5902100 	ldr	r2, [r0, #256]	; 0x100
 2024730:	e59f1180 	ldr	r1, [pc, #384]	; 20248b8 <system_clock_init+0x2d8>
 2024734:	e0021001 	and	r1, r2, r1
 2024738:	e59f217c 	ldr	r2, [pc, #380]	; 20248bc <system_clock_init+0x2dc>
 202473c:	e1812002 	orr	r2, r1, r2

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_dmc0) & DIV_STAT_DMC0_CHANGING)
 2024740:	e59f1178 	ldr	r1, [pc, #376]	; 20248c0 <system_clock_init+0x2e0>
	 * aclk_dmcp 	= aclk_dmcd / (ratio + 1) = 100 (1)
	 */
	set = ACP_RATIO(3) | ACP_PCLK_RATIO(1) | DPHY_RATIO(1) |
		DMC_RATIO(1) | DMCD_RATIO(1) | DMCP_RATIO(1);

	clrsetbits_le32(&clk->div_dmc0, clr, set);
 2024744:	e5802100 	str	r2, [r0, #256]	; 0x100

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_dmc0) & DIV_STAT_DMC0_CHANGING)
 2024748:	e7930001 	ldr	r0, [r3, r1]
 202474c:	e59f2170 	ldr	r2, [pc, #368]	; 20248c4 <system_clock_init+0x2e4>
 2024750:	e0002002 	and	r2, r0, r2
 2024754:	e3520000 	cmp	r2, #0
 2024758:	1afffffa 	bne	2024748 <system_clock_init+0x168>
	 * sclk_pwi 	= MOUTpwi / (ratio + 1) = 100 (7)
	 */
	set = G2D_ACP_RATIO(3) | C2C_RATIO(1) | PWI_RATIO(7) |
		C2C_ACLK_RATIO(1) | DVSEM_RATIO(1) | DPM_RATIO(1);

	clrsetbits_le32(&clk->div_dmc1, clr, set);
 202475c:	e2830b41 	add	r0, r3, #66560	; 0x10400
 2024760:	e5902104 	ldr	r2, [r0, #260]	; 0x104
 2024764:	e59f115c 	ldr	r1, [pc, #348]	; 20248c8 <system_clock_init+0x2e8>
 2024768:	e0021001 	and	r1, r2, r1
 202476c:	e59f2158 	ldr	r2, [pc, #344]	; 20248cc <system_clock_init+0x2ec>
 2024770:	e1812002 	orr	r2, r1, r2

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_dmc1) & DIV_STAT_DMC1_CHANGING)
 2024774:	e59f1154 	ldr	r1, [pc, #340]	; 20248d0 <system_clock_init+0x2f0>
	 * sclk_pwi 	= MOUTpwi / (ratio + 1) = 100 (7)
	 */
	set = G2D_ACP_RATIO(3) | C2C_RATIO(1) | PWI_RATIO(7) |
		C2C_ACLK_RATIO(1) | DVSEM_RATIO(1) | DPM_RATIO(1);

	clrsetbits_le32(&clk->div_dmc1, clr, set);
 2024778:	e5802104 	str	r2, [r0, #260]	; 0x104

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_dmc1) & DIV_STAT_DMC1_CHANGING)
 202477c:	e7930001 	ldr	r0, [r3, r1]
 2024780:	e59f214c 	ldr	r2, [pc, #332]	; 20248d4 <system_clock_init+0x2f4>
 2024784:	e0002002 	and	r2, r0, r2
 2024788:	e3520000 	cmp	r2, #0
 202478c:	1afffffa 	bne	202477c <system_clock_init+0x19c>
	 * Set all to SCLK_MPLL_USER_T
	 */
	set = UART0_SEL(6) | UART1_SEL(6) | UART2_SEL(6) | UART3_SEL(6) |
		UART4_SEL(6);

	clrsetbits_le32(&clk->src_peril0, clr, set);
 2024790:	e2830cc2 	add	r0, r3, #49664	; 0xc200
 2024794:	e5901050 	ldr	r1, [r0, #80]	; 0x50
 2024798:	e59f2138 	ldr	r2, [pc, #312]	; 20248d8 <system_clock_init+0x2f8>
 202479c:	e1a01a21 	lsr	r1, r1, #20
 20247a0:	e1a01a01 	lsl	r1, r1, #20
 20247a4:	e1812002 	orr	r2, r1, r2
 20247a8:	e5802050 	str	r2, [r0, #80]	; 0x50
	 * SCLK_UARTx = MOUTuartX / (ratio + 1) = 100 (7)
	*/
	set = UART0_RATIO(7) | UART1_RATIO(7) | UART2_RATIO(7) |
		UART3_RATIO(7) | UART4_RATIO(7);

	clrsetbits_le32(&clk->div_peril0, clr, set);
 20247ac:	e2830cc5 	add	r0, r3, #50432	; 0xc500
 20247b0:	e5901050 	ldr	r1, [r0, #80]	; 0x50
 20247b4:	e59f2120 	ldr	r2, [pc, #288]	; 20248dc <system_clock_init+0x2fc>
 20247b8:	e1a01a21 	lsr	r1, r1, #20
 20247bc:	e1a01a01 	lsl	r1, r1, #20
 20247c0:	e1812002 	orr	r2, r1, r2
 20247c4:	e5802050 	str	r2, [r0, #80]	; 0x50

	while (readl(&clk->div_stat_peril0) & DIV_STAT_PERIL0_CHANGING)
 20247c8:	e30c1650 	movw	r1, #50768	; 0xc650
 20247cc:	e7930001 	ldr	r0, [r3, r1]
 20247d0:	e59f2108 	ldr	r2, [pc, #264]	; 20248e0 <system_clock_init+0x300>
 20247d4:	e0002002 	and	r2, r0, r2
 20247d8:	e3520000 	cmp	r2, #0
 20247dc:	1afffffa 	bne	20247cc <system_clock_init+0x1ec>
	 * sclk_mmc0 	= DOUTmmc0 / (ratio + 1) = 50 (1)
	*/
	set = MMC0_RATIO(7) | MMC0_PRE_RATIO(1) | MMC1_RATIO(7) |
		MMC1_PRE_RATIO(1);

	clrsetbits_le32(&clk->div_fsys1, clr, set);
 20247e0:	e2830cc5 	add	r0, r3, #50432	; 0xc500
 20247e4:	e5902044 	ldr	r2, [r0, #68]	; 0x44
 20247e8:	e59f10f4 	ldr	r1, [pc, #244]	; 20248e4 <system_clock_init+0x304>
 20247ec:	e0021001 	and	r1, r2, r1
 20247f0:	e59f20f0 	ldr	r2, [pc, #240]	; 20248e8 <system_clock_init+0x308>
 20247f4:	e1812002 	orr	r2, r1, r2
 20247f8:	e5802044 	str	r2, [r0, #68]	; 0x44

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_fsys1) & DIV_STAT_FSYS1_CHANGING)
 20247fc:	e30c1644 	movw	r1, #50756	; 0xc644
 2024800:	e7930001 	ldr	r0, [r3, r1]
 2024804:	e59f20e0 	ldr	r2, [pc, #224]	; 20248ec <system_clock_init+0x30c>
 2024808:	e0002002 	and	r2, r0, r2
 202480c:	e3520000 	cmp	r2, #0
 2024810:	1afffffa 	bne	2024800 <system_clock_init+0x220>
	 * sclk_mmc2 	= DOUTmmc2 / (ratio + 1) = 50 (1)
	*/
	set = MMC2_RATIO(7) | MMC2_PRE_RATIO(1) | MMC3_RATIO(7) |
		MMC3_PRE_RATIO(1);

	clrsetbits_le32(&clk->div_fsys2, clr, set);
 2024814:	e2830cc5 	add	r0, r3, #50432	; 0xc500
 2024818:	e5902048 	ldr	r2, [r0, #72]	; 0x48
 202481c:	e59f10c0 	ldr	r1, [pc, #192]	; 20248e4 <system_clock_init+0x304>
 2024820:	e0021001 	and	r1, r2, r1
 2024824:	e59f20bc 	ldr	r2, [pc, #188]	; 20248e8 <system_clock_init+0x308>
 2024828:	e1812002 	orr	r2, r1, r2
 202482c:	e5802048 	str	r2, [r0, #72]	; 0x48

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_fsys2) & DIV_STAT_FSYS2_CHANGING)
 2024830:	e30c1648 	movw	r1, #50760	; 0xc648
 2024834:	e7930001 	ldr	r0, [r3, r1]
 2024838:	e59f20ac 	ldr	r2, [pc, #172]	; 20248ec <system_clock_init+0x30c>
 202483c:	e0002002 	and	r2, r0, r2
 2024840:	e3520000 	cmp	r2, #0
 2024844:	1afffffa 	bne	2024834 <system_clock_init+0x254>
	 * DOUTmmc4 	= MOUTmmc4 / (ratio + 1) = 100 (7)
	 * sclk_mmc4 	= DOUTmmc4 / (ratio + 1) = 100 (0)
	*/
	set = MMC4_RATIO(7) | MMC4_PRE_RATIO(0);

	clrsetbits_le32(&clk->div_fsys3, clr, set);
 2024848:	e2832cc5 	add	r2, r3, #50432	; 0xc500
 202484c:	e592104c 	ldr	r1, [r2, #76]	; 0x4c
 2024850:	e3c11cff 	bic	r1, r1, #65280	; 0xff00
 2024854:	e3c11007 	bic	r1, r1, #7
 2024858:	e3811007 	orr	r1, r1, #7
 202485c:	e582104c 	str	r1, [r2, #76]	; 0x4c

	/* Wait for divider ready status */
	while (readl(&clk->div_stat_fsys3) & DIV_STAT_FSYS3_CHANGING)
 2024860:	e30c164c 	movw	r1, #50764	; 0xc64c
 2024864:	e7930001 	ldr	r0, [r3, r1]
 2024868:	e3002101 	movw	r2, #257	; 0x101
 202486c:	e0002002 	and	r2, r0, r2
 2024870:	e3520000 	cmp	r2, #0
 2024874:	1afffffa 	bne	2024864 <system_clock_init+0x284>
	writel(VPLL_CON1_VAL, &clk->vpll_con1);
	writel(VPLL_CON0_VAL, &clk->vpll_con0);

	sdelay(0x30000);
#endif
}
 2024878:	e12fff1e 	bx	lr
 202487c:	02024dc8 	.word	0x02024dc8
 2024880:	10030000 	.word	0x10030000
 2024884:	10010000 	.word	0x10010000
 2024888:	feeefffe 	.word	0xfeeefffe
 202488c:	f400c0f8 	.word	0xf400c0f8
 2024890:	08af0300 	.word	0x08af0300
 2024894:	00014100 	.word	0x00014100
 2024898:	88888888 	.word	0x88888888
 202489c:	00014600 	.word	0x00014600
 20248a0:	11111111 	.word	0x11111111
 20248a4:	00014604 	.word	0x00014604
 20248a8:	eee0eeee 	.word	0xeee0eeee
 20248ac:	11100111 	.word	0x11100111
 20248b0:	80640300 	.word	0x80640300
 20248b4:	00010108 	.word	0x00010108
 20248b8:	ff888888 	.word	0xff888888
 20248bc:	00111113 	.word	0x00111113
 20248c0:	00010600 	.word	0x00010600
 20248c4:	00111111 	.word	0x00111111
 20248c8:	80808080 	.word	0x80808080
 20248cc:	01011713 	.word	0x01011713
 20248d0:	00010604 	.word	0x00010604
 20248d4:	01011111 	.word	0x01011111
 20248d8:	00066666 	.word	0x00066666
 20248dc:	00077777 	.word	0x00077777
 20248e0:	00011111 	.word	0x00011111
 20248e4:	00f000f0 	.word	0x00f000f0
 20248e8:	01070107 	.word	0x01070107
 20248ec:	01010101 	.word	0x01010101

020248f0 <copy_uboot_to_ram>:
* Copy U-boot from mmc to RAM:
* COPY_BL2_FNPTR_ADDR: Address in iRAM, which Contains
* Pointer to API (Data transfer from mmc to ram)
*/
void copy_uboot_to_ram(void)
{
 20248f0:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
	if (sec_boot_check == EXYNOS_USB_SECONDARY_BOOT)
		bootmode = BOOT_MODE_USB;
#endif

	if (bootmode == BOOT_MODE_OM)
		bootmode = get_boot_mode();
 20248f4:	ebfffb47 	bl	2023618 <get_boot_mode>

	switch (bootmode) {
 20248f8:	e3500004 	cmp	r0, #4
 20248fc:	18bd81f0 	popne	{r4, r5, r6, r7, r8, pc}
	[USB_INDEX] = 0x02020070,	/* iROM Function Pointer-USB boot*/
	};

void *get_irom_func(int index)
{
	return (void *)*(u32 *)irom_ptr_table[index];
 2024900:	e59f3058 	ldr	r3, [pc, #88]	; 2024960 <copy_uboot_to_ram+0x70>
 2024904:	e5933000 	ldr	r3, [r3]
		break;
#endif
	case BOOT_MODE_SD:
		offset = UBOOT_START_OFFSET;
		size = UBOOT_SIZE_BLOC_COUNT;
		copy_uboot = get_irom_func(MMC_INDEX);
 2024908:	e5936000 	ldr	r6, [r3]
	default:
		break;
	}

#ifdef CONFIG_X4412
	if (copy_uboot)
 202490c:	e3560000 	cmp	r6, #0
 2024910:	08bd81f0 	popeq	{r4, r5, r6, r7, r8, pc}
 2024914:	e59f4048 	ldr	r4, [pc, #72]	; 2024964 <copy_uboot_to_ram+0x74>

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
			/* copy u-boot from sdcard to iram firstly.  */
			copy_uboot((u32)(UBOOT_START_OFFSET+count), (u32)step, (u32)buffer);
			/* then copy u-boot from iram to dram. */
			for (i=0; i<0x10000; i++) {
 2024918:	e59f8048 	ldr	r8, [pc, #72]	; 2024968 <copy_uboot_to_ram+0x78>
		unsigned int i, count = 0;
		unsigned char *buffer = (unsigned char *)0x02050000;
		unsigned char *dst = (unsigned char *)CONFIG_SYS_TEXT_BASE;
		unsigned int step = (0x10000 / 512);

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
 202491c:	e59f7048 	ldr	r7, [pc, #72]	; 202496c <copy_uboot_to_ram+0x7c>
	default:
		break;
	}

#ifdef CONFIG_X4412
	if (copy_uboot)
 2024920:	e3a05051 	mov	r5, #81	; 0x51
		unsigned char *dst = (unsigned char *)CONFIG_SYS_TEXT_BASE;
		unsigned int step = (0x10000 / 512);

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
			/* copy u-boot from sdcard to iram firstly.  */
			copy_uboot((u32)(UBOOT_START_OFFSET+count), (u32)step, (u32)buffer);
 2024924:	e59f2044 	ldr	r2, [pc, #68]	; 2024970 <copy_uboot_to_ram+0x80>
 2024928:	e1a00005 	mov	r0, r5
 202492c:	e3a01080 	mov	r1, #128	; 0x80
 2024930:	e12fff36 	blx	r6
 2024934:	e59f3038 	ldr	r3, [pc, #56]	; 2024974 <copy_uboot_to_ram+0x84>
 2024938:	e1a02004 	mov	r2, r4
			/* then copy u-boot from iram to dram. */
			for (i=0; i<0x10000; i++) {
				*dst++ = buffer[i];
 202493c:	e5f31001 	ldrb	r1, [r3, #1]!

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
			/* copy u-boot from sdcard to iram firstly.  */
			copy_uboot((u32)(UBOOT_START_OFFSET+count), (u32)step, (u32)buffer);
			/* then copy u-boot from iram to dram. */
			for (i=0; i<0x10000; i++) {
 2024940:	e1530008 	cmp	r3, r8
				*dst++ = buffer[i];
 2024944:	e4c21001 	strb	r1, [r2], #1

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
			/* copy u-boot from sdcard to iram firstly.  */
			copy_uboot((u32)(UBOOT_START_OFFSET+count), (u32)step, (u32)buffer);
			/* then copy u-boot from iram to dram. */
			for (i=0; i<0x10000; i++) {
 2024948:	1afffffb 	bne	202493c <copy_uboot_to_ram+0x4c>
 202494c:	e2844801 	add	r4, r4, #65536	; 0x10000
		unsigned int i, count = 0;
		unsigned char *buffer = (unsigned char *)0x02050000;
		unsigned char *dst = (unsigned char *)CONFIG_SYS_TEXT_BASE;
		unsigned int step = (0x10000 / 512);

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
 2024950:	e1540007 	cmp	r4, r7
			/* copy u-boot from sdcard to iram firstly.  */
			copy_uboot((u32)(UBOOT_START_OFFSET+count), (u32)step, (u32)buffer);
			/* then copy u-boot from iram to dram. */
			for (i=0; i<0x10000; i++) {
 2024954:	e2855080 	add	r5, r5, #128	; 0x80
		unsigned int i, count = 0;
		unsigned char *buffer = (unsigned char *)0x02050000;
		unsigned char *dst = (unsigned char *)CONFIG_SYS_TEXT_BASE;
		unsigned int step = (0x10000 / 512);

		for (count = 0; count < UBOOT_SIZE_BLOC_COUNT; count+=step) {
 2024958:	1afffff1 	bne	2024924 <copy_uboot_to_ram+0x34>
 202495c:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}
 2024960:	02024db4 	.word	0x02024db4
 2024964:	43e00000 	.word	0x43e00000
 2024968:	0205ffff 	.word	0x0205ffff
 202496c:	43e80000 	.word	0x43e80000
 2024970:	02050000 	.word	0x02050000
 2024974:	0204ffff 	.word	0x0204ffff

02024978 <memzero>:
void memzero(void *s, size_t n)
{
	char *ptr = s;
	size_t i;

	for (i = 0; i < n; i++)
 2024978:	e3a03000 	mov	r3, #0
		*ptr++ = '\0';
 202497c:	e1a02003 	mov	r2, r3
void memzero(void *s, size_t n)
{
	char *ptr = s;
	size_t i;

	for (i = 0; i < n; i++)
 2024980:	ea000001 	b	202498c <memzero+0x14>
		*ptr++ = '\0';
 2024984:	e7c02003 	strb	r2, [r0, r3]
void memzero(void *s, size_t n)
{
	char *ptr = s;
	size_t i;

	for (i = 0; i < n; i++)
 2024988:	e2833001 	add	r3, r3, #1
 202498c:	e1530001 	cmp	r3, r1
 2024990:	3afffffb 	bcc	2024984 <memzero+0xc>
		*ptr++ = '\0';
}
 2024994:	e12fff1e 	bx	lr

02024998 <board_init_f>:
	gd->baudrate = CONFIG_BAUDRATE;
	gd->have_console = 1;
}

void board_init_f(unsigned long bootflag)
{
 2024998:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
 202499c:	e24dd0c4 	sub	sp, sp, #196	; 0xc4
 * @param gdp   Value to give to gd
 */
static void setup_global_data(gd_t *gdp)
{
	gd = gdp;
	memzero((void *)gd, sizeof(gd_t));
 20249a0:	e1a0000d 	mov	r0, sp
 20249a4:	e3a010c0 	mov	r1, #192	; 0xc0
 *
 * @param gdp   Value to give to gd
 */
static void setup_global_data(gd_t *gdp)
{
	gd = gdp;
 20249a8:	e1a0900d 	mov	r9, sp
	memzero((void *)gd, sizeof(gd_t));
 20249ac:	ebfffff1 	bl	2024978 <memzero>
	gd->flags |= GD_FLG_RELOC;
 20249b0:	e5992004 	ldr	r2, [r9, #4]
 20249b4:	e3822001 	orr	r2, r2, #1
 20249b8:	e5892004 	str	r2, [r9, #4]
	gd->baudrate = CONFIG_BAUDRATE;
 20249bc:	e59f2024 	ldr	r2, [pc, #36]	; 20249e8 <board_init_f+0x50>
 20249c0:	e5892008 	str	r2, [r9, #8]
	gd->have_console = 1;
 20249c4:	e3a02001 	mov	r2, #1
 20249c8:	e589201c 	str	r2, [r9, #28]
	__aligned(8) gd_t local_gd;
	__attribute__((noreturn)) void (*uboot)(void);

	setup_global_data(&local_gd);

	if (do_lowlevel_init())
 20249cc:	eb000007 	bl	20249f0 <do_lowlevel_init>
 20249d0:	e3500000 	cmp	r0, #0
 20249d4:	0a000000 	beq	20249dc <board_init_f+0x44>
		power_exit_wakeup();
 20249d8:	ebfffafd 	bl	20235d4 <power_exit_wakeup>

	copy_uboot_to_ram();
 20249dc:	ebffffc3 	bl	20248f0 <copy_uboot_to_ram>

	/* Jump to U-Boot image */
	uboot = (void *)CONFIG_SYS_TEXT_BASE;
	(*uboot)();
 20249e0:	e59f3004 	ldr	r3, [pc, #4]	; 20249ec <board_init_f+0x54>
 20249e4:	e12fff33 	blx	r3
 20249e8:	0001c200 	.word	0x0001c200
 20249ec:	43e00000 	.word	0x43e00000

020249f0 <do_lowlevel_init>:

extern void relocate_wait_code(void);
#endif

int do_lowlevel_init(void)
{
 20249f0:	e92d4010 	push	{r4, lr}
	uint32_t reset_status;
	int actions = 0;

	arch_cpu_init();
 20249f4:	eb000020 	bl	2024a7c <arch_cpu_init>

	/* Reconfigure secondary cores */
	secondary_cores_configure();
#endif

	reset_status = get_reset_status();
 20249f8:	ebfffae5 	bl	2023594 <get_reset_status>

	switch (reset_status) {
 20249fc:	e59f3064 	ldr	r3, [pc, #100]	; 2024a68 <do_lowlevel_init+0x78>
 2024a00:	e1500003 	cmp	r0, r3
 2024a04:	0a000007 	beq	2024a28 <do_lowlevel_init+0x38>
 2024a08:	e59f305c 	ldr	r3, [pc, #92]	; 2024a6c <do_lowlevel_init+0x7c>
 2024a0c:	e1500003 	cmp	r0, r3
 2024a10:	0a000004 	beq	2024a28 <do_lowlevel_init+0x38>
	case S5P_CHECK_LPA:
		actions = DO_WAKEUP;
		break;
	default:
		/* This is a normal boot (not a wake from sleep) */
		actions = DO_CLOCKS | DO_MEM_RESET | DO_POWER;
 2024a14:	e3004bad 	movw	r4, #2989	; 0xbad
 2024a18:	e1500004 	cmp	r0, r4
 2024a1c:	03a04003 	moveq	r4, #3
 2024a20:	13a04016 	movne	r4, #22
 2024a24:	ea000000 	b	2024a2c <do_lowlevel_init+0x3c>
	case S5P_CHECK_SLEEP:
		actions = DO_CLOCKS | DO_WAKEUP;
		break;
	case S5P_CHECK_DIDLE:
	case S5P_CHECK_LPA:
		actions = DO_WAKEUP;
 2024a28:	e3a04001 	mov	r4, #1
	default:
		/* This is a normal boot (not a wake from sleep) */
		actions = DO_CLOCKS | DO_MEM_RESET | DO_POWER;
	}

	if (actions & DO_POWER)
 2024a2c:	e3140010 	tst	r4, #16
 2024a30:	0a000000 	beq	2024a38 <do_lowlevel_init+0x48>
		set_ps_hold_ctrl();
 2024a34:	ebfffacb 	bl	2023568 <set_ps_hold_ctrl>

	if (actions & DO_CLOCKS) {
 2024a38:	e3140002 	tst	r4, #2
 2024a3c:	0a000007 	beq	2024a60 <do_lowlevel_init+0x70>
		system_clock_init();
 2024a40:	ebfffee6 	bl	20245e0 <system_clock_init>
#ifdef CONFIG_DEBUG_UART
		exynos_pinmux_config(PERIPH_ID_UART3, PINMUX_FLAG_NONE);
 2024a44:	e3a01000 	mov	r1, #0
 2024a48:	e3a00036 	mov	r0, #54	; 0x36
 2024a4c:	ebfffb5f 	bl	20237d0 <exynos_pinmux_config>
		debug_uart_init();
 2024a50:	eb0000b0 	bl	2024d18 <debug_uart_init>
#endif
		mem_ctrl_init(actions & DO_MEM_RESET);
 2024a54:	e2040004 	and	r0, r4, #4
 2024a58:	ebfffea7 	bl	20244fc <mem_ctrl_init>
		tzpc_init();
 2024a5c:	ebfffe07 	bl	2024280 <tzpc_init>
	}

	return actions & DO_WAKEUP;
}
 2024a60:	e2040001 	and	r0, r4, #1
 2024a64:	e8bd8010 	pop	{r4, pc}
 2024a68:	abad0000 	.word	0xabad0000
 2024a6c:	bad00000 	.word	0xbad00000

02024a70 <sdelay>:
 *
 *  not inline to increase chances its in cache when called
 *************************************************************/
void sdelay(unsigned long loops)
{
	__asm__ volatile ("1:\n" "subs %0, %1, #1\n"
 2024a70:	e2500001 	subs	r0, r0, #1
 2024a74:	1afffffd 	bne	2024a70 <sdelay>
			  "bne 1b":"=r" (loops):"0"(loops));
}
 2024a78:	e12fff1e 	bx	lr

02024a7c <arch_cpu_init>:
	return s5p_cpu_rev;
}

static inline void s5p_set_cpu_id(void)
{
	unsigned int pro_id = readl(EXYNOS4_PRO_ID);
 2024a7c:	e3a03201 	mov	r3, #268435456	; 0x10000000
 2024a80:	e5933000 	ldr	r3, [r3]
	unsigned int cpu_id = (pro_id & 0x00FFF000) >> 12;
	unsigned int cpu_rev = pro_id & 0x000000FF;

	switch (cpu_id) {
 2024a84:	e3001412 	movw	r1, #1042	; 0x412

static inline void s5p_set_cpu_id(void)
{
	unsigned int pro_id = readl(EXYNOS4_PRO_ID);
	unsigned int cpu_id = (pro_id & 0x00FFF000) >> 12;
	unsigned int cpu_rev = pro_id & 0x000000FF;
 2024a88:	e20320ff 	and	r2, r3, #255	; 0xff
}

static inline void s5p_set_cpu_id(void)
{
	unsigned int pro_id = readl(EXYNOS4_PRO_ID);
	unsigned int cpu_id = (pro_id & 0x00FFF000) >> 12;
 2024a8c:	e7eb3653 	ubfx	r3, r3, #12, #12
	unsigned int cpu_rev = pro_id & 0x000000FF;

	switch (cpu_id) {
 2024a90:	e1530001 	cmp	r3, r1
 2024a94:	0a000017 	beq	2024af8 <arch_cpu_init+0x7c>
 2024a98:	8a000004 	bhi	2024ab0 <arch_cpu_init+0x34>
 2024a9c:	e3530c02 	cmp	r3, #512	; 0x200
 2024aa0:	0a00000a 	beq	2024ad0 <arch_cpu_init+0x54>
 2024aa4:	e3530e21 	cmp	r3, #528	; 0x210
 2024aa8:	1a00001b 	bne	2024b1c <arch_cpu_init+0xa0>
 2024aac:	ea00000c 	b	2024ae4 <arch_cpu_init+0x68>
 2024ab0:	e3002422 	movw	r2, #1058	; 0x422
 2024ab4:	e1530002 	cmp	r3, r2
 2024ab8:	0a000014 	beq	2024b10 <arch_cpu_init+0x94>
 2024abc:	e3530e52 	cmp	r3, #1312	; 0x520
 2024ac0:	0a00000e 	beq	2024b00 <arch_cpu_init+0x84>
 2024ac4:	e3530e42 	cmp	r3, #1056	; 0x420
 2024ac8:	1a000013 	bne	2024b1c <arch_cpu_init+0xa0>
 2024acc:	ea00000d 	b	2024b08 <arch_cpu_init+0x8c>
	case 0x200:
		/* Exynos4210 EVT0 */
		s5p_cpu_id = 0x4210;
 2024ad0:	e59f304c 	ldr	r3, [pc, #76]	; 2024b24 <arch_cpu_init+0xa8>
 2024ad4:	e3042210 	movw	r2, #16912	; 0x4210
 2024ad8:	e5832000 	str	r2, [r3]
		s5p_cpu_rev = 0;
 2024adc:	e3a02000 	mov	r2, #0
 2024ae0:	ea000002 	b	2024af0 <arch_cpu_init+0x74>
		break;
	case 0x210:
		/* Exynos4210 EVT1 */
		s5p_cpu_id = 0x4210;
 2024ae4:	e3041210 	movw	r1, #16912	; 0x4210
 2024ae8:	e59f3034 	ldr	r3, [pc, #52]	; 2024b24 <arch_cpu_init+0xa8>
 2024aec:	e5831000 	str	r1, [r3]
		s5p_cpu_rev = cpu_rev;
 2024af0:	e59f3030 	ldr	r3, [pc, #48]	; 2024b28 <arch_cpu_init+0xac>
 2024af4:	ea000007 	b	2024b18 <arch_cpu_init+0x9c>
		break;
	case 0x412:
		/* Exynos4412 */
		s5p_cpu_id = 0x4412;
 2024af8:	e3041412 	movw	r1, #17426	; 0x4412
 2024afc:	eafffff9 	b	2024ae8 <arch_cpu_init+0x6c>
		s5p_cpu_rev = cpu_rev;
		break;
	case 0x520:
		/* Exynos5250 */
		s5p_cpu_id = 0x5250;
 2024b00:	e3052250 	movw	r2, #21072	; 0x5250
 2024b04:	ea000002 	b	2024b14 <arch_cpu_init+0x98>
		break;
	case 0x420:
		/* Exynos5420 */
		s5p_cpu_id = 0x5420;
 2024b08:	e3052420 	movw	r2, #21536	; 0x5420
 2024b0c:	ea000000 	b	2024b14 <arch_cpu_init+0x98>
	case 0x422:
		/*
		 * Exynos5800 is a variant of Exynos5420
		 * and has product id 0x5422
		 */
		s5p_cpu_id = 0x5800;
 2024b10:	e3a02b16 	mov	r2, #22528	; 0x5800
 2024b14:	e59f3008 	ldr	r3, [pc, #8]	; 2024b24 <arch_cpu_init+0xa8>
 2024b18:	e5832000 	str	r2, [r3]
int arch_cpu_init(void)
{
	s5p_set_cpu_id();

	return 0;
}
 2024b1c:	e3a00000 	mov	r0, #0
 2024b20:	e12fff1e 	bx	lr
 2024b24:	02024dc8 	.word	0x02024dc8
 2024b28:	02024dcc 	.word	0x02024dcc

02024b2c <_main>:
 */

#if defined(CONFIG_SPL_BUILD) && defined(CONFIG_SPL_STACK)
	ldr	sp, =(CONFIG_SPL_STACK)
#else
	ldr	sp, =(CONFIG_SYS_INIT_SP_ADDR)
 2024b2c:	e3a0d781 	mov	sp, #33816576	; 0x2040000
#if defined(CONFIG_CPU_V7M)	/* v7M forbids using SP as BIC destination */
	mov	r3, sp
	bic	r3, r3, #7
	mov	sp, r3
#else
	bic	sp, sp, #7	/* 8-byte alignment for ABI compliance */
 2024b30:	e3cdd007 	bic	sp, sp, #7
#endif
	mov	r2, sp
 2024b34:	e1a0200d 	mov	r2, sp
	sub	sp, sp, #GD_SIZE	/* allocate one GD above SP */
 2024b38:	e24dd0c0 	sub	sp, sp, #192	; 0xc0
#if defined(CONFIG_CPU_V7M)	/* v7M forbids using SP as BIC destination */
	mov	r3, sp
	bic	r3, r3, #7
	mov	sp, r3
#else
	bic	sp, sp, #7	/* 8-byte alignment for ABI compliance */
 2024b3c:	e3cdd007 	bic	sp, sp, #7
#endif
	mov	r9, sp		/* GD is above SP */
 2024b40:	e1a0900d 	mov	r9, sp
	mov	r1, sp
 2024b44:	e1a0100d 	mov	r1, sp
	mov	r0, #0
 2024b48:	e3a00000 	mov	r0, #0

02024b4c <clr_gd>:
clr_gd:
	cmp	r1, r2			/* while not at end of GD */
 2024b4c:	e1510002 	cmp	r1, r2
#if defined(CONFIG_CPU_V7M)
	itt	lo
#endif
	strlo	r0, [r1]		/* clear 32-bit GD word */
 2024b50:	35810000 	strcc	r0, [r1]
	addlo	r1, r1, #4		/* move to next */
 2024b54:	32811004 	addcc	r1, r1, #4
	blo	clr_gd
 2024b58:	3afffffb 	bcc	2024b4c <clr_gd>
#if defined(CONFIG_SYS_MALLOC_F_LEN)
	sub	sp, sp, #CONFIG_SYS_MALLOC_F_LEN
 2024b5c:	e24ddb01 	sub	sp, sp, #1024	; 0x400
	str	sp, [r9, #GD_MALLOC_BASE]
 2024b60:	e589d090 	str	sp, [r9, #144]	; 0x90
#endif
	/* mov r0, #0 not needed due to above code */
	bl	board_init_f
 2024b64:	ebffff8b 	bl	2024998 <board_init_f>

02024b68 <s5p_gpio_get_bank>:
{							\
	return (s5p_cpu_id >> 12) == id;		\
}

IS_SAMSUNG_TYPE(exynos4, 0x4)
IS_SAMSUNG_TYPE(exynos5, 0x5)
 2024b68:	e59f30b4 	ldr	r3, [pc, #180]	; 2024c24 <s5p_gpio_get_bank+0xbc>
struct exynos_bank_info {
	struct s5p_gpio_bank *bank;
};

static struct s5p_gpio_bank *s5p_gpio_get_bank(unsigned int gpio)
{
 2024b6c:	e92d4010 	push	{r4, lr}
 2024b70:	e5933000 	ldr	r3, [r3]
 2024b74:	e1a02623 	lsr	r2, r3, #12
	{ EXYNOS5420_GPIO_PART6_BASE, EXYNOS5420_GPIO_MAX_PORT },
};

static inline struct gpio_info *get_gpio_data(void)
{
	if (cpu_is_exynos5()) {
 2024b78:	e3520005 	cmp	r2, #5
 2024b7c:	1a00000b 	bne	2024bb0 <s5p_gpio_get_bank+0x48>
		if (proid_is_exynos5420() || proid_is_exynos5800())
 2024b80:	e3052420 	movw	r2, #21536	; 0x5420
 2024b84:	e1530002 	cmp	r3, r2
			return exynos5420_gpio_data;
 2024b88:	059f3098 	ldreq	r3, [pc, #152]	; 2024c28 <s5p_gpio_get_bank+0xc0>

static inline unsigned int get_bank_num(void)
{
	if (cpu_is_exynos5()) {
		if (proid_is_exynos5420() || proid_is_exynos5800())
			return EXYNOS5420_GPIO_NUM_PARTS;
 2024b8c:	03a01006 	moveq	r1, #6
};

static inline struct gpio_info *get_gpio_data(void)
{
	if (cpu_is_exynos5()) {
		if (proid_is_exynos5420() || proid_is_exynos5800())
 2024b90:	0a000011 	beq	2024bdc <s5p_gpio_get_bank+0x74>
			return exynos5420_gpio_data;
		else
			return exynos5_gpio_data;
 2024b94:	e3530b16 	cmp	r3, #22528	; 0x5800
 2024b98:	e59f2088 	ldr	r2, [pc, #136]	; 2024c28 <s5p_gpio_get_bank+0xc0>
 2024b9c:	e59f3088 	ldr	r3, [pc, #136]	; 2024c2c <s5p_gpio_get_bank+0xc4>
 2024ba0:	03a01006 	moveq	r1, #6
 2024ba4:	13a01008 	movne	r1, #8
 2024ba8:	01a03002 	moveq	r3, r2
 2024bac:	ea00000a 	b	2024bdc <s5p_gpio_get_bank+0x74>
	} else if (cpu_is_exynos4()) {
 2024bb0:	e3520004 	cmp	r2, #4
			return exynos4x12_gpio_data;
		else
			return exynos4_gpio_data;
	}

	return NULL;
 2024bb4:	13a03000 	movne	r3, #0
			return EXYNOS4X12_GPIO_NUM_PARTS;
		else
			return EXYNOS4_GPIO_NUM_PARTS;
	}

	return 0;
 2024bb8:	11a01003 	movne	r1, r3
	if (cpu_is_exynos5()) {
		if (proid_is_exynos5420() || proid_is_exynos5800())
			return exynos5420_gpio_data;
		else
			return exynos5_gpio_data;
	} else if (cpu_is_exynos4()) {
 2024bbc:	1a000006 	bne	2024bdc <s5p_gpio_get_bank+0x74>
		if (proid_is_exynos4412())
 2024bc0:	e3042412 	movw	r2, #17426	; 0x4412
			return exynos4x12_gpio_data;
		else
			return exynos4_gpio_data;
 2024bc4:	e1530002 	cmp	r3, r2
 2024bc8:	e59f3060 	ldr	r3, [pc, #96]	; 2024c30 <s5p_gpio_get_bank+0xc8>
 2024bcc:	e59f2060 	ldr	r2, [pc, #96]	; 2024c34 <s5p_gpio_get_bank+0xcc>
 2024bd0:	03a01008 	moveq	r1, #8
 2024bd4:	13a01004 	movne	r1, #4
 2024bd8:	01a03002 	moveq	r3, r2

	data = get_gpio_data();
	count = get_bank_num();
	upto = 0;

	for (i = 0; i < count; i++) {
 2024bdc:	e3a02000 	mov	r2, #0
	unsigned int upto;
	int i, count;

	data = get_gpio_data();
	count = get_bank_num();
	upto = 0;
 2024be0:	e1a0c002 	mov	ip, r2

	for (i = 0; i < count; i++) {
 2024be4:	ea00000a 	b	2024c14 <s5p_gpio_get_bank+0xac>
		debug("i=%d, upto=%d\n", i, upto);
		if (gpio < data->max_gpio) {
 2024be8:	e5934004 	ldr	r4, [r3, #4]
 2024bec:	e1500004 	cmp	r0, r4
 2024bf0:	2a000004 	bcs	2024c08 <s5p_gpio_get_bank+0xa0>
			struct s5p_gpio_bank *bank;
			bank = (struct s5p_gpio_bank *)data->reg_addr;
 2024bf4:	e5933000 	ldr	r3, [r3]
			bank += (gpio - upto) / GPIO_PER_BANK;
 2024bf8:	e06c0000 	rsb	r0, ip, r0
 2024bfc:	e1a001a0 	lsr	r0, r0, #3
 2024c00:	e0830280 	add	r0, r3, r0, lsl #5
			debug("gpio=%d, bank=%p\n", gpio, bank);
			return bank;
 2024c04:	e8bd8010 	pop	{r4, pc}
		}

		upto = data->max_gpio;
		data++;
 2024c08:	e2833008 	add	r3, r3, #8

	data = get_gpio_data();
	count = get_bank_num();
	upto = 0;

	for (i = 0; i < count; i++) {
 2024c0c:	e2822001 	add	r2, r2, #1
 2024c10:	e1a0c004 	mov	ip, r4
 2024c14:	e1520001 	cmp	r2, r1
 2024c18:	bafffff2 	blt	2024be8 <s5p_gpio_get_bank+0x80>

		upto = data->max_gpio;
		data++;
	}

	return NULL;
 2024c1c:	e3a00000 	mov	r0, #0
}
 2024c20:	e8bd8010 	pop	{r4, pc}
 2024c24:	02024dc8 	.word	0x02024dc8
 2024c28:	02024e30 	.word	0x02024e30
 2024c2c:	02024df0 	.word	0x02024df0
 2024c30:	02024dd0 	.word	0x02024dd0
 2024c34:	02024e60 	.word	0x02024e60

02024c38 <gpio_set_value>:
}

#ifdef CONFIG_SPL_BUILD
/* Common GPIO API - SPL does not support driver model yet */
int gpio_set_value(unsigned gpio, int value)
{
 2024c38:	e92d4038 	push	{r3, r4, r5, lr}
 2024c3c:	e1a04000 	mov	r4, r0
 2024c40:	e1a05001 	mov	r5, r1
	s5p_gpio_set_value(s5p_gpio_get_bank(gpio),
 2024c44:	ebffffc7 	bl	2024b68 <s5p_gpio_get_bank>

static void s5p_gpio_set_value(struct s5p_gpio_bank *bank, int gpio, int en)
{
	unsigned int value;

	value = readl(&bank->dat);
 2024c48:	e5903004 	ldr	r3, [r0, #4]
	value &= ~DAT_MASK(gpio);
 2024c4c:	e3a02001 	mov	r2, #1
	writel(value, &bank->drv);
}

int s5p_gpio_get_pin(unsigned gpio)
{
	return S5P_GPIO_GET_PIN(gpio);
 2024c50:	e2044007 	and	r4, r4, #7
static void s5p_gpio_set_value(struct s5p_gpio_bank *bank, int gpio, int en)
{
	unsigned int value;

	value = readl(&bank->dat);
	value &= ~DAT_MASK(gpio);
 2024c54:	e1a04412 	lsl	r4, r2, r4
	if (en)
 2024c58:	e3550000 	cmp	r5, #0
static void s5p_gpio_set_value(struct s5p_gpio_bank *bank, int gpio, int en)
{
	unsigned int value;

	value = readl(&bank->dat);
	value &= ~DAT_MASK(gpio);
 2024c5c:	e1c33004 	bic	r3, r3, r4
	if (en)
		value |= DAT_SET(gpio);
 2024c60:	11833004 	orrne	r3, r3, r4
	writel(value, &bank->dat);
 2024c64:	e5803004 	str	r3, [r0, #4]
{
	s5p_gpio_set_value(s5p_gpio_get_bank(gpio),
			   s5p_gpio_get_pin(gpio), value);

	return 0;
}
 2024c68:	e3a00000 	mov	r0, #0
 2024c6c:	e8bd8038 	pop	{r3, r4, r5, pc}

02024c70 <gpio_set_pull>:
/*
 * There is no common GPIO API for pull, drv, pin, rate (yet). These
 * functions are kept here to preserve function ordering for review.
 */
void gpio_set_pull(int gpio, int mode)
{
 2024c70:	e92d4038 	push	{r3, r4, r5, lr}
 2024c74:	e1a04000 	mov	r4, r0
 2024c78:	e1a05001 	mov	r5, r1
	s5p_gpio_set_pull(s5p_gpio_get_bank(gpio),
 2024c7c:	ebffffb9 	bl	2024b68 <s5p_gpio_get_bank>

static void s5p_gpio_set_pull(struct s5p_gpio_bank *bank, int gpio, int mode)
{
	unsigned int value;

	value = readl(&bank->pull);
 2024c80:	e5903008 	ldr	r3, [r0, #8]
	writel(value, &bank->drv);
}

int s5p_gpio_get_pin(unsigned gpio)
{
	return S5P_GPIO_GET_PIN(gpio);
 2024c84:	e2044007 	and	r4, r4, #7
static void s5p_gpio_set_pull(struct s5p_gpio_bank *bank, int gpio, int mode)
{
	unsigned int value;

	value = readl(&bank->pull);
	value &= ~PULL_MASK(gpio);
 2024c88:	e1a04084 	lsl	r4, r4, #1
 2024c8c:	e3a02003 	mov	r2, #3

	switch (mode) {
 2024c90:	e3550001 	cmp	r5, #1
static void s5p_gpio_set_pull(struct s5p_gpio_bank *bank, int gpio, int mode)
{
	unsigned int value;

	value = readl(&bank->pull);
	value &= ~PULL_MASK(gpio);
 2024c94:	e1c33412 	bic	r3, r3, r2, lsl r4

	switch (mode) {
 2024c98:	0a000001 	beq	2024ca4 <gpio_set_pull+0x34>
 2024c9c:	e1550002 	cmp	r5, r2
 2024ca0:	1a000000 	bne	2024ca8 <gpio_set_pull+0x38>
	case S5P_GPIO_PULL_DOWN:
	case S5P_GPIO_PULL_UP:
		value |= PULL_MODE(gpio, mode);
 2024ca4:	e1833415 	orr	r3, r3, r5, lsl r4
		break;
	default:
		break;
	}

	writel(value, &bank->pull);
 2024ca8:	e5803008 	str	r3, [r0, #8]
 */
void gpio_set_pull(int gpio, int mode)
{
	s5p_gpio_set_pull(s5p_gpio_get_bank(gpio),
			  s5p_gpio_get_pin(gpio), mode);
}
 2024cac:	e8bd8038 	pop	{r3, r4, r5, pc}

02024cb0 <gpio_set_drv>:

void gpio_set_drv(int gpio, int mode)
{
 2024cb0:	e92d4038 	push	{r3, r4, r5, lr}
 2024cb4:	e1a04000 	mov	r4, r0
 2024cb8:	e1a05001 	mov	r5, r1
	s5p_gpio_set_drv(s5p_gpio_get_bank(gpio),
 2024cbc:	ebffffa9 	bl	2024b68 <s5p_gpio_get_bank>

static void s5p_gpio_set_drv(struct s5p_gpio_bank *bank, int gpio, int mode)
{
	unsigned int value;

	value = readl(&bank->drv);
 2024cc0:	e590300c 	ldr	r3, [r0, #12]
	value &= ~DRV_MASK(gpio);

	switch (mode) {
 2024cc4:	e3550003 	cmp	r5, #3
 2024cc8:	88bd8038 	pophi	{r3, r4, r5, pc}
	writel(value, &bank->drv);
}

int s5p_gpio_get_pin(unsigned gpio)
{
	return S5P_GPIO_GET_PIN(gpio);
 2024ccc:	e2044007 	and	r4, r4, #7
static void s5p_gpio_set_drv(struct s5p_gpio_bank *bank, int gpio, int mode)
{
	unsigned int value;

	value = readl(&bank->drv);
	value &= ~DRV_MASK(gpio);
 2024cd0:	e1a04084 	lsl	r4, r4, #1
 2024cd4:	e3a02003 	mov	r2, #3
 2024cd8:	e1c33412 	bic	r3, r3, r2, lsl r4
	switch (mode) {
	case S5P_GPIO_DRV_1X:
	case S5P_GPIO_DRV_2X:
	case S5P_GPIO_DRV_3X:
	case S5P_GPIO_DRV_4X:
		value |= DRV_SET(gpio, mode);
 2024cdc:	e1834415 	orr	r4, r3, r5, lsl r4
		break;
	default:
		return;
	}

	writel(value, &bank->drv);
 2024ce0:	e580400c 	str	r4, [r0, #12]
 2024ce4:	e8bd8038 	pop	{r3, r4, r5, pc}

02024ce8 <gpio_cfg_pin>:
	s5p_gpio_set_drv(s5p_gpio_get_bank(gpio),
			 s5p_gpio_get_pin(gpio), mode);
}

void gpio_cfg_pin(int gpio, int cfg)
{
 2024ce8:	e92d4038 	push	{r3, r4, r5, lr}
 2024cec:	e1a04000 	mov	r4, r0
 2024cf0:	e1a05001 	mov	r5, r1
	s5p_gpio_cfg_pin(s5p_gpio_get_bank(gpio),
 2024cf4:	ebffff9b 	bl	2024b68 <s5p_gpio_get_bank>

static void s5p_gpio_cfg_pin(struct s5p_gpio_bank *bank, int gpio, int cfg)
{
	unsigned int value;

	value = readl(&bank->con);
 2024cf8:	e5903000 	ldr	r3, [r0]
	writel(value, &bank->drv);
}

int s5p_gpio_get_pin(unsigned gpio)
{
	return S5P_GPIO_GET_PIN(gpio);
 2024cfc:	e2044007 	and	r4, r4, #7
static void s5p_gpio_cfg_pin(struct s5p_gpio_bank *bank, int gpio, int cfg)
{
	unsigned int value;

	value = readl(&bank->con);
	value &= ~CON_MASK(gpio);
 2024d00:	e1a04104 	lsl	r4, r4, #2
 2024d04:	e3a0200f 	mov	r2, #15
 2024d08:	e1c33412 	bic	r3, r3, r2, lsl r4
	value |= CON_SFR(gpio, cfg);
 2024d0c:	e1834415 	orr	r4, r3, r5, lsl r4
	writel(value, &bank->con);
 2024d10:	e5804000 	str	r4, [r0]

void gpio_cfg_pin(int gpio, int cfg)
{
	s5p_gpio_cfg_pin(s5p_gpio_get_bank(gpio),
			 s5p_gpio_get_pin(gpio), cfg);
}
 2024d14:	e8bd8038 	pop	{r3, r4, r5, pc}

02024d18 <debug_uart_init>:

static void __maybe_unused s5p_serial_init(struct s5p_uart *uart)
{
	/* enable FIFOs, auto clear Rx FIFO */
	/*writel(0x3, &uart->ufcon);*/
	writel(0x111, &uart->ufcon);
 2024d18:	e59f3044 	ldr	r3, [pc, #68]	; 2024d64 <debug_uart_init+0x4c>
 2024d1c:	e3002111 	movw	r2, #273	; 0x111
 2024d20:	e5832000 	str	r2, [r3]
	writel(0, &uart->umcon);
 2024d24:	e3a02000 	mov	r2, #0
 2024d28:	e2833004 	add	r3, r3, #4
 2024d2c:	e5832000 	str	r2, [r3]
	/* 8N1 */
	writel(0x3, &uart->ulcon);
 2024d30:	e2822003 	add	r2, r2, #3
 2024d34:	e243300c 	sub	r3, r3, #12
 2024d38:	e5832000 	str	r2, [r3]
	/* No interrupts, no DMA, pure polling */
	/*writel(0x245, &uart->ucon);*/
	writel(0x3c5, &uart->ucon);
 2024d3c:	e30023c5 	movw	r2, #965	; 0x3c5
 2024d40:	e2833004 	add	r3, r3, #4
 2024d44:	e5832000 	str	r2, [r3]
{
	u32 val;

	val = uclk / baudrate;

	writel(val / 16 - 1, &uart->ubrdiv);
 2024d48:	e2422e39 	sub	r2, r2, #912	; 0x390
 2024d4c:	e2833024 	add	r3, r3, #36	; 0x24
 2024d50:	e5832000 	str	r2, [r3]

	if (s5p_uart_divslot())
		writew(udivslot[val % 16], &uart->rest.slot);
	else
		writeb(val % 16, &uart->rest.value);
 2024d54:	e3a02004 	mov	r2, #4
 2024d58:	e0833002 	add	r3, r3, r2
 2024d5c:	e5c32000 	strb	r2, [r3]
{
	struct s5p_uart *uart = (struct s5p_uart *)CONFIG_DEBUG_UART_BASE;

	s5p_serial_init(uart);
	s5p_serial_baud(uart, CONFIG_DEBUG_UART_CLOCK, CONFIG_BAUDRATE);
}
 2024d60:	e12fff1e 	bx	lr
 2024d64:	13830008 	.word	0x13830008
