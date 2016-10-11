% create a list of videos for subject test



% % % clear;
% % % clc;
% % % close all
% % % 
% % % addpath('~/Dev/ZFunc');
% % % addpath('~/Dev/ZFunc/Gaze')
% % % datasetup=setup();
% % % % fprintf('Loading Video information...\n')
% % % 
% % % % load(fullfile(datasetup.gazeDatasetDir,'VideoInformation.mat'));
% % % 
% % % % fprintf('Done.\n')
% % % 
% % % 
% % % fprintf('Loading IO scores...')
% % % 
% % % load(fullfile(datasetup.gazeDatasetDir,'VideoIO_train.mat'));
% % % 
% % % fprintf('Done.\n')


%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed




AllIOs={VideoEntropy.entropy};

MaxIOs=cellfun(@(x)max(x), AllIOs,'uniformoutput',false);
MaxIOs=cell2mat(MaxIOs);


MinIOs=cellfun(@(x)min(x), AllIOs,'uniformoutput',false);
MinIOs=cell2mat(MinIOs);

Diffs=(MaxIOs-MinIOs);

[s_Diffs,sortedIdx]=sort(Diffs,'descend');


selectedIdx=sortedIdx(1:150);

selectedVideoNames={VideoEntropy(selectedIdx).videoname};