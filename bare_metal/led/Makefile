TGT := leds.bin
OBJS := start.o leds.o 
#CROSS_COMPILER := arm-linux-
CROSS_COMPILER := arm-none-eabi-
CC := $(CROSS_COMPILER)gcc
LD := $(CROSS_COMPILER)ld
OBJCOPY := $(CROSS_COMPILER)objcopy
OBJDUMP := $(CROSS_COMPILER)objdump
CFLAGS := -Wall -marm #-ffreestanding -nostdlib
LDFLAGS := -T$(TGT:.bin=.lds) -N
RM := -rm -f
export BL2 := $(PWD)/$(TGT)

$(TGT):$(OBJS)
	$(LD) $(LDFLAGS) -o $(TGT:.bin=.elf) $^
	$(OBJCOPY) -O binary -S $(TGT:.bin=.elf) $@
%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<
%.o:%.S
	$(CC) $(CFLAGS) -c -o $@ $<

load:$(TGT)
	make -C ../tools
dump:$(TGT)
	$(OBJDUMP) -D $(TGT:.bin=.elf)

all : $(TGT)

clean:
	$(RM) $(OBJS) $(TGT) $(TGT:.bin=.elf)

.PHONY: clean load
