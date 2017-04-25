#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12
# Modified from the Caffe example create_imagenet.sh

TOOLS=~/Caffe/build/tools

DIR=./lmdb_files

$TOOLS/compute_image_mean $DIR/depth_deploy_L_lmdb \
  $DIR/depth_deploy_L_mean.binaryproto
$TOOLS/compute_image_mean $DIR/depth_deploy_R_lmdb \
  $DIR/depth_deploy_R_mean.binaryproto

echo "Done."