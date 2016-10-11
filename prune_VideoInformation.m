% prune VideoInformation.mat to contain only the 35 videos
% date: 2016.10.10

clear;
clc;
close all;

addpath('~/Dev/ZFunc/')
load GregPick.mat
load VideoInformation.mat   % (No longer exist)

videoIdx= zeros(length(selectedVideoNames),1);
for i=1:1:length(videoIdx)
   videoIdx(i)= z_structfind(VideoInformation,'videoname', selectedVideoNames{i});
   
end

VideoInformation= VideoInformation(videoIdx);
save('VideoInformation35.mat','VideoInformation')