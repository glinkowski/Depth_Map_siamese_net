#!/bin/bash
set -e

# Draw .png of each model, place in the root folder

PYLOC=~/Caffe/python

NET1=depth_siamese
NET2=depth_fuse
NET3=depth_single

TTSUFFIX=_train_test
DEVSUFFIX=_deploy


# Draw the train/test networks
python $PYLOC/draw_net.py ./$NET1$TTSUFFIX.prototxt ./$NET1$TTSUFFIX.png
python $PYLOC/draw_net.py ./$NET2$TTSUFFIX.prototxt ./$NET2$TTSUFFIX.png
python $PYLOC/draw_net.py ./$NET3$TTSUFFIX.prototxt ./$NET3$TTSUFFIX.png

# Draw the deploy networks
#TODO