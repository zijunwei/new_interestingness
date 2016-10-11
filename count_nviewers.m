% get number of viewers per videos on Hollywood 2 dataset


clear;
clc;
close all

addpath('~/Dev/ZFunc');

%%
datasetup=setup_mac();

listofVideos=z_getFileIdsfromDir(datasetup.videoDir,'.avi');
listofVideos=cellfun(@(x)cat(2,x,'.avi') ,listofVideos,'uniformoutput',false);


listofGazeSamples=z_getFileIdsfromDir(datasetup.gazeDir,'.txt');
listofGazeSamples=cellfun(@(x)cat(2,x,'.txt') ,listofGazeSamples,'uniformoutput',false);


for i=1:1:length(listofVideos)
    indxs=z_cellfind(listofVideos{i},listofGazeSamples);
    fprintf('%s :\t%d\n',listofVideos{i},length(indxs));
   
end
    


