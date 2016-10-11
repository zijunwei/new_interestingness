% compute the entropy by computing the IO of one vs rest AUC score



%


% clear;
clc;
close all

addpath('~/Dev/ZFunc');
addpath('~/Dev/ZFunc/Gaze')
datasetup=setup();
fprintf('Loading information...\n');
load(datasetup.VisualInformationPath);
fprintf('Done\n')
%

%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed
addpath('~/Dev/ZFunc/saliency/code_forMetrics/');

% VideoEntropy(length(VideoInformation))=struct('videoname',[],'entropy',[]);
saveDir='IOs';
if ~exist(saveDir,'dir')
    mkdir(saveDir)
end
for i=1614:-1:1200
    fprintf('---processing %s \t [ %04d | %04d]\n',VideoInformation( ( i)).videoname, ( i),length(VideoInformation));
    videoObj=VideoReader(fullfile(datasetup.videoDir,VideoInformation( ( i)).videoname));
    FrameCount=1;
    entro=[];
    while hasFrame(videoObj)
        videoFrame=readFrame(videoObj);
        
        %         subplot(1,2,1)
        %         imshow(videoFrame);
        %         hold on;
        gazePosition=zeros((length(VideoInformation( (i)).gaze)),2);
        for j=1:1:length(VideoInformation( ( i)).gaze)
            gaze=( VideoInformation( ( i)).gaze(j).data);
            % for now, only use the fixation data
            gaze=gaze(gaze(:,end)==1,:);
            % convert mmseconds to framerate
            gaze(:,1)=ceil( gaze(:,1)/1000/1000*VideoInformation( ( i)).framerate);
            
            selectedGaze=gaze(gaze(:,1)==FrameCount,:);
            
            selectedGaze=selectedGaze(:,3:4);
            gazePosition(j,:)=mean(selectedGaze,1);
            
        end
        
        
        
        
        videoFrameSz=size(videoFrame);
        
        % remove the invalid ones
        gazePosition=z_cropCoordinates(gazePosition,[videoFrameSz(2),videoFrameSz(1)]);
        
        
        sAUC=z_InterObserver(gazePosition,videoFrame,15);
        
        
        
        entro(FrameCount)= sAUC;
        FrameCount=FrameCount+1;
        
    end
    savename=[VideoInformation( (i)).videoname,'.mat'];
    %     VideoEntropy(i).fdms=fdms;
    IOScore=entro;
    save(fullfile(saveDir,savename),'IOScore');
    
    %     VideoEntropy(i).entropy=entro;
end
% save(fullfile(datasetup.gazeDatasetDir ,'VideoIO2.mat'),'VideoEntropy','-v7.3');

