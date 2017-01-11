% statistical test 1
% 
% Not in use any more

close all
clear;
clc;


load GregPick.mat
load VideoIO_35.mat
load VideoInformation35.mat
load engagement_35.mat

% hyper-parameters:
percentile=0.25;

n_subjects=13;

figure;

for i=1:1:length(selectedVideoNames)
    assert(strcmp(selectedVideoNames{i},VideoInformation(i).videoname) && strcmp(VideoInformation(i).videoname, VideoEntropy(i).videoname))
    
    io_score=VideoEntropy(i).entropy;
    max_eng=most_engagement{i}/n_subjects;
    min_eng=lest_engagement{i}/n_subjects;
    diff_eng=max_eng-min_eng;
    len=length(io_score);
    
    
    plot(1:len,io_score ,'LineWidth',2,'Color','k')
    hold on
    plot(1:len,max_eng,'LineWidth',2,'Color','r');
    plot(1:len,min_eng,'LineWidth',2,'Color','b')
    
    
    % only compute the regions that max_eng > min_eng
    
    keep_idx= find( diff_eng>=0);
    
    max_eng=max_eng(keep_idx);
    min_eng=min_eng(keep_idx);
    io_score=io_score(keep_idx);
    
    diff_eng=max_eng-min_eng;
    
    [sorted_diff_eng, idx_diff_eng]=sort(diff_eng,'descend');
    
    percentil_n = round( length(sorted_diff_eng) * percentile );
    
    top_picked_io= io_score(idx_diff_eng(1:percentil_n));
    bot_picked_io= io_score(idx_diff_eng((end-percentil_n):end));
    keep_idx= keep_idx(idx_diff_eng);
    io_score=io_score(idx_diff_eng);
    
    plot(keep_idx(1:percentil_n), io_score(1:percentil_n),'*','MarkerSize',15,'MarkerFaceColor',[1,0,0])
    plot(keep_idx((end-percentil_n):end),io_score((end-percentil_n):end),'s','MarkerSize',15,'MarkerFaceColor',[0,0,1]);
    
     title( sprintf('%.02d: top-mean: %.2f \t bottom-mean: %.2f ',i, mean(top_picked_io), mean(bot_picked_io)));
     hold off
     waitforbuttonpress
    
end