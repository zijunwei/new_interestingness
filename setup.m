function datasetup=setup()
% the This is the init file here, contains situations in both Mac and Linux

if ismac
    videoDatasetDir='~/Dev/hollywood_subset';
    gazeDatasetDir='~/Dev/hollywood_subset';
        
elseif isunix
    
    videoDatasetDir='~/Dev/datasets/gazeVideos/hollywood_action/';
    gazeDatasetDir='~/Dev/datasets/gazeVideos/hollywood_gaze';
    
else
    error('Unspeified system\n')
end

datasetup.videoDatasetDir=videoDatasetDir;
datasetup.videoDir=fullfile(videoDatasetDir,'AVIClips');
datasetup.splitDir=fullfile(videoDatasetDir,'ClipSets');
datasetup.videoBoundDir=fullfile(videoDatasetDir,'ShotBounds');

datasetup.gazeDatasetDir=gazeDatasetDir;
datasetup.gazeDir=fullfile(gazeDatasetDir,'samples');

datasetup.gazeFileNamePtrn='%.03d_%s.txt'; % 3digit subject ID_full-video-name.txt
datasetup.VisualInformationPath=fullfile(gazeDatasetDir,'VideoInformation.mat');
datasetup.EntropyInformationPath=fullfile(gazeDatasetDir,'VideoEntropy_unResizedConcise.mat');

end