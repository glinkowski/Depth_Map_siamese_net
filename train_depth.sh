#!/usr/bin/env sh
set -e

TOOLS=~/Caffe/build/tools

$TOOLS/caffe train --solver=./depth_solver.prototxt $@
