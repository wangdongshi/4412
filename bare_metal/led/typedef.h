/*************************************************************************
	> File Name: typedef.h
	> Created Time: 2014年07月11日 星期五 15时15分11秒
 ************************************************************************/

#pragma once

typedef unsigned int u32;
typedef signed int s32;
typedef unsigned short u16;
typedef signed short s16;
typedef unsigned char u8;
typedef signed long s8;


#define module_init(pfunc) \
	static void (*p_##pfunc)() __attribute__((__section__(".initcall"))) = pfunc
