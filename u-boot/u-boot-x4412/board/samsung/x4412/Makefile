# SPDX-License-Identifier: GPL-2.0+
#
# Copyright (C) 2011 Samsung Electronics
#
# Add by Wang.Yu 2018-09-25. Copy from samsung origen board.

ifdef CONFIG_SPL_BUILD
# necessary to create built-in.o
obj- := __dummy__.o

hostprogs-y := tools/mkx4412spl
always := $(hostprogs-y)

# omit -O2 option to suppress
#   warning: dereferencing type-punned pointer will break strict-aliasing rules
#
# TODO:
# Fix the root cause in tools/mkx4412spl.c and delete the following work-around
$(obj)/tools/mkx4412spl: HOSTCFLAGS:=$(filter-out -O2,$(HOSTCFLAGS))
else
obj-y	+= x4412.o
endif
