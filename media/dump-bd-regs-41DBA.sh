#!/bin/sh
# SPDX-License-Identifier: MIT

I2C_BUS=$1
print_breg ()
{
   EN=`i2cget -y -f $I2C_BUS 0x4b $2`
   VOLT=`i2cget -y -f $I2C_BUS 0x4b $3`
   VOLT=$(($VOLT))
   if [ $VOLT -le $((0xef)) ]
   then
	VOLT=$(($VOLT*6250+500000))	
   else
	VOLT=2000000
   fi
   EN=$(($EN & 0x8))
   if [ $EN -ne 0 ]
   then
      EN=enabled
   else
      EN=disabled
   fi
   echo $1 $EN $VOLT
} 

print_breg3 ()
{
   EN=`i2cget -y -f $I2C_BUS 0x4b $2`
   VOLT=`i2cget -y -f $I2C_BUS 0x4b $3`
   VOLT=$(($VOLT & 0x1f))
   if [ $VOLT -le $((0x0f)) ]
   then
	VOLT=$(($VOLT*50000+1200000))	
   else
	VOLT=2000000
   fi
   EN=$(($EN & 0x8))
   if [ $EN -ne 0 ]
   then
      EN=enabled
   else
      EN=disabled
   fi
   echo $1 $EN $VOLT
} 

print_breg4 ()
{
   EN=`i2cget -y -f $I2C_BUS 0x4b $2`
   VOLT=`i2cget -y -f $I2C_BUS 0x4b $3`
   VOLT=$(($VOLT & 0x3f))
   if [ $VOLT -le $((0x0f)) ]
   then
	VOLT=$(($VOLT*25000+1000000))	
   else
	VOLT=1800000
   fi
   EN=$(($EN & 0x8))
   if [ $EN -ne 0 ]
   then
      EN=enabled
   else
      EN=disabled
   fi
   echo $1 $EN $VOLT
} 

print_breg5 ()
{
   EN=`i2cget -y -f $I2C_BUS 0x4b $2`
   VOLT=`i2cget -y -f $I2C_BUS 0x4b $3`
   VOLT=$(($VOLT & 0x1f))
   if [ $VOLT -le $((0x0f)) ]
   then
	VOLT=$(($VOLT*50000+2500000))	
   else
	VOLT=3300000
   fi
   EN=$(($EN & 0x8))
   if [ $EN -ne 0 ]
   then
      EN=enabled
   else
      EN=disabled
   fi
   echo $1 $EN $VOLT
} 

print_lreg ()
{
   EN=`i2cget -y -f $I2C_BUS 0x4b $2`
   VOLT=`i2cget -y -f $I2C_BUS 0x4b $3`
   VOLT=$(($VOLT & 0x3f))
   if [ $VOLT -le $((0x31)) ]
   then
	VOLT=$(($VOLT*50000+800000))	
   else
	VOLT=3300000
   fi
   EN=$(($EN & 0x8))
   if [ $EN -ne 0 ]
   then
      EN=enabled
   else
      EN=disabled
   fi
   echo $1 $EN $VOLT
} 

print_breg buck1 0x08 0xd
print_breg buck2 0x12 0x17

print_breg3 buck3 0x1c 0x1e
print_breg4 buck4 0x1f 0x21
print_breg5 buck5 0x22 0x24

print_breg buck6 0x25 0x2a
print_breg buck7 0x2f 0x34

for I in 0 1 2 3 
do
   print_lreg ldo$(($I+1)) $((0x39+2*$I)) $((0x3a+2*$I))
done

print_lreg ldo5 0x41 0x43
EN=`i2cget -y -f $I2C_BUS 0x4b 0x44`
EN=$(($EN & 0x8))
if [ $EN -ne 0 ]
then
   EN=enabled
else
   EN=disabled
fi
echo ldo6 $EN 1800000
print_lreg ldo7 0x45 0x46
