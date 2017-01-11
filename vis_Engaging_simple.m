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


%
%
%%%% Draw
for i=1:1:length(selectedVideoNames)
    indx= z_structfind(VideoEntropy,'videoname',selectedVideoNames{i});
    ento=VideoEntropy(indx).entropy;
    most_eng= most_engagement{i};
    lest_eng=lest_engagement{i};
    figure
    hold on
    title(sprintf('Video: %.02d, # Frames: %.4d, Interesting: %.2f', i, length(ento), interestingness(i)/length(listofSubjectFiles)))
    plot(1:length(ento), ento,'LineWidth',2,'Color','k');
%     plot(1:length(most_eng), most_eng/length(listofSubjectFiles),'LineWidth',2,'Color','r');
%     plot(1:length(lest_eng), lest_eng/length(listofSubjectFiles),'LineWidth',2,'Color','b');
    plot(1:length(lest_eng), (most_eng-lest_eng)/length(listofSubjectFiles),'LineWidth',2,'Color','g')
%     legend('agreement','most-engaging','least-engaging', 'engaging')
    legend('agreement', 'engaging')

img=export_fig;
    imwrite(img, sprintf('imgs_eng/%02d.png',i))
    hold off
    close all



end


