% compute the function max-min-value(io-threshold)

close all
clear;
clc;

addpath('~/Dev/ZFunc/export_figure/')
addpath('~/Dev/ICA/')

load GregPick.mat
load VideoIO_35.mat
load VideoInformation35.mat
load engagement_35.mat

% hyper-parameters:
cut_range=10; %cut 10 frames


n_subjects=13;

interestingness=interestingness/n_subjects;



all_scores=[];
all_diffs=[];
diff_io=zeros(length(selectedVideoNames),2);
% figure
    for i=1:1:length(selectedVideoNames)
        assert(strcmp(selectedVideoNames{i},VideoInformation(i).videoname) && strcmp(VideoInformation(i).videoname, VideoEntropy(i).videoname))
        
        io_score=VideoEntropy(i).entropy';
        max_eng=most_engagement{i}/n_subjects;
        min_eng=lest_engagement{i}/n_subjects;
        len=length(io_score);
        
        
    
        % when processing, cut the range:
        io_score=io_score(cut_range:end-cut_range);
        max_eng=max_eng(cut_range:end-cut_range);
        min_eng=min_eng(cut_range:end-cut_range);
        
        
        
        diff_eng=max_eng-min_eng;
        
        all_scores=[all_scores;io_score];
        all_diffs=[all_diffs;diff_eng];
        
        
%         plot(io_score, diff_eng,'r*');
%         hold on
        
        
       
  
        
        
    end
    
    
    
