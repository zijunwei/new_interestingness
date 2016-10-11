% change the file name like actioncliptrainXXX to actionXXX;
clear
split='train';

datasetup=setup();
addpath('~/Dev/ZFunc/')



VideoSavePath=fullfile(datasetup.gazeDatasetDir,'visualization_unresizedEntropy_minmax');
listofFiles=z_getFileIdsfromDir(VideoSavePath,'.avi');
listofFiles=cellfun(@(x)cat(2,x,'.avi'),listofFiles,'UniformOutput',false);

[trainVid,trainLb,actionClasses]=ml_load(fullfile(datasetup.videoDatasetDir,'info.mat'),'trainVid','TrainLabel','actions');

for i=1:1:length(listofFiles)
   index=z_structfind(trainVid,'name',listofFiles{i});
   annos=trainLb(index,:);
   annos=(annos==1);
   labels=actionClasses(annos);
    labels=cell2mat(labels);
%     if length(labels)>1
%      labels=(cell2mat( labels)) ;
%     end
   orgFileName=listofFiles{i};
   newName=cat(2,labels,'_',orgFileName(16:end));
   movefile(fullfile(VideoSavePath,orgFileName),fullfile(VideoSavePath,newName));
end