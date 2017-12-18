#!/bin/bash
set -e

# Run a deploy model on an image

# The model and image to test
$MODEL=./depth_siamese_deploy.prototxt
$IMAGE=./deploy_images/00001.png
$SNAP=./snapshots_deep2/depth_siamese_iter_2100.caffemodel

# Necessary paths
$CLASS=~/Caffe/build/examples/cpp_classification/classification.bin

$MEAN=
$LABEL=


$CLASS $MODEL $SNAP $MEAN $LABEL $IMAGE