#!/bin/bash
# Needed packages
# dpkg -l | grep libavcodec-extra-53 | wc -l
# avconv

# Size
S=hd720

# Bitrate
B=6000k

INFILE=$1
FILENAME=$INFILE
OUTFILE=
OUTDIR=`pwd`

args=`getopt s:b:i:o: $*`
if [ $? != 0 -o $# -lt 1 ] ; then
	echo "ERROR: Incorrect or too few arguments found"
	exit
fi
set -- $args
for i; do
  case "$i" in
    -s)
        S=$2
        [[ ! $S =~ hd480|hd720|hd1080 ]] && {
            echo "Incorrect size given: $S"
	    echo "Possible values [hd480|hd720|hd1080]"
            exit 1
        }
	shift; shift ;;
    -b)
        B=$2
	shift; shift ;;
    -i)
        INFILE=$2
	shift; shift ;;
    -o)
        OUTFILE=$2
	shift; shift ;;
    --  ) shift; break ;;
  esac
done

echo $args

if [ ! -z "$OUTFILE" ]; then
	OUTDIR=`dirname $OUTFILE`
	FILENAME=`basename $OUTFILE`
	echo "OUTDIR: $OUTDIR"

	if [ ! -d "$OUTDIR" ]; then
		mkdir -p $OUTDIR
	fi
fi

OUTFILE=${OUTDIR}/${FILENAME%.*}_${B}_${S}_$(date +%F_%H%M).mp4

echo "B = $B"
echo "S = $S"
echo "INFILE = $INFILE"
echo "FILENAME = $FILENAME"
echo "OUTFILE = $OUTFILE"

avconv -i $INFILE -b:v $B -s $S -strict experimental $OUTFILE
if [ $? == 0 ] ; then
	echo "File converted and could be found here:"
	echo "  $OUTFILE"
fi
