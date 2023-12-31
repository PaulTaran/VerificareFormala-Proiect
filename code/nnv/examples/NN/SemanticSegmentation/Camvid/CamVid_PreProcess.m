% outputFolder = fullfile('/home/neelanjana/MATLAB/nnv/code/nnv/examples/NN/CNN/Camvid_dilatedCNN'); 
% labelsZip = fullfile(outputFolder,'LabeledApproved_full.zip');
% imagesZip = fullfile(outputFolder,'701_StillsRaw_full.zip');
% unzip(labelsZip, fullfile(outputFolder,'labels'));
% unzip(imagesZip, fullfile(outputFolder,'images')); 

% Specify the network image size. This is typically the same as the traing image sizes.
inputSize = [720/3 960/3];

% imgDir = fullfile(outputFolder,'images','701_StillsRaw_full');
imgDir = fullfile('images','701_StillsRaw_full');
imds = imageDatastore(imgDir);
%resize datastore
imds.ReadFcn = @(loc)imresize(imread(loc),inputSize);
% % Display one of the images.
% I = readimage(imds,1);
% I = histeq(I);
% imshow(I)

% Load CamVid Pixel-Labeled Images
classes = [
    "Sky"
    "Building"
    "Pole"
    "Road"
    "Pavement"
    "Tree"
    "SignSymbol"
    "Fence"
    "Car"
    "Pedestrian"
    "Bicyclist"
    ];
labelIDs = camvidPixelLabelIDs();

% Use the classes and label IDs to create the pixelLabelDatastore.
%labelDir = fullfile(outputFolder,'labels');
labelDir = fullfile('labels');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
pxds.ReadFcn = @(loc)imresize(imread(loc),inputSize); 

% % Read and display one of the pixel-labeled images by overlaying it on top of an image.
% C = readimage(pxds,1);
% cmap = camvidColorMap;
% B = labeloverlay(I,C,'ColorMap',cmap);
% imshow(B)
% pixelLabelColorbar(cmap,classes);

% Prepare Training, Validation, and Test Sets
[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partitionCamVidData(imds,pxds);
imdsTrain.ReadFcn = @(loc)imresize(imread(loc),inputSize);
imdsVal.ReadFcn = @(loc)imresize(imread(loc),inputSize);
imdsTest.ReadFcn = @(loc)imresize(imread(loc),inputSize);
pxdsTrain.ReadFcn = @(loc)imresize(imread(loc),inputSize);
pxdsVal.ReadFcn = @(loc)imresize(imread(loc),inputSize);
pxdsTest.ReadFcn = @(loc)imresize(imread(loc),inputSize);

% numTrainingImages = numel(imdsTrain.Files)
% numValImages = numel(imdsVal.Files)
% numTestingImages = numel(imdsTest.Files)

% Create Semantic Segmentation Network
% Create a data source for training data and get the pixel counts for each label.
pximdsTrain = pixelLabelImageDatastore(imdsTrain,pxdsTrain);
tbl = countEachLabel(pximdsTrain)
numberPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / numberPixels;
classWeights = 1 ./ frequency;