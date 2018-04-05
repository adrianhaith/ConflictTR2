% load and pre-process TR conflict data
clear all

addpath ../../Expt1/Analysis
addpath ../../Expt1/Analysis/ExtraFns
%
%
subjname = {'S101','S102','S104','S105','S106','S107','S108'}; %,'S103'
condStr = {'Spatial','Symbolic','Conflict'};
addpath ExtraFns

for i = 1:length(subjname);
    data{i,1} = loadTRsubjData(subjname{i},{'spat_ForcedRT_1','spat_ForcedRT_2'});
    data{i,2} = loadTRsubjData(subjname{i},{'symb_ForcedRT_1','symb_ForcedRT_2'});
    data{i,3} = loadTRsubjData(subjname{i},{'conf_ForcedRT_1','conf_ForcedRT_2'});
    data{i,4} = loadTRsubjData(subjname{i},{'conf_ForcedRT_Post1','conf_ForcedRT_Post2'});
end

save ConflictDataRaw_Expt2
%}
%% convert to compact format for analysis
clear all
load ConflictDataRaw_Expt2
for s=1:length(subjname)
    for c=1:4
        d{c}.RT(s,:) = data{s,c}.RT;
        d{c}.reachDir(s,:) = data{s,c}.reachDir;
        d{c}.goalAng_symb(s,:) = data{s,c}.goalAng_symb;
        d{c}.goalAng_spat(s,:) = data{s,c}.goalAng_spat;
        d{c}.peakVel(s,:) = data{s,c}.pkVel;
        d{c}.reachErr_spat(s,:) = data{s,c}.reachErr_spat;
        d{c}.reachErr_symb(s,:) = data{s,c}.reachErr_symb;
    end
end

for c=1:4
    d{c}.Nsubjs = size(d{c}.RT,1);
end

%% split into congruent/incongruent trials
%% split into congruent/incongruent trials
% NB - currently hacked as don't know which trials are catch trials. Just
% taking first subset of trials to make up right number. Need to fix later
for s=1:length(subjname)
    for c=[3 4]
        icongruent = find(d{c}.goalAng_spat(s,:) == d{c}.goalAng_symb(s,:));
        if(length(icongruent)>24)
            icongruent = icongruent(1:24);
        end
        iincongruent = find(d{c}.goalAng_spat(s,:) ~= d{c}.goalAng_symb(s,:));
        if(length(iincongruent)>72)
            iincongruent = iincongruent(1:72);
        end
        
        d{c}.congruent.RT(s,:) = d{c}.RT(s,icongruent);
        d{c}.incongruent.RT(s,:) = d{c}.RT(s,iincongruent);
        
        d{c}.congruent.reachDir(s,:) = d{c}.reachDir(s,icongruent);
        d{c}.incongruent.reachDir(s,:) = d{c}.reachDir(s,iincongruent);
        
        d{c}.congruent.peakVel(s,:) = d{c}.peakVel(s,icongruent);
        d{c}.incongruent.peakVel(s,:) = d{c}.peakVel(s,iincongruent);
        
        d{c}.congruent.reachErr_spat(s,:) = d{c}.reachErr_spat(s,icongruent);
        d{c}.incongruent.reachErr_spat(s,:) = d{c}.reachErr_spat(s,iincongruent);
        
        d{c}.congruent.reachErr_symb(s,:) = d{c}.reachErr_symb(s,icongruent);
        d{c}.incongruent.reachErr_symb(s,:) = d{c}.reachErr_symb(s,iincongruent);
    end
end

save ConflictDataRawCompact_Expt2 d