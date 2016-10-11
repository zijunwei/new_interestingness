function sAUC=z_InterObserver(gazePosition,videoFrame,sigma)
%
if nargin<3
    sigma=20;
end

allId=1:1:size(gazePosition,1);
sAUC=zeros(size(gazePosition,1),1);
for i=1:1:size(gazePosition,1)
    selectedId=i;
    otherId=setdiff(allId,selectedId);
    oMap=drawFixBMap(videoFrame,gazePosition(otherId,:));
    tMap=drawFixBMap(videoFrame,gazePosition(selectedId,:));
    tMap=run_antonioGaussian(tMap,sigma);
    tMap=tMap/max(tMap(:));
    sAUC(i)=AUC_Judd(tMap,oMap);
    
end
sAUC=mean(sAUC);
    


end