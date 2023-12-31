CamVid_PreProcess

% Specify the network image size. This is typically the same as the traing image sizes.
imageSize = [720/3 960/3 3];
% Specify the number of classes.
numClasses = numel(classes);
filterSize = 3;
numFilters = 32;


layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(filterSize,64,'DilationFactor',1,'Padding','same')
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(filterSize,64,'DilationFactor',1,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 1,'Padding','same');

    convolution2dLayer(filterSize,128,'DilationFactor',2,'Padding','same')
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(filterSize,128,'DilationFactor',2,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 1,'Padding','same');
    
    convolution2dLayer(filterSize,256,'DilationFactor',4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(filterSize,256,'DilationFactor',4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 1,'Padding','same');
     
    convolution2dLayer(1,numClasses)
    softmaxLayer
    pixelClassificationLayer('Classes',classes,'ClassWeights',classWeights)];

% options = trainingOptions('sgdm', ...
%     'MaxEpochs', 50, ...
%     'MiniBatchSize', 32, ... 
%     'InitialLearnRate', 1e-3);
pximdsVal = pixelLabelImageDatastore(imdsVal,pxdsVal);
% define optimizer
options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',15, ...
    'ExecutionEnvironment','parallel',...
    'MiniBatchSize',32,...
	'ValidationData',pximdsVal,...
    'Plots','training-progress',...
    'ValidationPatience', 4);
% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise',...
%     'LearnRateDropPeriod',10,...
%     'LearnRateDropFactor',0.3,...
%     'Momentum',0.9, ...
%     'InitialLearnRate',1e-3, ...
%     'ValidationData',pximdsVal,...
%     'MaxEpochs',15, ...  
%     'MiniBatchSize',16, ...
%     'Shuffle','every-epoch', ...
%     'CheckpointPath', tempdir, ...
%     'VerboseFrequency',2,...
%     'Plots','training-progress',...
%     'ValidationPatience', 4);

net = trainNetwork(pximdsTrain,layers,options);

Test