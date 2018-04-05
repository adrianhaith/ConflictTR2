function [data] = loadTJsubjData(subjID,blocknames)
% load a single subject's timed response target jump data
%
% Input:    subjname    - string containing subject ID, e.g. 'S01'
%           blocknames  - cell array containing blocknames to be loaded
%                         together and concatenated, e.g. {'B1','B2'}
%
% Output:   data - data structure containing data from these blocks

Nblocks = length(blocknames);
trial = 1;
tFile = [];
for blk=1:Nblocks
    path = ['../Data/',subjID,'/',blocknames{blk}]; % data path
    disp(path);
    tF = dlmread([path,'/tFile.tgt']);
    fnames = dir(path);
    Ntrials = size(tF,1);
    for i=1:Ntrials
        d = dlmread([path,'/',fnames(i+2).name],' ',6,0);
        X{trial} = d(3:4:end,3); % hand X location
        Y{trial} = d(3:4:end,4); % hand Y location
        trial = trial+1;
    end
    tFile = [tFile; tF];
end
X0 = tFile(1,2); % start position x
Y0 = tFile(1,3); % start position y

%data.targPos = tFile(:,6:7)-tFile(:,2:2);
data.goalAng_symb = -tFile(:,14); % goal angle
data.goalAng_spat = -tFile(:,10); % angle of spatial cue
data.targ_appear_time = tFile(:,13);

data.Ntrials = size(tFile,1);

% center data on (0,0) start position
 for i=1:data.Ntrials % iterate through all trials
     data.handPos{i} = [X{i}'-X0; Y{i}'-Y0];
 end
data.tFile = tFile; % save tFile within the data structure
data = getErr_fixedT(data);

data.reachErr_spat = data.reachDir'-data.goalAng_spat;
data.reachErr_spat = mod(data.reachErr_spat,360)-180;

data.reachErr_symb = data.reachDir'-data.goalAng_symb;
data.reachErr_symb = mod(data.reachErr_symb,360)-180;


