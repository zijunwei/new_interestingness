clear;
clc;
close all;

datasetup=setup();
addpath('~/Dev/ZFunc/')
IODir='IOs';

trainFiles=dir(fullfile(IODir,'actioncliptrain*.mat'));
trainFiles={trainFiles.name};
VideoEntropy(length(trainFiles))=struct('videoname',[],'entropy',[]);

for i=1:1:length(trainFiles)
   
    load(fullfile(IODir,[trainFiles{i}]));
    VideoEntropy(i).videoname=trainFiles{i}(1:end-4);
    VideoEntropy(i).entropy=IOScore;
    
    
end


save(fullfile(datasetup.gazeDatasetDir,'VideoIO_train.mat'),'VideoEntropy','-v7.3');