disp('======= Prepare train & test data from KITTI datasets =======');
clear all; close all; dbstop error;

%% Image creation & modification flags & parameters

% Run test on small set of images
doUseDemoData = false;

% Which sets of images to create (will need all)
doCreateLeftImages = true;
doCreateRightImages = true;
doCreateGroundTruthImages = true;

% Apply the dilation morphology to ground truth
doDilateGroundTruth = true;
%dilator = ones(3, 3);
dilator = strel('sphere', 2);

% Create flipped versions of the training images
doFlipImages = true;

% Convert the color training images to grayscale
doUseGrayscale = true;

% Shuffle the order of the images in the manifest files
doShuffle = true;

% Size to which to crop images (in pixels)
cropH = 370;
cropW = 2 * cropH;
cropL = floor(cropW / 2);
cropR = cropL + cropW - 1;

% Percent of total images to set aside for testing/validation
tstPerc = 10;

% Target output directory
if doUseDemoData
    outDir = '../demo_prepped_images/';
else
    outDir = '../prepped_images/';
end

% The label to put into the manifest (text file)
%   NOTE: the label value doesn't matter, will use a loss function
placeLabel = 0;


%% Copy training images into target folder
% Start with the KITTI 2015 dataset
disp('======= Formatting images from KITTI 2015 =======');

if doUseDemoData
    lDir = '../demo_KITTI_2015/training/image_2/';
    rDir = '../demo_KITTI_2015/training/image_3/';
    gt10Dir = '../demo_KITTI_2015/training/disp_occ_0/';
else
    lDir = '../KITTI_2015/training/image_2/';
    rDir = '../KITTI_2015/training/image_3/';
    gt10Dir = '../KITTI_2015/training/disp_occ_0/';
end

% Copy all (_10) Left images
if doCreateLeftImages
    files = dir(strcat(lDir, '*_10.png'));
    newIdx = 1;
    for index = 1:length(files)
    %for index = 1:2

        [~, fname] = fileparts(files(index).name);
        sName = strcat(lDir, fname, '.png');
    %    tName = strcat(tDir, num2str(index-1, '%05d'), 'L.png');
    %    copyfile(sName, tName);
        I = imread(sName);
        
        % Convert the image to grayscale
        if doUseGrayscale
            Isize = size(I);
            if (length(Isize) == 3)
                if (Isize(3) == 3);
                    I = rgb2gray(I);
                end
            end
        end

        %{
        % Split in half, ratio 5:3
        IL = I((Isize(1)-369):Isize(1), 1:675, :);
        IR = I((Isize(1)-369):Isize(1), (Isize(2)-674):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
        newIdx = newIdx + 2;
        %}
        
        % Crop into 3 images
        IL = I( (Isize(1)-cropH+1):Isize(1), 1:cropW, :);
        IC = I( (Isize(1)-cropH+1):Isize(1), cropL:cropR, :);
        IR = I( (Isize(1)-cropH+1):Isize(1), (Isize(2)-cropW+1):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
        imwrite(IC, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+2, '%05d'), 'L.png'));
        newIdx = newIdx + 3;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            ICflip = fliplr(IC);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
            imwrite(ICflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+2, '%05d'), 'R.png'));
            newIdx = newIdx + 3;
        end

    end %for files
end %if create Left

% Copy all (_10) Right images
if doCreateRightImages
    files = dir(strcat(rDir, '*_10.png'));
    newIdx = 1;
    for index = 1:length(files)
    %for index = 1:2

        [~, fname] = fileparts(files(index).name);
        sName = strcat(rDir, fname, '.png');
    %    tName = strcat(tDir, num2str(index-1, '%05d'), 'R.png');
    %    copyfile(sName, tName);
        I = imread(sName);
        
        % Convert the image to grayscale
        if doUseGrayscale
            Isize = size(I);
            if (length(Isize) == 3)
                if (Isize(3) == 3);
                    I = rgb2gray(I);
                end
            end
        end

        %{
        % Split in half, ratio 5:3
        IL = I((Isize(1)-369):Isize(1), 1:675, :);
        IR = I((Isize(1)-369):Isize(1), (Isize(2)-674):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
        newIdx = newIdx + 2;
        %}

        
        % Crop into 3 images
        IL = I( (Isize(1)-cropH+1):Isize(1), 1:cropW, :);
        IC = I( (Isize(1)-cropH+1):Isize(1), cropL:cropR, :);
        IR = I( (Isize(1)-cropH+1):Isize(1), (Isize(2)-cropW+1):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
        imwrite(IC, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+2, '%05d'), 'R.png'));
        newIdx = newIdx + 3;
        
        
        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            ICflip = fliplr(IC);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
            imwrite(ICflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+2, '%05d'), 'L.png'));
            newIdx = newIdx + 3;
        end

    end %for files
