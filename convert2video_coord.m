function loc_video=convert2video_coord (loc_screen, video_res)
% according to readme.txt, convert location in screen to location in videos
% video_res [x,y];
% loc_screen [x,y];
% loc_video [x,y];
% Zijun Wei




% screen_res are from geomtry.txt

screen_res_x=1280.0;
screen_res_y=1024.0;


video_res_x=double( video_res(1));
video_res_y=double( video_res(2));



a= video_res_x/ screen_res_x;
b=  ( screen_res_y-video_res_y/a)/2;
loc_video=[a*loc_screen(:,1),a*(loc_screen(:,2)-b)];

end