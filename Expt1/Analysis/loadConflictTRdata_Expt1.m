% load and pre-process TR conflict data
clear all
addpath ExtraFns
%{
subjname = {'S101','S102','S103','S104','S105','S106','S107','S108'};
condStr = {'Spatial','Symbolic','Conflict'};
addpath ExtraFns

for i = 1:length(subjname);
    data{i,1} = loadTRsubjData(subjname{i},{'spat_ForcedRT_1','spat_ForcedRT_2'});
    data{i,2} = loadTRsubjData(subjname{i},{'symb_ForcedRT_1','symb_ForcedRT_2'});
    data{i,3} = loadTRsubjData(subjname{i},{'conf_ForcedRT_1','conf_ForcedRT_2'});
end

save ConflictDataRaw_Expt1
%}
%% convert to compact format for analysis
load ConflictDataRaw_Expt1
for s=1:length(subjname)
    for c=1:3
        rng = [9:110 119:220]; % ignore "warm-up" trials (8 at start of each block)
        d{c}.RT(s,:) = data{s,c}.RT(rng);
        d{c}.reachDir(s,:) = data{s,c}.reachDir(rng);
        d{c}.goalAng_symb(s,:) = data{s,c}.goalAng_symb(rng);
        d{c}.goalAng_spat(s,:) = data{s,c}.goalAng_spat(rng);
        d{c}.peakVel(s,:) = data{s,c}.pkVel(rng);
        d{c}.reachErr_spat(s,:) = data{s,c}.reachErr_spat(rng);
        d{c}.reachErr_symb(s,:) = data{s,c}.reachErr_symb(rng);
    end
end

for c=1:3
    d{c}.Nsubjs = size(d{c}.RT,1);
end

%% split into congruent/incongruent trials
% NB - currently hacked as don't know which trials are catch trials. Just
% taking first subset of trials to make up right number. Need to fix later
for s=1:length(subjname)
    icongruent = find(d{3}.goalAng_spat(s,:) == d{3}.goalAng_symb(s,:));
    if(length(icongruent)>24)
        icongruent = icongruent(1:24);
    end
    iincongruent = find(d{3}.goalAng_spat(s,:) ~= d{3}.goalAng_symb(s,:));   
    if(length(iincongruent)>72)
        iincongruent = iincongruent(1:72);
    end
    
    d{3}.congruent.RT(s,:) = d{3}.RT(s,icongruent);
    d{3}.incongruent.RT(s,:) = d{3}.RT(s,iincongruent);
    
    d{3}.congruent.reachDir(s,:) = d{3}.reachDir(s,icongruent);
    d{3}.incongruent.reachDir(s,:) = d{3}.reachDir(s,iincongruent);
    
    d{3}.congruent.peakVel(s,:) = d{3}.peakVel(s,icongruent);
    d{3}.incongruent.peakVel(s,:) = d{3}.peakVel(s,iincongruent);
    
    d{3}.congruent.reachErr_spat(s,:) = d{3}.reachErr_spat(s,icongruent);
    d{3}.incongruent.reachErr_spat(s,:) = d{3}.reachErr_spat(s,iincongruent);
    
    d{3}.congruent.reachErr_symb(s,:) = d{3}.reachErr_symb(s,icongruent);
    d{3}.incongruent.reachErr_symb(s,:) = d{3}.reachErr_symb(s,iincongruent);
    
end
%}

save ConflictDataRawCompact_Expt1 d