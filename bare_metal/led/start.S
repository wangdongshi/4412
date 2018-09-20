.text
.global _start
_start:
	bl clear_bss  // bl跳转时会更新lr(链接寄存器 Link Register R14),BL或BLX指令将PC(R15)的当前值复制给lr
	bl init_call
	bl main

clear_bss:
	push {lr} //伪指令  STMFD LDMFD
	ldr r0, =__bss_start__ //伪指令 ldr r0, #0x11 立即数方式使用不是伪指令,但由于立即数要求合法问题用的不多
	ldr r1, =__bss_end__
	//记住段可能为空
	mov r2, #0  //立即数寻址
1:
	cmp r0, r1
	popeq {pc} //如果r0 r1相等的话就什么都不做直接退出
	str r2, [r0] //将 *r0 = r2
	add r0, #4
	bne 1b //如果不相等就继续
	pop {pc}


init_call:
	push {r4, r5, lr}  //ATPCS规范, R4-R12函数内使用后需要恢复
	ldr r4, =__initcall_start__
	ldr r5, =__initcall_end__
	//记住段可能为空
1:
	cmp r4, r5  //影响CPSR.z
	popeq {r4, r5, pc}
	ldr r0, [r4] // r0 = *r4
	mov lr, pc  
	mov pc, r0 //跳转module_init挂载的函数处执行,由于保存了PC的值所以C函数执行完毕会回到下两条指令继续执行
	add r4, #4
	bne 1b

	pop {r4, r5, pc}



