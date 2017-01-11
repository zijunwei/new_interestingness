
% pick the regions with engagment > 0.8, draw quantile on io-agreement
% also pick the regions with engagment <0.8, draw the quantile on
% io-agreement


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
n_eng_subjects=13;
interestingness=interestingness/n_eng_subjects;
smooth_span=5;
interestingness_thres=0;
delay_frame=0;

draw=false;
vis=false;
if draw
    figure;
    if ~vis
        set(gcf,'visible','off');
    end
end




[io_scores, diff_engs]=deal(cell(length(selectedVideoNames),1));

pp=zeros(100,1);
% for percentile=1:1:100
percentile=100;
for i=1:1:length(selectedVideoNames)
    assert(strcmp(selectedVideoNames{i},VideoInformation(i).videoname) && strcmp(VideoInformation(i).videoname, VideoEntropy(i).videoname))
    
    io_score=VideoEntropy(i).entropy';
    max_eng=most_engagement{i}/n_eng_subjects;
    min_eng=lest_engagement{i}/n_eng_subjects;
    len=length(io_score);
    
    
    
    if draw
        plot(1:len,io_score,'LineWidth',2,'Color','k')
        hold on
        plot(1:len,max_eng,'LineWidth',2,'Color','r');
        plot(1:len,min_eng,'LineWidth',2,'Color','b')
    end
    %     % when processing, cut the range:
    io_score=smooth(  io_score(cut_range:end-cut_range),smooth_span);
    max_eng=smooth( max_eng(cut_range:end-cut_range),smooth_span);
    min_eng=smooth( min_eng(cut_range:end-cut_range),smooth_span);
    diff_eng=max_eng-min_eng;
    
    %     diff_eng=diff_eng(delay_frame+1:end);
    
    min_eng=min_eng(delay_frame+1:end);
    
    diff_eng=min_eng;
    io_score=io_score(1:end-delay_frame);
    
    
    
    %
    %
    %     io_score=(  io_score(cut_range:end-cut_range));
    %     max_eng=( max_eng(cut_range:end-cut_range));
    %     min_eng=( min_eng(cut_range:end-cut_range));
    
    keep_idx= cut_range:len-cut_range;
    
    
    [~,top_idx] = sort(io_score,'descend');
    
    keep_percentile = top_idx(1: floor(percentile/100*length(top_idx)));
    
    io_score=io_score(keep_percentile);
    diff_eng=diff_eng(keep_percentile);
    
    io_scores{i}=io_score;
    diff_engs{i}=diff_eng;
    
    
end
io_scores_vec=cat(1, io_scores{:});
diff_engs_vec=cat(1,diff_engs{:});
% correlation = corr(io_scores_vec, diff_engs_vec);
[r,p]=corrcoef(io_scores_vec,diff_engs_vec,'rows','pairwise');

fprintf('%.d \t %.2f, %.2f\n',percentile,r(1,2),p(1,2))
pp(percentile)=r(1,2);
plot(io_scores_vec, diff_engs_vec, 'r*','markersize', 2)

axis square
xlabel('io-score')
ylabel('engagement')
title(sprintf( 'io-score vs engagement, overall correlation: %.2f, p value %.2f',r(1,2), p(1,2)))

% end


