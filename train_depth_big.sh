#!/bin/bash
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
	$TOOLS/caffe train --solver=./depth_big_siamese_solver.prototxt \
		--snapshot snapshots/depth_iter_$1.solverstate \
		|& tee -i logs/train_depth_big_siamese_$NOW.log $@
else
#	GLOG_logtostderr=true \
#		GLOG_log_dir=logs_glog/single \
	$TOOLS/caffe train --solver=./depth_big_siamese_solver.prototxt \
		|& tee -i logs/train_depth_big_siamese_$NOW.log $@
fi