end %if create Right

% Copy all (_10) Ground Truth images
if doCreateGroundTruthImages
    files = dir(strcat(gt10Dir, '*.png'));
    newIdx = 1;
    for index = 1:length(files)
    %for index = 1:2

        [~, fname] = fileparts(files(index).name);
        sName = strcat(gt10Dir, fname, '.png');
    %    tName = strcat(tDir, num2str(index-1, '%05d'), 'GT.png');
    %    copyfile(sName, tName);
        I = imread(sName);
        Isize = size(I);

        if doDilateGroundTruth
            I = imdilate(I, dilator);
        end

        %{
        % Split in half, ratio 5:3
        IL = I((Isize(1)-369):Isize(1), 1:675, :);
        IR = I((Isize(1)-369):Isize(1), (Isize(2)-674):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
        newIdx = newIdx + 2;
        %}
        
        % Crop into 3 images
        IL = I( (Isize(1)-cropH+1):Isize(1), 1:cropW, :);
        IC = I( (Isize(1)-cropH+1):Isize(1), cropL:cropR, :);
        IR = I( (Isize(1)-cropH+1):Isize(1), (Isize(2)-cropW+1):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
        imwrite(IC, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+2, '%05d'), 'GT.png'));
        newIdx = newIdx + 3;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            ICflip = fliplr(IC);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
            imwrite(ICflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+2, '%05d'), 'GT.png'));
            newIdx = newIdx + 3;
        end

    end %for files
end %if create GT

%{
% Copy all even Ground Truth images
files = dir(strcat(gt11Dir, '*.png'));
newIdx = 2;
for index = 1:length(files)
%for index = 1:2
    
    [~, fname] = fileparts(files(index).name);
    sName = strcat(gt11Dir, fname, '.png');
    tName = strcat(tDir, num2str(newIdx-1, '%05d'), 'GT.png');
    copyfile(sName, tName);
    
    newIdx = newIdx + 2;
end
%}


%% Copy training images into target folder
% Continue with the KITTI 2012 dataset
disp('======= Formatting images from KITTI 2012 =======');

startIdx = newIdx;

if doUseDemoData
    dirPrefix = '../demo_KITTI_2012/training/';
else
    dirPrefix = '../KITTI_2012/training/';
end

if doUseGrayscale
    lDir = strcat( dirPrefix, 'image_0/' );
    rDir = strcat( dirPrefix, 'image_1/' );
else
    lDir = strcat( dirPrefix, 'colored_0/' );
    rDir = strcat( dirPrefix, 'colored_1/' );
end    
gt10Dir = strcat( dirPrefix, 'disp_occ/' );

% Copy all (_10) Left images
if doCreateLeftImages
    files = dir(strcat(lDir, '*_10.png'));
    newIdx = startIdx;
    for index = 1:length(files)

        [~, fname] = fileparts(files(index).name);
        sName = strcat(lDir, fname, '.png');
        I = imread(sName);
        
        % Convert the image to grayscale
        if doUseGrayscale
            Isize = size(I);
            if (length(Isize) == 3)
                I = rgb2gray(I);
                %{
                if (Isize(3) == 3);
                    I = rgb2gray(I);
                end
                %}
            end
        end

        %{
        % Split in half, ratio 5:3
        IL = I(:, 1:675, :);
        IR = I(:, 552:1226, :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
        newIdx = newIdx + 2;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
            newIdx = newIdx + 2;
        end
        %}
        
        % Crop into 3 images
        IL = I( (Isize(1)-cropH+1):Isize(1), 1:cropW, :);
        IC = I( (Isize(1)-cropH+1):Isize(1), cropL:cropR, :);
        IR = I( (Isize(1)-cropH+1):Isize(1), (Isize(2)-cropW+1):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
        imwrite(IC, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+2, '%05d'), 'L.png'));
        newIdx = newIdx + 3;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            ICflip = fliplr(IC);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
            imwrite(ICflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+2, '%05d'), 'R.png'));
            newIdx = newIdx + 3;
        end

    end %for files
