% statistical test 1
% find the maximum and minimum of differences
% compute their max and min

close all
clear;
clc;

addpath('~/Dev/ZFunc/export_figure/')

load GregPick.mat
load VideoIO_35.mat
load VideoInformation35.mat
load engagement_35.mat

% hyper-parameters:
percentile=0.25;
cut_range=10; %cut 10 frames


n_subjects=13;

interestingness=interestingness/n_subjects;




diff_io=zeros(length(selectedVideoNames),2);
draw=false;
if draw
    figure;
end
for percentile=0.01:0.01:0.25
    for i=1:1:length(selectedVideoNames)
        assert(strcmp(selectedVideoNames{i},VideoInformation(i).videoname) && strcmp(VideoInformation(i).videoname, VideoEntropy(i).videoname))
        
        io_score=VideoEntropy(i).entropy;
        max_eng=most_engagement{i}/n_subjects;
        min_eng=lest_engagement{i}/n_subjects;
        len=length(io_score);
        
        
        
        if draw
            plot(1:len,io_score,'LineWidth',2,'Color','k')
            hold on
            plot(1:len,max_eng,'LineWidth',2,'Color','r');
            plot(1:len,min_eng,'LineWidth',2,'Color','b')
        end
        % when processing, cut the range:
        io_score=io_score(cut_range:end-cut_range);
        max_eng=max_eng(cut_range:end-cut_range);
        min_eng=min_eng(cut_range:end-cut_range);
        
        keep_idx= cut_range:len-cut_range;
        
        
        diff_eng=max_eng-min_eng;
        
        
        
        [sorted_diff_eng, idx_diff_eng]=sort(diff_eng,'descend');
        percentil_n = round(length(diff_eng) * percentile );
        
        top_picked_io= io_score(idx_diff_eng(1:percentil_n));
        bot_picked_io= io_score(idx_diff_eng((end-percentil_n):end));
        keep_idx= keep_idx(idx_diff_eng);
        io_score=io_score(idx_diff_eng);
        if draw
            plot(keep_idx(1:percentil_n), io_score(1:percentil_n),'*','MarkerSize',15,'MarkerFaceColor',[1,0,0])
            plot(keep_idx((end-percentil_n):end),io_score((end-percentil_n):end),'s','MarkerSize',15,'MarkerFaceColor',[0,0,1]);
            title( sprintf('%.02d: top-diff: %.2f \t bot-diff: %.2f, interestingess: %.2f',i, mean(top_picked_io), mean(bot_picked_io), interestingness(i)));
            hold off
            img=export_fig;
            imwrite(img, sprintf('imgs_diff_io_score/%02d_%02d.png', percentile*100,i));
        end
        diff_io(i,1)=max(top_picked_io);
        diff_io(i,2)=max(bot_picked_io);
        
        
    end
    
    fprintf( '%.2f: %.2f\n',  percentile, mean(diff_io(:,1))-mean(diff_io(:,2)))
end