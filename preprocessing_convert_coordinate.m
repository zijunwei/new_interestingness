% load data from samples, then convert the screen coordinate into video
% coordinate


clear;
clc;
close all

addpath('~/Dev/ZFunc');

%%
if ismac
    datasetup=setup_mac();
    
elseif isunix
    datasetup=setup();
else
    error('Unspecified system')
end



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


%% change eye movement coordinate from screen-wise to image-wise
% caution, for different platforms, this code might needed to be changed a
% little bit

new_dir=fullfile(datasetup.videoDatasetDir ,'samples_video_coords');
if ~exist(new_dir,'dir')
    mkdir(new_dir)
end


for i=1:1:length(listofVideos)
    
    videoName=listofVideos{i};
    indx=z_cellfind(videoName,validvideoNames);
    video_res_x=video_res_xs(indx);
    video_res_y=video_res_ys(indx);
    
    indxs_gazefiles=z_cellfind(videoName,listofGazeSamples);
    gazefiles=listofGazeSamples(indxs_gazefiles);
    for j=1:1:length(gazefiles)
        fprintf('--- processing %s\n',gazefiles{j});
        gaze_fileID=fopen( fullfile(datasetup.gazeDir,gazefiles{j}));
        gaze_data=textscan(gaze_fileID,'%f\t%f\t%f\t%f\t%f\t%s');
        fclose(gaze_fileID);
        screen_coord_xs=gaze_data{4};
        screen_coord_ys=gaze_data{5};
        
        video_coord=convert2video_coord([screen_coord_xs,screen_coord_ys],[video_res_x,video_res_y]);
        
        write_fileId=fopen(fullfile(new_dir,gazefiles{j}),'w');
        time_frames=gaze_data{1};
        pp_diameter=gaze_data{2};
        pp_area=gaze_data{3};
        gaze_type=gaze_data{end};
        for k=1:1:length(gaze_data{1})
            fprintf(write_fileId,'%d\t%f\t%f\t%f\t%f\t%s\n',time_frames(k),pp_diameter(k),pp_area(k),video_coord(k,1),video_coord(k,2),gaze_type{k});
        end
        fclose(write_fileId);
    end
    
end
