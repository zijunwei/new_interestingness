
% pick the regions with engagment > 0.8, 
% also pick the regions with engagment <0.8, visualize them
% io-agreement
% https://flowingdata.com/2008/02/15/how-to-read-and-use-a-box-and-whisker-plot/
% formal final version with some modification...

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
pick_thres= 10/13  ;


draw=false;
vis=false;
if draw
    figure;
    if ~vis
        set(gcf,'visible','off');
    end
end





pp=zeros(100,1);
% for percentile=1:1:100
percentile=100;

% for pick_thres=0.76:0.0001:0.77
    [io_scores, diff_engs]=deal(cell(length(selectedVideoNames),1));

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
%     io_score=smooth(  io_score(cut_range:end-cut_range),smooth_span);
%     max_eng=smooth( max_eng(cut_range:end-cut_range),smooth_span);
%     min_eng=smooth( min_eng(cut_range:end-cut_range),smooth_span);
    io_score=(  io_score(cut_range:end-cut_range));
    max_eng=( max_eng(cut_range:end-cut_range));
    min_eng=( min_eng(cut_range:end-cut_range));

    diff_eng=max_eng-min_eng;
    
    diff_eng=diff_eng(delay_frame+1:end);

    io_score=io_score(1:end-delay_frame);
    
    picked_ones= find (abs(diff_eng)>=pick_thres-eps);
    
    diff_eng=diff_eng(picked_ones);
    io_score=io_score(picked_ones);
    
    
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

fprintf('%.d \t %.2f, %.2f \t %.2f\n',percentile,r(1,2),p(1,2),length(io_scores_vec))



data1=io_scores_vec(diff_engs_vec>=0);
data2=io_scores_vec(diff_engs_vec<=0);


dof= length(data1)+length(data2)-2;
alpha=[0.01];


x1_bar=mean(data1);
x2_bar=mean(data2);

s1=std(data1);
s2=std(data2);

n1=length(data1);
n2=length(data2);

t=(x1_bar - x2_bar) /  sqrt(( s1^2*(n1-1)+s2^2*(n2-1) ) / dof  * (1.0/n1 + 1.0/n2)) ;
fprintf('t valie %.2f \n',t)


