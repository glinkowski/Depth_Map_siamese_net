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
	$TOOLS/caffe train --solver=./depth_solver_single.prototxt \
		--snapshot snapshots/depth_iter_$1.solverstate
else
	GLOG_logtostderr=1 \
		$TOOLS/caffe train --solver=./depth_solver_single.prototxt \
		--log_dir=logs_glog/single \
#		|\& tee -i train_depth_single_$NOW.log $@

#	echo ""
#	echo "Copy and run the following: "
#	echo "$TOOLS/caffe train --solver=./depth_solver.prototxt |& tee -i logs/train_depth.$NOW.log $@"

fi
