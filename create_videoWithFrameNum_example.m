% create visualization format 1:
% draw the videos with frame number on top


clear;
clc;
close all

addpath('~/Dev/ZFunc');
addpath('~/Dev/ZFunc/Gaze')
addpath('~/Dev/ZFunc/export_figure/')
datasetup=setup();



fprintf('Loading IO scores...')

load(fullfile(datasetup.gazeDatasetDir,'VideoIO_train.mat'));
load('GregPick.mat');
full_list = {VideoEntropy.videoname};
random_pick=setdiff(full_list, selectedVideoNames);
random_pick=random_pick(1:5);

fprintf('Done.\n')


%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed




% add save path

VideoSavePath=fullfile(datasetup.gazeDatasetDir,'Exp1_35_example');
if ~exist(VideoSavePath,'dir')
    mkdir(VideoSavePath);
end
figure;
set(gcf,'visible','off');
warning off
% at most 16 users
% drawColors = z_distinguishable_colors(16);

% i=885, starting of training
% for i=1:1:5
for i=1:1:length(random_pick)
    %     entropyIdx=sortedIdx(i);
    
    
    videoIdx=z_structfind(VideoEntropy,'videoname',random_pick{i});
    ety=VideoEntropy(videoIdx).entropy;
    l_video=length(ety);
    
%     if l_video>500
%        continue; 
%     end
    
    fprintf('---processing %s \t [ %04d | %04d]\n',random_pick{i},i,length(random_pick));
    videoObj=VideoReader(fullfile(datasetup.videoDir,random_pick{i}));
    FrameCount=1;
    
    
    videoWObj=VideoWriter(fullfile(VideoSavePath,sprintf('%.02d.avi',i)));
    open(videoWObj);
    
    

    
    while hasFrame(videoObj)
        ml_progressBar(FrameCount,l_video);
        videoFrame=readFrame(videoObj);
        
        imshow(videoFrame);
        
        
        [~,name_stem,~]=fileparts(random_pick{i});
        title(sprintf('Video: %.02d \t  Frame Number:  %.4d',i,FrameCount));
        
 
        img=export_fig;
        
        
        writeVideo(videoWObj,img);
        FrameCount=FrameCount+1;
        
    end
    close(videoWObj);
end