end %if create Left

% Copy all (_10) Right images
if doCreateRightImages
    files = dir(strcat(rDir, '*_10.png'));
    newIdx = startIdx;
    for index = 1:length(files)

        [~, fname] = fileparts(files(index).name);
        sName = strcat(rDir, fname, '.png');
        I = imread(sName);
        
        % Convert the image to grayscale
        if doUseGrayscale
            Isize = size(I);
            if (length(Isize) == 3)
                I = rgb2gray(I);
                %{
                if (Isize(3) == 3);
                    I = rgb2gray(I);
                end
                %}
            end
        end

        %{
        % Split in half, ratio 5:3
        IL = I(:, 1:675, :);
        IR = I(:, 552:1226, :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
        newIdx = newIdx + 2;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
            newIdx = newIdx + 2;
        end
        %}

        
        % Crop into 3 images
        IL = I( (Isize(1)-cropH+1):Isize(1), 1:cropW, :);
        IC = I( (Isize(1)-cropH+1):Isize(1), cropL:cropR, :);
        IR = I( (Isize(1)-cropH+1):Isize(1), (Isize(2)-cropW+1):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'R.png'));
        imwrite(IC, strcat(outDir, num2str(newIdx+1, '%05d'), 'R.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+2, '%05d'), 'R.png'));
        newIdx = newIdx + 3;
        
        
        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            ICflip = fliplr(IC);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'L.png'));
            imwrite(ICflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'L.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+2, '%05d'), 'L.png'));
            newIdx = newIdx + 3;
        end

    end %for files
end %if create Right

% Copy all (_10) Ground Truth images
if doCreateGroundTruthImages
    files = dir(strcat(gt10Dir, '*.png'));
    newIdx = startIdx;
    for index = 1:length(files)

        [~, fname] = fileparts(files(index).name);
        sName = strcat(gt10Dir, fname, '.png');
        I = imread(sName);
        Isize = size(I);

        if doDilateGroundTruth
            I = imdilate(I, dilator);
        end

        %{
        % Split in half, ratio 5:3
        IL = I(:, 1:675, :);
        IR = I(:, 552:1226, :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
        newIdx = newIdx + 2;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
            newIdx = newIdx + 2;
        end
        %}
        
        % Crop into 3 images
        IL = I( (Isize(1)-cropH+1):Isize(1), 1:cropW, :);
        IC = I( (Isize(1)-cropH+1):Isize(1), cropL:cropR, :);
        IR = I( (Isize(1)-cropH+1):Isize(1), (Isize(2)-cropW+1):Isize(2), :);
        imwrite(IL, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
        imwrite(IC, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
        imwrite(IR, strcat(outDir, num2str(newIdx+2, '%05d'), 'GT.png'));
        newIdx = newIdx + 3;

        % Flip training files
        if doFlipImages
            ILflip = fliplr(IR);
            ICflip = fliplr(IC);
            IRflip = fliplr(IL);
            imwrite(IRflip, strcat(outDir, num2str(newIdx, '%05d'), 'GT.png'));
            imwrite(ICflip, strcat(outDir, num2str(newIdx+1, '%05d'), 'GT.png'));
            imwrite(ILflip, strcat(outDir, num2str(newIdx+2, '%05d'), 'GT.png'));
            newIdx = newIdx + 3;
        end

    end %for files
end %if create GT


%% Write the labels file for convert_imagespace
disp('======= Writing the image manifest files  =======');

imgCount = newIdx - 1;

if doShuffle
    imgIdx = randperm(imgCount);
else
    imgIdx = 1:imgCount;
end

trnCount = ceil(imgCount * (100 - tstPerc) / 100);
trnMan = imgIdx(1:trnCount);
tstCount = floor(imgCount * tstPerc / 100);
tstMan = imgIdx((trnCount+1):imgCount);

suffix = {'L', 'R', 'GT'};
for i = 1:3
    lineFormat = strcat('/%05d', char(suffix(i)), '.png', 32, num2str(placeLabel), '\n');
    
    fID = fopen( strcat(outDir, 'manifestTrain', char(suffix(i)), '.txt'), 'w' );
    fprintf(fID, lineFormat, trnMan);
    fclose(fID);
    
    fID = fopen( strcat(outDir, 'manifestTest', char(suffix(i)), '.txt'), 'w' );
    fprintf(fID, lineFormat, tstMan);
    fclose(fID);
end
    

disp('Fin.');