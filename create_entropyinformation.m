% compute entropy
%


% clear;
% clc;
% close all
% 
% addpath('~/Dev/ZFunc');
% addpath('~/Dev/ZFunc/Gaze')
% datasetup=setup();
% fprintf('Loading information...\n');
% load(datasetup.VisualInformationPath);
% fprintf('Done\n')
% entropySize=[360,480];

%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed
addpath('~/Dev/ZFunc/saliency/code_forMetrics/');

VideoEntropy(length(VideoInformation))=struct('videoname',[],'entropy',[]);
for i=1:1:length(VideoInformation)
    fprintf('---processing %s \t [ %04d | %04d]\n',VideoInformation(i).videoname,i,length(VideoInformation));
    videoObj=VideoReader(fullfile(datasetup.videoDir,VideoInformation(i).videoname));
    FrameCount=1;
    entro=0;
    %     fdms={};
    while hasFrame(videoObj)
        videoFrame=readFrame(videoObj);
        
        %         subplot(1,2,1)
        %         imshow(videoFrame);
        %         hold on;
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
        
        
        
        videoFrameSz=size(videoFrame);
        gazePosition=z_cropCoordinates(gazePosition,[videoFrameSz(2),videoFrameSz(1)]);
        
        bmap=drawFixBMap(videoFrame,gazePosition);
        fdm=run_antonioGaussian(bmap,15);
        fdm=fdm/max(fdm(:));
        
        
        %         rfdm=imresize(fdm,entropySize);
        %         rfdm=rfdm/max(rfdm(:));
        entro(FrameCount)= entropy(fdm);
        %         fdms{FrameCount}=fdm;
        %         plot(1:length(entro),entro,'*r');
        %         xlim([0, max(length(entro),10)]);
        %         ylim([0,50]);
        
        % debug or for step visualization
        %         waitforbuttonpress;
        
        % increase by 1
        FrameCount=FrameCount+1;
        
    end
    VideoEntropy(i).videoname=VideoInformation(i).videoname;
    %     VideoEntropy(i).fdms=fdms;
    
    VideoEntropy(i).entropy=entro;
end
save(fullfile(datasetup.gazeDatasetDir,'VideoEntropy_unResized.mat'),'VideoEntropy','-v7.3');

