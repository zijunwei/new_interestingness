function  [validvideoNames,video_res_xs,video_res_ys,video_frates]=read_resFile(resFilePath)
% read the resolution file


resFileId=fopen( fullfile(resFilePath,'resolution.txt'));
videoParams=textscan(resFileId,'%s\t%d\t%d\t%f');
fclose(resFileId);

validvideoNames=videoParams{1};
video_res_xs=videoParams{2};
video_res_ys=videoParams{3};
video_frates=videoParams{4};

end