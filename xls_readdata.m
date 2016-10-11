

datadir='new_subjects';

files=dir(fullfile(datadir,'*.xlsx'));

files={files.name};

for i=1:1:length(files)
    data=xlsread(fullfile(datadir, files{i}));
    [~,stem_name,~]= fileparts(files{i});
    save(sprintf('%.09d.mat', str2num( stem_name)),'data');
    
end