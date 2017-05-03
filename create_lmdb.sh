#!/usr/bin/env sh
# Create the lmdb inputs for stereo depth map siamese CNN
#   3 inputs: Left, Right, Ground Truth
# Modified from the Caffe example create_imagenet.sh
set -e



#NOTE: DO NOT use the shuffle flag. Image triplets must match;
#       shuffling is handled by pre-processing script.
#NOTE: pre-processed images currently sized 370x675, near 16:9

#TARGET=demo_lmdb_files
#SOURCE=demo_prepped_images
TARGET=lmdb_files
SOURCE=prepped_images
TOOLS=~/Caffe/build/tools

BACKEND="lmdb"

# Set RESIZE=true to resize the images to 256x512. Leave as false if images have
# already been resized using another tool.
RESIZE=false
if $RESIZE; then
#  RESIZE_HEIGHT=256
#  RESIZE_WIDTH=512
  RESIZE_HEIGHT=64
  RESIZE_WIDTH=128
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

GRAYSCALE=true



# Warn if any of the directories can't be found
if [ ! -d "$TARGET" ]; then
  echo "Error: TARGET is not a path to a directory: $TARGET"
  echo "Set the TARGET variable in create_lmdb.sh to the output path" \
       "or create folder to store lmdb files."
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Error: SOURCE is not a path to a directory: $SOURCE"
  echo "Set the SOURCE variable in create_lmdb.sh to the path" \
       "where the pre-processed images are stored."
  exit 1
fi

if [ ! -d "$TOOLS" ]; then
  echo "Error: TOOLS is not a path to a directory: $TOOLS"
  echo "Set the TOOLS variable in create_lmdb.sh to the path" \
       "where the Caffe file convert_imageset is stored."
  echo "Ensure 'make tools' was run in the Caffe directory."
  exit 1
fi



# Delete lmdb files/folders if already exist
rm -rf $TARGET/depth_train_L_$BACKEND
rm -rf $TARGET/depth_train_R_$BACKEND
rm -rf $TARGET/depth_train_GT_$BACKEND
rm -rf $TARGET/depth_test_L_$BACKEND
rm -rf $TARGET/depth_test_R_$BACKEND
rm -rf $TARGET/depth_test_GT_$BACKEND
rm -rf $TARGET/depth_deploy_L_$BACKEND
rm -rf $TARGET/depth_deploy_R_$BACKEND
rm -rf $TARGET/depth_deploy_GT_$BACKEND



echo "\nCreating 3 train lmdb sets..."
echo "    (one each: Left, Right, Ground Truth)\n"

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestTrainL.txt \
    $TARGET/depth_train_L_$BACKEND

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestTrainR.txt \
    $TARGET/depth_train_R_$BACKEND

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestTrainGT.txt \
    $TARGET/depth_train_GT_$BACKEND



echo "\nCreating 3 validation lmdb sets..."
echo "    (one each: Left, Right, Ground Truth)\n"

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestTestL.txt \
    $TARGET/depth_test_L_$BACKEND

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestTestR.txt \
    $TARGET/depth_test_R_$BACKEND

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestTestGT.txt \
    $TARGET/depth_test_GT_$BACKEND

    
echo "\nCreating deploy lmdb sets..."
echo "    (one each: Left, Right, Ground Truth)\n"

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestDeployL.txt \
    $TARGET/depth_deploy_L_$BACKEND

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestDeployR.txt \
    $TARGET/depth_deploy_R_$BACKEND

echo ""
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --backend=$BACKEND \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle=false \
    --gray=$GRAYSCALE \
    $SOURCE \
    $SOURCE/manifestDeployGT.txt \
    $TARGET/depth_deploy_GT_$BACKEND



echo "Done."