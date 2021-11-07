#!/bin/bash

function printhelp()
{
      echo -e "usage: $0 [Sub Command]" >&2
      echo -e "" >&2
      echo -e "[Sub Command]" >&2
      #echo -e "  help [Sub Command]  Print Help about Sub Command." >&2
      echo -e "  help               Print Help." >&2
      echo -e "  version            Print version and lisence information." >&2
      echo -e "  build" >&2
      echo -e "  build32" >&2
      echo -e "  dump" >&2
      echo -e "  dump32" >&2

}

function  printversion()
{
      echo -e "$0 ver.0.90"
      echo -e "Copyright (C) 2021 Masanori Yuno (github: yuno-x)."
      echo -e "This is free software: you are free to change and redistribute it."
      echo -e "There is NO WARRANTY, to the extent permitted by law."
}

function binbuild()
{
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
}

function binbuild32()
{
  OBJECTS=""
  for INFILE in $@
  do
    FNAME=`echo ${INFILE} | sed -e "s|\(.*\)\.[^.]*$|\1|g"`

    OBJECT="${FNAME}.o"
    OBJECTS="${OBJECTS} ${OBJECT}"

    gcc ${INFILE} -o ${OBJECT} -fno-freestanding -fno-common -fno-asynchronous-unwind-tables -fPIC -fPIE -fpack-struct -m32 -c
  done

  BINARY="`echo $1 | sed -e "s|\(.*\)\.[^.]*$|\1|g"`.img"
  ld ${OBJECTS} -o ${BINARY} -nostdlib -Ttext=0x0 -e 0x00 --oformat binary -N -m elf_i386
}

function bindump()
{
  for INFILE in $@
  do
    objdump -D -b binary -M addr64,data64 -m i386:x86-64 ${INFILE}
  done
}

function bindump32()
{
  for INFILE in $@
  do
    objdump -D -b binary -M addr32,data32 -m i386 ${INFILE}
  done
}


SUBCMD=$1

case $SUBCMD in
  "help")
    printhelp
    ;;
  "version")
    printversion
    ;;
  "build")
    binbuild ${@:2}
    ;;
  "build32")
    binbuild32 ${@:2}
    ;;
  "dump")
    bindump ${@:2}
    ;;
  "dump32")
    bindump32 ${@:2}
    ;;
  *)
    printhelp
    ;;
esac
