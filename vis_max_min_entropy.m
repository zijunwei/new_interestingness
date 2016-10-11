% visalize maximum and minimum gaze agreement in each video without showing
% the scores
% top: the image with highest and lowest score
% bottom the video clip with highest and lowest score


% clear;
% clc;
% close all
% 
% addpath('~/Dev/ZFunc');
% addpath('~/Dev/ZFunc/Gaze')
% datasetup=setup();
% fprintf('Loading data...\n')
% load(fullfile(datasetup.gazeDatasetDir,'VideoInformation.mat'));
% %load different mat file
% load(fullfile(datasetup.gazeDatasetDir,'VideoEntropy_unResizedConcise.mat'));
% fprintf('Done.\n')

%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed


addpath('~/Dev/ZFunc/saliency/code_forMetrics/');
addpath('~/Dev/ZFunc/export_figure/')



% add save path

VideoSavePath=fullfile(datasetup.gazeDatasetDir,'visualization_unresizedEntropy_minmax');
if ~exist(VideoSavePath,'dir')
    mkdir(VideoSavePath);
end
figure;
set(gcf,'visible','off');
warning off
% at most 16 users
drawColors = z_distinguishable_colors(16);
video_with=15;
% i=885, starting of training
for i=886:5:length(VideoInformation)
    if length(VideoEntropy(i).entropy)>250
        continue;
    end
    fprintf('---processing %s \t [ %04d | %04d], total %d frames\n',VideoInformation(i).videoname,i,length(VideoInformation),length(VideoEntropy(i).entropy));
    videoObj=VideoReader(fullfile(datasetup.videoDir,VideoInformation(i).videoname));
    
    videoWObj=VideoWriter(fullfile(VideoSavePath,VideoInformation(i).videoname));
    open(videoWObj);
    
    
    v_entropy=VideoEntropy(i).entropy;
    v_length=length(v_entropy);
    
    % Indicator showing the if this image should be saved or not.
    
    v_entropy_cut=v_entropy(1+video_with:end-video_with);
    [~,MaxIndx]=max(v_entropy_cut);
    [~,MinIndx]=min(v_entropy_cut);
    
    MaxIndx=MaxIndx+video_with;
    MinIndx=MinIndx+video_with;
    
    
    if MaxIndx+video_with >v_length || MinIndx+video_with>v_length
        continue;
    end
    
    
    
    [MaximageIndicator,MinimageIndicator, imageIndicator]=deal( zeros(length(v_entropy),1));
    
    MaximageIndicator(MaxIndx-video_with:MaxIndx+video_with)=1;
    MinimageIndicator(MinIndx-video_with:MinIndx+video_with)=1;
    
    MinImages=cell(2*video_with+1,1);
    MaxImages=cell(2*video_with+1,1);
    
    FrameCount=1;
    idx_max=1;
    idx_min=1;
    while hasFrame(videoObj)
        videoFrame=readFrame(videoObj);
        if FrameCount==1
            refImgSz=size(videoFrame);
        end
        if sum( refImgSz~=size(videoFrame))
            videoFrame=imresize(videoFrame,refImgSz(1:2));
        end
        if MaximageIndicator(FrameCount)==1
            MaxImages{idx_max}=videoFrame;
            idx_max=idx_max+1;
        end
        if MinimageIndicator(FrameCount)==1
            MinImages{idx_min}=videoFrame;
            idx_min=idx_min+1;
        end
        FrameCount=FrameCount+1;
    end
    
    
    % draw:
    
    for j=1:1:length(MinImages)
        subplot(2,2,1)
        imshow(MinImages{1+video_with});
        subplot(2,2,2)
        imshow(MaxImages{1+video_with})
        subplot(2,2,3)
        imshow(MinImages{j})
        subplot(2,2,4)
        imshow(MaxImages{j})
                         img=export_fig;
        
    
        writeVideo(videoWObj,img);
    end
    close(videoWObj);
end