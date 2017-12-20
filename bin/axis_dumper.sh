#!/bin/bash
SRC_DIR=$HOME/tmp/axis
DST_DIR=$HOME/tmp/axis_backup

NEXT_DIR=$(date --date='1 hour ago' +"%Y-%m-%d-%H")
HOUR=$(date --date='1 hour ago' +"%H")

if [ ! -d $SRC_DIR ]; then
	mkdir $SRC_DIR
fi

if [ ! -d $DST_DIR ]; then
	mkdir $DST_DIR
fi

if [ ! -d $SRC_DIR/$NEXT_DIR ]; then
	echo "ERROR: Could not find $SRC_DIR/$NEXT_DIR"
	exit
fi

cd $SRC_DIR/$NEXT_DIR

ENC_CMD="mencoder "mf://*.jpg" -mf fps=20 -o $DST_DIR/$NEXT_DIR.avi -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=1400"
echo $ENC_CMD
$ENC_CMD

rm -rf $SRC_DIR/$NEXT_DIR
