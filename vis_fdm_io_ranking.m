% visalize IO gaze agreement  as well as video itself from high to low difference in maximum and minimum IOs:


% clear;
% clc;
% close all
% 
% addpath('~/Dev/ZFunc');
% addpath('~/Dev/ZFunc/Gaze')
% datasetup=setup();
% fprintf('Loading Video information...\n')
% 
% load(fullfile(datasetup.gazeDatasetDir,'VideoInformation.mat'));
% 
% fprintf('Done.\n')
% 
% 
% fprintf('Loading IO scores...')
% 
% load(fullfile(datasetup.gazeDatasetDir,'VideoIO_train.mat'));
% 
% fprintf('Done.\n')
% % % entropySize=[360,480];

%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed


addpath('~/Dev/ZFunc/saliency/code_forMetrics/');
addpath('~/Dev/ZFunc/export_figure/')


AllIOs={VideoEntropy.entropy};

MaxIOs=cellfun(@(x)max(x), AllIOs,'uniformoutput',false);
MaxIOs=cell2mat(MaxIOs);


MinIOs=cellfun(@(x)min(x), AllIOs,'uniformoutput',false);
MinIOs=cell2mat(MinIOs);

Diffs=(MaxIOs-MinIOs);

[s_Diffs,sortedIdx]=sort(Diffs,'descend');



% add save path

VideoSavePath=fullfile(datasetup.gazeDatasetDir,'visualization_IO_rankings');
if ~exist(VideoSavePath,'dir')
    mkdir(VideoSavePath);
end
figure;
set(gcf,'visible','off');
warning off
% at most 16 users
drawColors = z_distinguishable_colors(16);

% i=885, starting of training
for i=1:1:5
    entropyIdx=sortedIdx(i);
    
    if length(VideoEntropy(entropyIdx).entropy)>500
       continue; 
    end
    fprintf('---processing %s \t [ %04d | %04d], total %d frames\n',VideoEntropy(entropyIdx).videoname,i,150,length(VideoEntropy(entropyIdx).entropy));
    videoObj=VideoReader(fullfile(datasetup.videoDir,VideoEntropy(entropyIdx).videoname));
    FrameCount=1;
    
    [~,videoName,videoFormat]=fileparts(VideoEntropy(entropyIdx).videoname);
    videosaveName=sprintf('%.2d_%s%s',round( Diffs(entropyIdx)*100),videoName,videoFormat);
    videoWObj=VideoWriter(fullfile(VideoSavePath,videosaveName));
    open(videoWObj);
    
    
    while hasFrame(videoObj)
        ml_progressBar(FrameCount,length(VideoEntropy(entropyIdx).entropy));
        videoFrame=readFrame(videoObj);
        
        subplot(2,1,1)
        imshow(videoFrame);
        idx=z_structfind(VideoInformation,'videoname',VideoEntropy(entropyIdx).videoname);
        hold on;
        gazePosition=zeros(length(length(VideoInformation(idx).gaze)),2);
        ValidViewers=0;
        for j=1:1:length(VideoInformation(idx).gaze)
            gaze=( VideoInformation(idx).gaze(j).data);
            % for now, only use the fixation data
            gaze=gaze(gaze(:,end)==1,:);
            % convert mmseconds to framerate
            gaze(:,1)=ceil( gaze(:,1)/1000/1000*VideoInformation(idx).framerate);
            
            selectedGaze=gaze(gaze(:,1)==FrameCount,:);
            if ~isempty(selectedGaze)
                ValidViewers=ValidViewers+1;
            end
            selectedGaze=selectedGaze(:,3:4);
            gazePosition(j,:)=mean(selectedGaze,1);
            
        end
        
        title(sprintf('Viewers:\t%d',ValidViewers));
        
        
        videoFrameSz=size(videoFrame);
        gazePosition=z_cropCoordinates(gazePosition,[videoFrameSz(2),videoFrameSz(1)]);
        
        drawColors = z_distinguishable_colors(size(gazePosition,1));
        
        
        for j = 1:size(gazePosition,1)
            text (gazePosition(j, 1), gazePosition(j, 2), ['{\color{black}\bf', num2str(j), '}'], 'FontSize', 10, 'BackgroundColor', drawColors(j,:));
        end
        
        
        hold off
        % Drawing FDM
        %         bmap=drawFixBMap(videoFrame,gazePosition);
        %         fdm=run_antonioGaussian(bmap,15);
        %         fdm=fdm/max(fdm(:));
        %         hfdm = imshow(fdm); set(hfdm, 'AlphaData', 0.5);
        %         colormap jet
        %
        %         hold off
        
        % Visualize shot boundary, entropy distribution and current entropy
        subplot(2,1,2);
        
        v_entropy=VideoEntropy(entropyIdx).entropy;
        plot(1:length(v_entropy),v_entropy,'LineWidth',2,'Color','k');
        
        hold on
        
        
        xlim([0, length(v_entropy)]);
        ylim([0.4,1]);
        plot(1:FrameCount,v_entropy(1:FrameCount), 's','MarkerSize',10,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor',[1,0,0]);
        %draw cut
        shotbounds=VideoInformation(idx).shotbounds;
        if ~isempty(shotbounds)
            z_vline(shotbounds)
        end
        
        
        
        % debug or for step visualization
        %         waitforbuttonpress;
        
        % increase by 1
        hold off
        % too time consuming
                 img=export_fig;
        
        % still time consuming
%         F=getframe;
%         axesData=F.cdata;
%         
%         img=v_mergeImage(videoFrame,axesData);
        
        
        if FrameCount==1
            refImgSz=size(img);
        end
        if sum( refImgSz~=size(img))
            img=imresize(img,refImgSz(1:2));
        end
        writeVideo(videoWObj,img);
        FrameCount=FrameCount+1;
        
    end
    close(videoWObj);
end

% draw:
