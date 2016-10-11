% prune VideoIO_train.mat to pick only the 35 videos
% date: 2016.10.10
clear;
clc;
close all;

addpath('~/Dev/ZFunc/')
load GregPick.mat
load VideoIO_train.mat

videoEntropyIdx= zeros(length(selectedVideoNames),1);
for i=1:1:length(videoEntropyIdx)
   videoEntropyIdx(i)= z_structfind(VideoEntropy,'videoname', selectedVideoNames{i});
   
end

VideoEntropy= VideoEntropy(videoEntropyIdx);