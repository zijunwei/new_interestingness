% load data from samples, then convert the screen coordinate into video
% coordinate, and then create video information structfile in the following
% format:
% VideoInformation (struct)
%       .videoname:
%       .framerate:
%       .resolution[x,y]
%       .shotbounds : recording the shotboundary values of the video, if
%       any...
%       .gaze(struct)
%           .viwerId (integer)
%           .data (n by 5 matrix) : timeinmmsecond, pp-diameter,
%           video_locx. video_locy,type
% where type is a integer set, Fixation=1, Saccade=2, Blink=3;
%
% and save to a file

clear;
clc;
close all

addpath('~/Dev/ZFunc');
% import matlab.unittest.constraints.IssuesWarnings;

%%
datasetup=setup();



listofVideos=z_getFileIdsfromDir(datasetup.videoDir,'.avi');
listofVideos=cellfun(@(x)cat(2,x,'.avi') ,listofVideos,'uniformoutput',false);



resFileId=fopen( fullfile(datasetup.gazeDatasetDir,'resolution.txt'));
videoParams=textscan(resFileId,'%s\t%d\t%d\t%f');
fclose(resFileId);

validvideoNames=videoParams{1};
video_res_xs=videoParams{2};
video_res_ys=videoParams{3};
video_frates=videoParams{4};


listofGazeSamples=z_getFileIdsfromDir(datasetup.gazeDir,'.txt');
listofGazeSamples=cellfun(@(x)cat(2,x,'.txt') ,listofGazeSamples,'uniformoutput',false);

listofSBFiles=z_getFileIdsfromDir(datasetup.gazeDir,'.sht');
listofSBFiles=cellfun(@(x)cat(2,x,'.sht') ,listofSBFiles,'uniformoutput',false);

%% change eye movement coordinate from screen-wise to image-wise
% caution, for different platforms, this code might needed to be changed a
% little bit



VideoInformation(length(listofVideos)) =struct('videoname',[],'framerate',[],'resolution',[],'gaze',[],'shotbounds',[]);

for i=1:1:length(listofVideos)
    
    videoName=listofVideos{i};
    indx=z_cellfind(videoName,validvideoNames);
    if isempty(indx)
       continue; 
    end
    
    % finding these information from resolution file
    video_res_x=video_res_xs(indx);
    video_res_y=video_res_ys(indx);
    framerate=video_frates(indx);
    
    
    
    VideoInformation(i).videoname=videoName;
    VideoInformation(i).framerate=framerate;
    VideoInformation(i).resolution=[video_res_x,video_res_y];
    
    [~,videoStemName,~]=fileparts(videoName);
    videoSBFile=[videoStemName,'.sht'];
    
    
    
    if exist(fullfile(datasetup.videoBoundDir,videoSBFile),'file')
        sb_fileId=fopen(fullfile(datasetup.videoBoundDir,videoSBFile),'r');
        sb_data  =fgetl(sb_fileId);
        sb_data=strsplit(sb_data,' ');
        
        sb_data=sb_data(1:end-1);
        sb_array= cell2mat( cellfun(@(x)str2num(x),sb_data,'uniformoutput',false));
%         sb_array=cell2mat(sb_array);
%         sb_array=zeros(length(sb_data)-1,1);
%         for k=1:1:length(sb_data)-1
%             sb_array(k)=str2double(sb_data{k});
%         end
        fclose(sb_fileId);
    else
        sb_array=NaN;
    end
    
    if isnan(sb_array)
       sb_array=[]; 
    end
    
    VideoInformation(i).shotbounds=sb_array;
    
    indxs_gazefiles=z_cellfind(videoName,listofGazeSamples);
    gazefiles=listofGazeSamples(indxs_gazefiles);
    %     clearvars gaze
    gaze(length(gazefiles))=struct('viewerId',[],'data',[]);
    for j=1:1:length(gazefiles)
        fprintf('--- processing %s\n',gazefiles{j});
        
        viewerId=strsplit(gazefiles{j},'_');
        viewerId= str2double(viewerId{1});
        
        gaze_fileID=fopen( fullfile(datasetup.gazeDir,gazefiles{j}));
        gaze_data=textscan(gaze_fileID,'%f\t%f\t%f\t%f\t%f\t%s');
        fclose(gaze_fileID);
        screen_coord_xs=gaze_data{4};
        screen_coord_ys=gaze_data{5};
        
        video_coord=convert2video_coord([screen_coord_xs,screen_coord_ys],[video_res_x,video_res_y]);
        
        time_frames=gaze_data{1};
        pp_diameter=gaze_data{2};
        gaze_type=gaze_data{end};
        gaze_type_int=zeros(length(gaze_type),1);
        
        
        % convert gaze_type into 1,2,3
        
        indxF=z_cellfind('F',gaze_type);
        gaze_type_int(indxF)=1;
        
        indxS=z_cellfind('S',gaze_type);
        gaze_type_int(indxS)=1;
        
        indxB=z_cellfind('B',gaze_type);
        gaze_type_int(indxB)=3;
        
        if ~(length(gaze_type_int)==(length(indxB)+length(indxS)+length(indxF)))
            fprintf('----%s has inconsistent annotations\n',gazefiles{j})
        end
        
        
        gaze(j).viewerId=viewerId;
        gaze(j).data=[time_frames,pp_diameter,video_coord,gaze_type_int];
        %         fclose(write_fileId);
    end
    VideoInformation(i).gaze=gaze;
    
end
VideoInformation=z_removeEmptyStructs(VideoInformation,'videoname');
save(datasetup.VisualInformationPath,'VideoInformation','-v7.3');
