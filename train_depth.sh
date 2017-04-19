#!/usr/bin/env sh
set -e

TOOLS=~/Caffe/build/tools

#$TOOLS/caffe train --solver=./depth_solver.prototxt $@
$TOOLS/caffe train --solver=./depth_solver.prototxt --snapshot snapshots/depth_iter_2614.solverstate $@
