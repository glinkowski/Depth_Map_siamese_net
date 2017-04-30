close all;

%% Plot the loss function over the value of the estimated (pixel) depth

pd = linspace(0.1, 0.9, 50);    % estimated depth values
pn = 0.75;     % avg value of neighbors
pt = 0.5;       % the ground-truth pixel

gamma = .4;    % How much to weight the neighborhood

epsilon = 0.1;  % ignore difference < epsilon

% Compare to neighborhood
Lh = abs( pd - pn ).^2;
% Compare to ground truth
Lt = abs( pd - pt ).^2;
% Combined loss
Lc = (1-gamma) * Lt + (gamma) * Lh;

figure();
plot(pd, Lc, pd, Lt, pd, Lh)


%% Plot loss over grid of pd & pn

psize = 101;

pd = linspace(0, 1, psize);   % estimated depth values
pn = linspace(0, 1, psize);   % avg value of neighbors
pt = 0.5;                   % the ground-truth pixel


% Reshape into 2d grid
pdGrid = repmat(pn, psize, 1);
pn = reshape(pn, psize, 1);
pnGrid = repmat(pn, 1, psize);

% Compare to neighborhood
Lh = abs( pdGrid - pnGrid ).^2;
% Compare to ground truth
Lt = abs( pdGrid - pt ).^2;
% Combined loss
Lc = (1-gamma) * Lt + (gamma) * Lh;

figure();
%plot(pd, Lc, pd, Lt, pd, Lh)
mesh(pdGrid, pnGrid, Lc);
xlabel('depth estimation');
ylabel('neighborhood average');


%% Compare losses between two images

% Load a ground truth image
gtFile = '../demo_prepped_images/example-00001GT.png';
gtImg = imread(gtFile);
%gtImg = im2uint8(gtImg);            % Expected range [0, 256]
%gtImg2 = gtImg .* 0.0039; % Convert to [0, 1]
gtImg = im2double(gtImg);
gtImg = imresize(gtImg, [128, 256]);
gtImg = gtImg - mean(mean(gtImg)) + 0.5;    % Center around 0.5

% Create an image of noise
noise1 = ones(128, 256) .* 0.5;
noise1 = imnoise(noise1, 'speckle', 0.01);

noise2 = abs(noise1 - 0.5);

nullIm = zeros(128, 256);

noise4 = imnoise(gtImg, 'speckle', 0.01);

nullIm2 = ones(128, 256) .* 0.55;

shiftIm = gtImg + 0.05;

% Get Euclidian distance
%eLoss1 = pdist2(noise1, gtImg);
%eLoss2 = pdist2(noise2, gtImg);

eLoss1 = sqrt(sum(sum( (noise1 - gtImg).^2 )));
eLoss2 = sqrt(sum(sum( (noise2 - gtImg).^2 )));
eLoss3 = sqrt(sum(sum( (nullIm - gtImg).^2 )));
eLoss4 = sqrt(sum(sum( (noise4 - gtImg).^2 )));
eLoss5 = sqrt(sum(sum( (nullIm2 - gtImg).^2 )));
eLoss6 = sqrt(sum(sum( (shiftIm - gtImg).^2 )));

H = [0 .25 0; .25 0 .25; 0 .25 0];
%NOTE: this approach still affects the edges
% To see this, run: V = ones(3, 3).*0.5; conv2(V, H, 'same')
nbAv1 = conv2(noise1, H, 'same');
nLoss1 = sum(sum( (1 - gamma).*(abs(noise1 - gtImg).^2) + (gamma).*(abs(noise1 -  nbAv1).^2) ));
nbAv2 = conv2(noise2, H, 'same');
nLoss2 = sum(sum( (1 - gamma).*(abs(noise2 - gtImg).^2) + (gamma).*(abs(noise2 -  nbAv2).^2) ));
nbAv3 = conv2(nullIm, H, 'same');
nLoss3 = sum(sum( (1 - gamma).*(abs(nullIm - gtImg).^2) + (gamma).*(abs(nullIm -  nbAv3).^2) ));
nbAv4 = conv2(noise4, H, 'same');
nLoss4 = sum(sum( (1 - gamma).*(abs(noise4 - gtImg).^2) + (gamma).*(abs(noise4 -  nbAv4).^2) ));
nbAv5 = conv2(nullIm2, H, 'same');
nLoss5 = sum(sum( (1 - gamma).*(abs(nullIm2 - gtImg).^2) + (gamma).*(abs(nullIm2 -  nbAv5).^2) ));
nbAv6 = conv2(shiftIm, H, 'same');
nLoss6 = sum(sum( ((1 - gamma).*(abs(shiftIm - gtImg).^2)) + ((gamma).*(abs(shiftIm -  nbAv6).^2)) ));

tText = sprintf('tests performed : noise 0.5, noise 0, flat 0, noise GT, flat N, shift GT');
eText = sprintf('Euclidian Losses: %0.5f, %0.5f, %0.5f, %0.5f, %0.5f, %0.5f ', eLoss1, eLoss2, eLoss3, eLoss4, eLoss5, eLoss6);
nText = sprintf('Newly defined Lc: %0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %0.3f ', nLoss1, nLoss2, nLoss3, nLoss4, nLoss5, nLoss6);
disp(tText);
disp(eText);
disp(nText);


% Normalize error such that L(flat 0 image) = 1
eText = sprintf('Euclidian Losses: %0.5f, %0.5f, %0.5f, %0.5f, %0.5f, %0.5f ', eLoss1/eLoss3, eLoss2/eLoss3, eLoss3/eLoss3, eLoss4/eLoss3, eLoss5/eLoss3, eLoss6/eLoss3);
nText = sprintf('Newly defined Lc: %0.5f, %0.5f, %0.5f, %0.5f, %0.5f, %0.5f ', nLoss1/nLoss3, nLoss2/nLoss3, nLoss3/nLoss3, nLoss4/nLoss3, nLoss5/nLoss3, nLoss6/nLoss3);
disp(eText);
disp(nText);


%{
%% Load an image and get the euclidian distance loss
        
gtFile = '../demo_prepped_images/example-00001GT.png';
gtImg = imread(gtFile);
%gtImg = im2uint8(gtImg) .* 0.0039;
gtImg = im2uint8(gtImg);
gtImg = imresize(gtImg, [128, 256]);

figure();
imshow(gtImg)

elFile = '../output/EuclidLoss.png';
elImg = imread(elFile);

%elImg = rgb2gray(elImg) .* 0.0039;
elImg = rgb2gray(elImg);
elImg = imresize(elImg, [32, 64]);    % Because this is a screen-grab
%TODO: get actual output as a file
elImg = imresize(elImg, [128, 256]);

figure();
imshow(elImg)
%}