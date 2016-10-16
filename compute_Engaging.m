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

save('engagement_35.mat', 'most_engagement', 'lest_engagement','interestingness');



