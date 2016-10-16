% statistical test 4
% draw the relationship between io-scores vs. max-min scores


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
smooth_span=24;
percentile=25;
interestingness_thres=0;


draw=false;
vis=false;
if draw
    figure;
    if ~vis
        set(gcf,'visible','off');
    end
end




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
    % when processing, cut the range:
    io_score=smooth(  io_score(cut_range:end-cut_range),smooth_span);
    max_eng=smooth( max_eng(cut_range:end-cut_range),smooth_span);
    min_eng=smooth( min_eng(cut_range:end-cut_range),smooth_span);
    
    diff_eng=max_eng-min_eng;
    keep_idx= cut_range:len-cut_range;

%     io_score
%     dio_score= io_score(2:end)-io_score(1:end-1);
     io_scores{i}=io_score;
     diff_engs{i}=diff_eng;
    
    
    %
    %
    %
    %
    %
    %
    %
    %         [sorted_diff_eng, idx_diff_eng]=sort(diff_eng,'descend');
    %         percentil_n = round(length(io_score) * percentile );
    %
    %         top_picked_io= io_score(idx_diff_eng(1:percentil_n));
    % %         =mean(io_score);
    %         mean_io(i)=mean( io_score(idx_diff_eng(percentil_n+1:end)));
    %         keep_idx= keep_idx(idx_diff_eng);
    %         io_score=io_score(idx_diff_eng);
    %         if draw
    %             plot(keep_idx(1:percentil_n), io_score(1:percentil_n),'s','MarkerSize',15,'MarkerFaceColor',[1,0,0])
    %             plot(1:len,mean_io(i)*ones(len,1),'s','MarkerSize',5,'MarkerFaceColor',[0,0,1]);
    %             title( sprintf('%.02d: top-diff: %.2f \t mean: %.2f, interestingess: %.2f',i, mean(top_picked_io), mean_io(i), interestingness(i)));
    %             hold off
    %             img=export_fig;
    %             imwrite(img, sprintf('imgs_diff_max_mean_io_score/%02d_%02d.png', percentile*100,i));
    %         end
    %         diff_io(i,1)=mean(top_picked_io);
    %         fprintf( '%.2f \t img: %.2d \t  %.2f\n',  percentile, i, diff_io(i,1)-mean_io(i))
    
end
io_scores_vec=cat(1, io_scores{:});
diff_engs_vec=cat(1,diff_engs{:});
correlation = corr(io_scores_vec, diff_engs_vec);
plot(io_scores_vec, diff_engs_vec,'r.')

xlabel('io-score')
ylabel('engagement')
title(sprintf( 'io-score vs engagement, overall correlation: %.2f',correlation))




