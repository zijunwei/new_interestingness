% compute the entropy by computing the elementwise entropy



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
% 
% fprintf('Loading entropy...\n');
% load(datasetup.EntropyInformationPath);
% fprintf('Done\n')
%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed
addpath('~/Dev/ZFunc/saliency/code_forMetrics/');

% pick these 4 Id to be the following
videoNames={'actioncliptrain00001.avi','actioncliptrain00016.avi','actioncliptrain00720.avi','actioncliptrain00770.avi'};

pickedId=zeros(length(videoNames),1);
for i=1:1:length(pickedId)
    pickedId(i)=z_structfind(VideoEntropy,'videoname',videoNames{i});
end

totalViewer=16;
VideoEntropy_new(length(pickedId))=struct('videoname',[],'entropy',[]);
for i=1:1:length(pickedId)
    fprintf('---processing %s \t [ %04d | %04d]\n',VideoInformation(pickedId( i)).videoname,pickedId( i),length(VideoInformation));
    videoObj=VideoReader(fullfile(datasetup.videoDir,VideoInformation(pickedId( i)).videoname));
    FrameCount=1;
    entro=0;
    %     fdms={};
    while hasFrame(videoObj)
        videoFrame=readFrame(videoObj);
        
        %         subplot(1,2,1)
        %         imshow(videoFrame);
        %         hold on;
        gazePosition=zeros((length(VideoInformation(pickedId(i)).gaze)),2);
        for j=1:1:length(VideoInformation(pickedId( i)).gaze)
            gaze=( VideoInformation(pickedId( i)).gaze(j).data);
            % for now, only use the fixation data
            gaze=gaze(gaze(:,end)==1,:);
            % convert mmseconds to framerate
            gaze(:,1)=ceil( gaze(:,1)/1000/1000*VideoInformation(pickedId( i)).framerate);
            
            selectedGaze=gaze(gaze(:,1)==FrameCount,:);
            
            selectedGaze=selectedGaze(:,3:4);
            gazePosition(j,:)=mean(selectedGaze,1);
            
        end
        %         gazePosition=round(gazePosition);
        % here you should put the
        
        
        
        videoFrameSz=size(videoFrame);
        
        % remove the invalid ones
        gazePosition=z_cropCoordinates(gazePosition,[videoFrameSz(2),videoFrameSz(1)]);
        
        
        
        bmap=drawFixBMap(videoFrame,gazePosition);
        fdm=run_antonioGaussian(bmap,15);
        
        
        
        eFDM=fdm/sum(fdm(:));
        en=z_entropy(eFDM);
        %
        %         orgEntropy=entropy(fdm);
        %
        %
        %         if FrameCount==1
        %            maxEntropyImg=ones(videoFrameSz(1),videoFrameSz(2))*1/(videoFrameSz(1)*videoFrameSz(2));
        %            maxEntropy=entropy(maxEntropyImg);
        %
        %         end
        %
        %
        %
        %         nViwers=size(gazePosition,1);
        entro(FrameCount)= en;
        
        
        
        FrameCount=FrameCount+1;
        
    end
    VideoEntropy_new(i).videoname=VideoInformation(pickedId(i)).videoname;
    %     VideoEntropy(i).fdms=fdms;
    
    VideoEntropy_new(i).entropy=entro;
end
save('VideoEntropySpatial.mat','VideoEntropy_new','-v7.3');

