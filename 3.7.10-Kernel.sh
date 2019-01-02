#!/bin/bash
# -------------------------------------------------------
# Automatic preparation script for rtk_openwrt
# JC Yu,     Novenber 26,2015
# -------------------------------------------------------
# IMPORTANT:
#   When use: './<this script file>  '
# -------------------------------------------------------
TODAY=`date +"%Y-%m%d-%H%M"`
PPWW=${PWD}
WORK_NAME=KERNEL

VER=3.7.10
PNAME="origin"
## if PNAME is "origin", you don't need to prepare folder
## if PNAME is not "origin", you need to prepare PNAME-VER.tar.gz

KERNEL_NAME=linux-${VER}
KERNEL_FILE=${KERNEL_NAME}.tar.xz

if [[ "${PNAME}" == "origin" ]]; then
  KERNEL_NAME_PATCH=${KERNEL_NAME}
else
  KERNEL_NAME_PATCH=${KERNEL_NAME}-${PNAME}
fi

KERNEL_DIR="./${WORK_NAME}/${KERNEL_NAME_PATCH}"

PATCH_NAME=${PNAME}-${VER}
PATCH_GZ_FILE="./patches-gz/${PATCH_NAME}.tar.gz"
PATCH_DIR="${PPWW}/${WORK_NAME}/${PATCH_NAME}"
PATCH_LIST="${PATCH_DIR}/series"

echo "PPWW=${PPWW}"
echo "PWD=${PWD}"
echo "KERNEL_NAME=${KERNEL_NAME}"
echo "KERNEL_NAME_PATCH=${KERNEL_NAME_PATCH}"
echo "KERNEL_FILE=${KERNEL_FILE}"
echo "KERNEL_DIR=${KERNEL_DIR}"

echo "PATCH_NAME=${PATCH_NAME}"
echo "PATCH_GZ_FILE=${PATCH_GZ_FILE}"
echo "PATCH_DIR=${PATCH_DIR}"
echo "PATCH_LIST=${PATCH_LIST}"


TO_PREPARE_WORK="y"
if [[ "${TO_PREPARE_WORK}" == "y" ]]; then
	# Create Working DIR
	[ -d $WORK_NAME ] || mkdir $WORK_NAME

	if [ ! -f "./${WORK_NAME}/${KERNEL_FILE}" ]; then
	   echo $LINENO "Missing ./${WORK_NAME}/${KERNEL_FILE}"
	   echo $LINENO "Downloading ${KERNEL_FILE} form Internet"
	   wget  https://www.kernel.org/pub/linux/kernel/v3.x/${KERNEL_FILE} -P ./${WORK_NAME}/
    else
	   echo $LINENO "Downloaded ${KERNEL_FILE} form Interne"
	fi

fi

TO_MAKE_DIR="y"
if [[ "${TO_MAKE_DIR}" == "y" ]]; then
    echo $LINENO "Generating  ${KERNEL_DIR}"
	if [ ! -f "./${WORK_NAME}/${KERNEL_FILE}" ]; then
	   echo $LINENO "Missing ./${WORK_NAME}/${KERNEL_FILE}"
	   exit -1
	fi

	rm -rf ${KERNEL_DIR}
	[ -d $KERNEL_DIR ] || mkdir $KERNEL_DIR

	tar xvf ./${WORK_NAME}/${KERNEL_FILE} -C ${KERNEL_DIR}  --strip-components=1
fi

if [[ "${PNAME}" == "origin" ]]; then
    TO_DO_PATCH="n"
else
    TO_DO_PATCH="y"
fi

if [[ "${TO_DO_PATCH}" == "y" ]]; then
    echo $LINENO "About to patch:  ${KERNEL_DIR}"

	if [ ! -f "${PATCH_GZ_FILE}" ]; then
	   echo $LINENO "Missing ${PATCH_GZ_FILE}"
	   exit -1
	else
	echo $LINENO "Removing & Generating  ${PATCH_DIR}"
	rm -rf ${PATCH_DIR}
	[ -d $PATCH_DIR ] || mkdir $PATCH_DIR
	    echo $LINENO "Tar the folder"
		tar zxvf ${PATCH_GZ_FILE} -C ${PATCH_DIR}  --strip-components=1
	fi

	if [ ! -f "${PATCH_LIST}" ]; then
	   echo $LINENO "Missing ${PATCH_LIST}"
	   exit -1
	else
	   echo $LINENO "Change Folder=${KERNEL_DIR}"
	   cd ${KERNEL_DIR}
	   for p in $(cat ${PATCH_LIST} );
	    do
	      echo "Patching::${p}"
	      patch -p1 <  "${PATCH_DIR}/${p}"
	    done
	   cd ${PPWW}
	fi
fi

