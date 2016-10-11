% convert video format to playable format on a raw Mac machine

clear;
clc;
close all

addpath('~/Dev/ZFunc');

%%
datasetup=setup_mac();

listofVideos=z_getFileIdsfromDir(datasetup.videoDir,'.avi');
listofVideos=cellfun(@(x)cat(2,x,'.avi') ,listofVideos,'uniformoutput',false);


outputDir=fullfile(datasetup.videoDatasetDir,'MacVersion');
if ~exist(outputDir,'dir')
   mkdir(outputDir); 
end


for i=1:1:length(listofVideos)
    
inputFile=fullfile(datasetup.videoDir,listofVideos{i});
outputFile=fullfile(outputDir,listofVideos{i});

cmd=sprintf('ffmpeg -i %s -an -vcodec rawvideo -y %s\n',inputFile,outputFile);
    system(cmd);
end
    




