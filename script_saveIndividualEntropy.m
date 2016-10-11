
saveDir='IOs';
if ~exist(saveDir,'dir')
   mkdir(saveDir) 
end


for i=1:1:247
    
    name=[VideoEntropy(i).videoname,'.mat'];
    IOScore=VideoEntropy(i).entropy;
    save(fullfile(saveDir,name),'IOScore');
    
    
end