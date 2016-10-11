close all;
clear;
clc

load GregPick.mat

dst_dir='vids_selected_35_name';
if ~exist(dst_dir,'dir')
   mkdir(dst_dir) 
end

src_dir='/home/zijwei/Dev/datasets/gazeVideos/hollywood_action/AVIClips';


for i=1:1:length(selectedVideoNames)
    
   copyfile(fullfile(src_dir,selectedVideoNames{i}), fullfile(dst_dir,selectedVideoNames{i}),'f');
    
end