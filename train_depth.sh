#!/usr/bin/env sh
set -e

# USAGE
# no command-line arguments will build a new net
# a number will resume build from iteration xx
# ie:
#	~$ ./train_depth.sh 2134


TOOLS=~/Caffe/build/tools

NOW=$(date +"%m%d%y%T")
#AMP = %26

echo "$NOW & then"

if [ $# -gt 0]; then
	echo "Resuming training from iteration $1"
	$TOOLS/caffe train --solver=./depth_solver.prototxt \
		--snapshot snapshots/depth_iter_$1.solverstate
else
#	GLOG_logtostderr=1 \
#		$TOOLS/caffe train --solver=./depth_solver.prototxt \
#		|%26 tee train_depth_2.log $@
	echo ""
	echo "Copy and run the following: "
	echo "$TOOLS/caffe train --solver=./depth_solver.prototxt |& tee logs/train_depth.$NOW.log $@"

fi
