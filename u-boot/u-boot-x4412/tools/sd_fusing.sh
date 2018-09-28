#!/bin/sh

if [ -z $1 ]  #判断参数1的字符串是否为空，如果为空，则打印出帮助信息
then
    echo "usage: sd_fusing.sh <SD Reader's device file>"
    exit 0
fi

if [ -b $1 ]  #判断参数1所指向的设备节点是否存在
then
    echo "$1 reader is identified."
else
    echo "$1 is NOT identified."
    exit -1
fi

####################################
#<verify device>

#清楚掉最后一个'/'前面的内容
BDEV_NAME=`basename $1`
#通过linux内核的虚拟文件系统获得设备文件的ｂｌｏｃｋ数
BDEV_SIZE=`cat /sys/block/${BDEV_NAME}/size`

#如果卡的容量小于0，则打印失败信息，并退出
if [ ${BDEV_SIZE} -le 0 ]; then 
 echo "Error: NO media found in card reader."
 exit 1
fi

#如果卡的容量大于32000000，则打印失败信息，并退出
if [ ${BDEV_SIZE} -gt 32000000 ]; then                               
 echo "Error: Block device size (${BDEV_SIZE}) is too large"
 exit 1
fi

####################################
# check files

E4412_BL1=./E4412_N.bl1.bin
E4412_BL2=./bl2.bin
E4412_SPL=../spl/u-boot-spl.bin
E4412_UBOOT=../u-boot-dtb.bin
MKBL2=./mkbl2

#检查source file是否存在
if [ ! -f ${E4412_SPL} ]; then                                     
 echo "Error: $2 NOT found, please build it & try again."
 exit -1
fi


#<make bl2>
#使用my_mkbl2工具来处理传入的spl，从而生成bl2.bin
${MKBL2} ${E4412_SPL} ${E4412_BL2} 14336                                

####################################
# fusing images

signed_bl1_position=1  #bl1的镜像烧写到SD卡的第1个扇区
bl2_position=17        #bl2的镜像烧写到SD卡的第17个扇区
uboot_position=81      #U-boot的镜像烧写到SD卡的第81个扇区

#<BL1 fusing>
echo "---------------------------------------"
echo "BL1 fusing"
# 烧写bl1到SD卡512字节处,第一个sector
dd iflag=dsync oflag=dsync if=${E4412_BL1} of=$1 seek=$signed_bl1_position

# 如果失败则退出
if [ $? -ne 0 ]
then
   echo Write BL1 Error!
   exit -1
fi

#<BL2 fusing>
echo "---------------------------------------"
echo "BL2 fusing"
# 烧写bl2到SD卡(512+8K)字节处, 512+8K=17x512,即第17个block
dd iflag=dsync oflag=dsync if=${E4412_BL2} of=$1 seek=$bl2_position

# 如果失败则退出
if [ $? -ne 0 ]
then
   echo Write BL2 Error!
   exit -1
fi

#<u-boot fusing>
echo "---------------------------------------"
echo "u-boot fusing"
dd iflag=dsync oflag=dsync if=${E4412_UBOOT} of=$1 seek=$uboot_position

# 如果失败则退出
if [ $? -ne 0 ]
then
   echo Write BL2 Error!
   exit -1
fi

#块设备的写入操作会经由电梯算法进行缓冲，实际写入的时机往往远远晚于应用层的写入操作时间。要避免出现dd之后没有写入的现象，这里补上sync
#<flush to disk>
# 同步文件
sync

rm bl2.bin

####################################
#<Message Display>
echo "---------------------------------------"
echo "source file image is fused successfully."
echo "Eject SD card and insert it to Exynos 4412 board again."


umount /dev/mmcblk0p1
#eject /dev/mmcblk0
#if [ $? -eq 0 ];then
#	echo "Eject SD card successfully."
#fi
