/*************************************************************************
	> File Name: led.c
	> Created Time: 2014年11月22日 星期六 16时07分20秒
 ************************************************************************/

#include "typedef.h"

#define GPM4CON (*(volatile u32 *)0x110002e0)
#define GPM4DAT (*(volatile u8 *)0x110002e4)


static void delay(u32 d)
{
	while(d--);
}

void leds_init()
{
	GPM4CON = (GPM4CON & (!0xffff)) | 1 | 1 << 4 | 1 << 8 | 1 << 12;
}

void leds_on(u8 n)
{
	GPM4DAT = (GPM4DAT & 0xf0) | (n & 0xf);
}

int main(void)
{
//	leds_init();
	delay(0xffff);
	while (1) { //好吧,我承认,方法......
		leds_on(0b0001);
		delay(0xffff);
		leds_on(0b0010);
		delay(0xffff);
		leds_on(0b0100);
		delay(0xffff);
		leds_on(0b1000);
		delay(0xffff);
	}
	return 0;
}

module_init(leds_init);


