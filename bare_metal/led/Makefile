TARGET := leds.bin
OBJS := start.o leds.o 

CROSS_COMPILER := arm-linux-
CC := $(CROSS_COMPILER)gcc
LD := $(CROSS_COMPILER)ld
OBJCOPY := $(CROSS_COMPILER)objcopy
OBJDUMP := $(CROSS_COMPILER)objdump
RM := -rm -f

CFLAGS := -Wall -marm #-ffreestanding -nostdlib
LDFLAGS := -T$(TARGET:.bin=.lds) -N

export BL2 := $(PWD)/$(TARGET)

all:$(TARGET)

$(TARGET):$(OBJS)
#下一行中的$(TARGET:.bin=.elf)的意>思是把“TARGET”中所有的.bin替换为.elf，$^是指代“所有依赖目标的集合”，展开时以空格分隔
	$(LD) $(LDFLAGS) -o $(TARGET:.bin=.elf) $^
#这里$@是指代“所有目标文>件集”
	$(OBJCOPY) -O binary -S $(TARGET:.bin=.elf) $@

%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o:%.S
	$(CC) $(CFLAGS) -c -o $@ $<

load:$(TARGET)
	make -C ../tools

dump:$(TARGET)
	$(OBJDUMP) -D $(TARGET:.bin=.elf)

clean:
	$(RM) $(OBJS) $(TARGET) $(TARGET:.bin=.elf)

.PHONY: clean load
