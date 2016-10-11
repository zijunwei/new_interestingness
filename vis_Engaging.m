clear;
clc;
close all

addpath('~/Dev/ZFunc');
addpath('~/Dev/ZFunc/Gaze')
addpath('~/Dev/ZFunc/export_figure/')

load('GregPick.mat');
load('VideoIO_35.mat');
load('VideoInformation35.mat');





listofSubjectFiles=z_getFileIdsfromDir('subjects');

most_engagement=cell(length(selectedVideoNames),1);
lest_engagement=cell(length(selectedVideoNames),1);

interestingness=zeros(length(selectedVideoNames),1);
for i=1:1:length(selectedVideoNames)
    indx= z_structfind(VideoEntropy,'videoname',selectedVideoNames{i});
    s_eng=zeros(length(VideoEntropy(indx).entropy),1);
    most_engagement{i}=s_eng;
    lest_engagement{i}=s_eng;
    
end



for i=1:1:length(listofSubjectFiles)
    
    load(fullfile('subjects',listofSubjectFiles{i}));
    for j=1:1:size(data,1)
        interestingness(j)=interestingness(j)+data(j,end);
        assert( length(most_engagement{j}) >=data(j,2) &&  length(most_engagement{j}) >=data(j,4)  ,'length problem');
        x= zeros( length( most_engagement{j}), 1);
        x(data(j,1):data(j,2))=1;
        
        
        most_engagement{j}=most_engagement{j}+x;
        y= zeros( length( lest_engagement{j}), 1);
        y(data(j,3):data(j,4))=1;
        lest_engagement{j}=lest_engagement{j}+y;
        
        
    end
    
    
end


%
%
% % % %%%% Draw
% % % for i=1:1:length(selectedVideoNames)
% % %     indx= z_structfind(VideoEntropy,'videoname',selectedVideoNames{i});
% % %     ento=VideoEntropy(indx).entropy;
% % %     most_eng= most_engagement{i};
% % %     lest_eng=lest_engagement{i};
% % %     figure
% % %     hold on
% % %     title(sprintf('Video: %.02d, # Frames: %.4d, Interesting: %.2f', i, length(ento), interestingness(i)/length(listofSubjectFiles)))
% % %     plot(1:length(ento), ento,'r');
% % %     plot(1:length(most_eng), most_eng/length(listofSubjectFiles),'k');
% % %     plot(1:length(lest_eng), lest_eng/length(listofSubjectFiles),'b');
% % %     legend('agreement','most-engaging','least-engaging')
% % %     img=export_fig;
% % %     imwrite(img, sprintf('imgs_eng/%02d.png',i))
% % %     hold off
% % %     close all
% % %
% % %
% % %
% % % end


VideoSavePath='vids_selected_vid_view';
if ~exist(VideoSavePath,'dir')
    mkdir(VideoSavePath)
end

for i=1:1:length(selectedVideoNames)
    figure;
    set(gcf,'visible','off')
    warning off
    assert(strcmp( selectedVideoNames{i},VideoEntropy(i).videoname))
    if length(VideoEntropy(i).entropy)>250
        continue;
    end
    fprintf('---processing %s \t [ %04d | %04d], total %d frames\n',VideoEntropy(i).videoname,i,length(VideoEntropy),length(VideoEntropy(i).entropy));
    videoObj=VideoReader(fullfile('vids_selected_35_name',VideoEntropy(i).videoname));
    FrameCount=1;
    
    videoWObj=VideoWriter(fullfile(VideoSavePath,VideoEntropy(i).videoname));
    open(videoWObj);
    
    
    while hasFrame(videoObj)
        ml_progressBar(FrameCount,length(VideoEntropy(i).entropy));
        videoFrame=readFrame(videoObj);
        
        subplot(2,1,1)
        imshow(videoFrame);
        idx=z_structfind(VideoInformation,'videoname',VideoEntropy(i).videoname);
        hold on;
%         gazePosition=zeros(length(length(VideoInformation(idx).gaze)),2);
%         ValidViewers=0;
%         for j=1:1:length(VideoInformation(idx).gaze)
%             gaze=( VideoInformation(idx).gaze(j).data);
%             % for now, only use the fixation data
%             gaze=gaze(gaze(:,end)==1,:);
%             % convert mmseconds to framerate
%             gaze(:,1)=ceil( gaze(:,1)/1000/1000*VideoInformation(idx).framerate);
%             
%             selectedGaze=gaze(gaze(:,1)==FrameCount,:);
%             if ~isempty(selectedGaze)
%                 ValidViewers=ValidViewers+1;
%             end
%             selectedGaze=selectedGaze(:,3:4);
%             gazePosition(j,:)=mean(selectedGaze,1);
%             
%         end
        
        title(sprintf(' interesting score: %.2f', interestingness(i)/length(listofSubjectFiles)));
        
        
%         videoFrameSz=size(videoFrame);
%         gazePosition=z_cropCoordinates(gazePosition,[videoFrameSz(2),videoFrameSz(1)]);
%         
%         drawColors = z_distinguishable_colors(size(gazePosition,1));
%         
%         
%         for j = 1:size(gazePosition,1)
%             text (gazePosition(j, 1), gazePosition(j, 2), ['{\color{black}\bf', num2str(j), '}'], 'FontSize', 10, 'BackgroundColor', drawColors(j,:));
%         end
        
        
        hold off
        
        
        % Visualize shot boundary, entropy distribution and current
        % entropy, engaging (max and min)
        subplot(2,1,2);
        
        v_entropy=VideoEntropy(i).entropy;
        most_eng= most_engagement{i};
        lest_eng=lest_engagement{i};
        hold on
        plot(1:length(v_entropy),v_entropy,'LineWidth',2,'Color','k');
        
        
        plot(1:length(most_eng), most_eng/length(listofSubjectFiles),'LineWidth',2,'Color','r');
        plot(1:length(lest_eng), lest_eng/length(listofSubjectFiles),'LineWidth',2,'Color','b');
       
        
        
        %         hold on
        
        
        xlim([0, length(v_entropy)]);
        ylim([0.0,1]);
        plot(FrameCount,v_entropy(FrameCount), 's','MarkerSize',10,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor',[1,0,0]);
        plot(FrameCount,most_eng(FrameCount)/length(listofSubjectFiles), 's','MarkerSize',10,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor',[1,0,0]);
        plot(FrameCount,lest_eng(FrameCount)/length(listofSubjectFiles), 's','MarkerSize',10,...
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
%         title('red: most, blue least')
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
    close all
end
