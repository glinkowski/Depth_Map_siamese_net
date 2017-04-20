#!/usr/bin/env sh
set -e

# USAGE
# no command-line arguments will build a new net
# a number will resume build from iteration xx
# ie:
#	~$ ./train_depth.sh 2134


TOOLS=~/Caffe/build/tools

if [ $# -gt 0]; then
	echo "Resuming training from iteration $1"
	$TOOLS/caffe train --solver=./depth_solver.prototxt \
		--snapshot snapshots/depth_iter_$1.solverstate
else
	GLOG_logtostderr=2 \
		$TOOLS/caffe train --solver=./depth_solver.prototxt $@
fi
