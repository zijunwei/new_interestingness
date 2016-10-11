%% create a subset:

subset_size=200;
selected_ids=randperm(length(validvideoNames));
subset_videonames=validvideoNames(selected_ids(1:subset_size));


%% move all related stuff to a new directory
%1. move all videos
targetDirectory='/home/zijwei/Dev/datasets/gazeVideos/hollywood_subset/videos';
for video_idx=1:1:length(subset_videonames)
    copyfile(fullfile(datasetup.videoDir,subset_videonames{video_idx}),targetDirectory);
    
end


%% 2. move all annotations:

targetDirectory='/home/zijwei/Dev/datasets/gazeVideos/hollywood_subset/samples';

for video_idx=1:1:length(subset_videonames)
    copy_cmd= ['cp ', fullfile(datasetup.gazeDir,['*',subset_videonames{video_idx},'*' ]), ' ',targetDirectory];
    system(copy_cmd);
end