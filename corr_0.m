% statistical test 2
% find correlation between
%

close all
clear;
clc;

addpath('~/Dev/ZFunc/export_figure/')

load GregPick.mat
load VideoIO_35.mat
load VideoInformation35.mat
load engagement_35.mat

% hyper-parameters:
cut_range=10; %cut 10 frames


n_subjects=13;

interestingness=interestingness/n_subjects;


delay=zeros(length(selectedVideoNames),3);

for i=1:1:length(selectedVideoNames)
    assert(strcmp(selectedVideoNames{i},VideoInformation(i).videoname) && strcmp(VideoInformation(i).videoname, VideoEntropy(i).videoname))
    
    io_score=VideoEntropy(i).entropy';
    max_eng=most_engagement{i}/n_subjects;
    min_eng=lest_engagement{i}/n_subjects;
    
    % when processing, cut the range:
    io_score=io_score(cut_range:end-cut_range);
    max_eng=max_eng(cut_range:end-cut_range);
    min_eng=min_eng(cut_range:end-cut_range);
        len=length(io_score);

    
    diff_eng=max_eng-min_eng;
    
    corrs_io_max = xcorr(io_score',max_eng');
    [~,I]=max(corrs_io_max);
        delay(i,1)=I-len;

    corrs_io_min = xcorr(io_score',min_eng');
    
    [~,I]=max(corrs_io_min);
        delay(i,2)=I-len;
    corrs_io_diff= xcorr(io_score',diff_eng');
    
    [~,I]=max(corrs_io_diff);
        delay(i,3)=I-len;
    

    
end