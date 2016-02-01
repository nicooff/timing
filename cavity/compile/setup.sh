#!/bin/bash
# script to compile nek_p4est for given setup
SETUP=cavity
# commands
cp_cmd=cp
mv_cmd=mv
rm_cmd=rm
# paths
NEK_HOME=/lscratch/nof/nek5_svn/trunk/nek
#modified files
NEKFILES=''
INCFILES='SIZE_DEF NEKUSE_DEF TSTEP_DEF CTIMER_DEF PARALLEL_DEF'
# makenek variables
F77="mpif77"
export F77
CC="mpicc"
export CC
PPLIST=""
export PPLIST
USR=""
export USR
USR_LFLAGS=""
export USR_LFLAGS
# enable MPI (default true)
#IFMPI="false"
#export IFMPI
#F77="gfortran"
#CC="gcc"
#USR_LFLAGS="-L./ -larpack_gcc_rst"

# arguments
args=("$@")
argsnr=$#

case "${args[0]}" in
    copy_src)
# create local source copy
        ${cp_cmd} -rp ${NEK_HOME} ./
        ;;
    compile)
# compile 
# copy modified files
        for i in ${NEKFILES}; do
            echo ${i}
            ${cp_cmd} ./src/${i} ./nek/
        done
# copy include files
        for i in ${INCFILES}; do
            echo ${i}
            ${cp_cmd} ./src/${i} ./
        done
# copy .usr file
        ${cp_cmd} ./src/${SETUP}.f ./${SETUP}.usr
# compile the code
        ./makenek ${SETUP} ./nek
        mkdir -p bin
        ${mv_cmd} ./nek5000 ./bin
# clean directory

        ${rm_cmd} ${SETUP}.f ${SETUP}.usr makefile
        for i in ${INCFILES}; do
            ${rm_cmd} ./${i}
        done
        ;;
    clean)
# clean 
        ${rm_cmd} ./bin/nek5000
        ${rm_cmd} ./obj/*
        ;;
    clean_src)
# clean everything
        ${rm_cmd} -Rf ./nek ./obj
        ;;
    *) error_quit 'Wrong option'
        ;;
esac
