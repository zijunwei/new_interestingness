% create all the labels of the videos into one matrix
clear
split='train';
actionClasses={'AnswerPhone','DriveCar','Eat','FightPerson','GetOutCar','HandShake','HugPerson','Kiss','Run','SitDown','SitUp','StandUp'};

datasetup=setup();
AnnoFiles=z_getFileIdsfromDir( fullfile(datasetup.videoDatasetDir,'ClipSets'),'.txt');


listofFiles=dir( fullfile(datasetup.videoDir,'actioncliptrain*'));
listofFiles={listofFiles.name};

