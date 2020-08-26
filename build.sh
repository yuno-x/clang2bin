#!/bin/bash

OBJECTS=""
for INFILE in $@
do
  FNAME=`echo ${INFILE} | sed -e "s|\(.*\)\.[^.]*$|\1|g"`

  OBJECT="${FNAME}.o"
  OBJECTS="${OBJECTS} ${OBJECT}"

  gcc ${INFILE} -o ${OBJECT} -fno-freestanding -fno-common -fno-asynchronous-unwind-tables -fPIC -fPIE -fpack-struct -c
done

BINARY="`echo $1 | sed -e "s|\(.*\)\.[^.]*$|\1|g"`.img"
ld ${OBJECTS} -o ${BINARY} -nostdlib -Ttext=0x0 -e 0x00 --oformat binary -N
