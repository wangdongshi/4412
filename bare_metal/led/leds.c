/*
 * File Name : leds.c
 * Author    : Wang.Yu
 * Revision  : 0.0.1	2018/09/23	Create
 * Revision  : 0.0.2	2018/09/25	Add XPSHOLD support
 */

#define GPX1CON (*(volatile unsigned int *)0x11000C20)
#define GPX1DAT (*(volatile unsigned int *)0x11000C24)
#define GPX2CON (*(volatile unsigned int *)0x11000C40)
#define GPX2DAT (*(volatile unsigned int *)0x11000C44)

#define LED0	0	/* D22:GPX1_6 */
#define LED1	1	/* D23:GPX1_7 */
#define LED2	2	/* D24:GPX2_6 */
#define LED3	3	/* D25:GPX2_7 */

static void delay(unsigned int cnt)
{
	while(cnt--);
}

void leds_init()
{
	GPX1CON = (GPX1CON & (!0xffff)) | 1 << 24 | 1 << 28; /* D22:GPX1_6, D23:GPX1_7 */
	GPX2CON = (GPX1CON & (!0xffff)) | 1 << 24 | 1 << 28; /* D24:GPX2_6, D25:GPX2_7 */
}

void leds_on(unsigned int no)
{
	switch (no) {
		case LED0:
			GPX1DAT = (GPX1DAT & 0x3f) | 0x40;
			GPX2DAT = (GPX2DAT & 0x3f) | 0x00;
			break;
		case LED1:
			GPX1DAT = (GPX1DAT & 0x3f) | 0x80;
			GPX2DAT = (GPX2DAT & 0x3f) | 0x00;
			break;
		case LED2:
			GPX1DAT = (GPX1DAT & 0x3f) | 0x00;
			GPX2DAT = (GPX2DAT & 0x3f) | 0x40;
			break;
		case LED3:
			GPX1DAT = (GPX1DAT & 0x3f) | 0x00;
			GPX2DAT = (GPX2DAT & 0x3f) | 0x80;
			break;
		default:
			GPX1DAT = (GPX1DAT & 0x3f) | 0x00;
			GPX2DAT = (GPX2DAT & 0x3f) | 0x00;
			break;
	}
}

int main(void)
{
	/* initialize 4 LED */
	leds_init();
	
	/* delay */
	delay(0xffff);
	
	/* turn on water light */
	while (1) {
		leds_on(LED0);
		delay(0xffff);
		leds_on(LED1);
		delay(0xffff);
		leds_on(LED2);
		delay(0xffff);
		leds_on(LED3);
		delay(0xffff);
	}
	
	return 0;
}
