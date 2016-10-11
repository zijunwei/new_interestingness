% visalize gaze data using FDM
%


% clear;
% clc;
% close all
% 
% addpath('~/Dev/ZFunc');
% addpath('~/Dev/ZFunc/Gaze')
% datasetup=setup_mac();
% load(fullfile(datasetup.gazeDatasetDir,'VideoInformation.mat'));

%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed
addpath('~/Dev/ZFunc/saliency/code_forMetrics/');
for i=1:1:length(VideoInformation)
    videoObj=VideoReader(fullfile(datasetup.videoDir,VideoInformation(i).videoname));
    FrameCount=1;
    
    while hasFrame(videoObj)
        videoFrame=readFrame(videoObj);
        imshow(videoFrame);
        hold on;
        gazePosition=zeros(length(length(VideoInformation(i).gaze)),2);
        for j=1:1:length(VideoInformation(i).gaze)
            gaze=( VideoInformation(i).gaze(j).data);
            % for now, only use the fixation data
            gaze=gaze(gaze(:,end)==1,:);
            % convert mmseconds to framerate
            gaze(:,1)=ceil( gaze(:,1)/1000/1000*VideoInformation(i).framerate);
            
            selectedGaze=gaze(gaze(:,1)==FrameCount,:);
            
            selectedGaze=selectedGaze(:,3:4);
            gazePosition(j,:)=mean(selectedGaze,1);
            
        end
%         gazePosition=round(gazePosition);
        % here you should put the 
        
        
        gazePosition=z_cropCoordinates(gazePosition, size(videoFrame));
        
        
        bmap=drawFixBMap(videoFrame,gazePosition);
        fdm=run_antonioGaussian(bmap,15);
        fdm=fdm/max(fdm(:));
         hfdm = imshow(fdm); set(hfdm, 'AlphaData', 0.5);
        colormap jet
        
        FrameCount=FrameCount+1;
        hold off
        % debug or for step visualization
        waitforbuttonpress;
    end
    
end