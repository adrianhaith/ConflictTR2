% load and pre-process TR conflict data
clear all

addpath ../../Expt1/Analysis
addpath ../../Expt1/Analysis/ExtraFns
%
%{
subjname = {'S102','S103','S104','S105','S106','S107','S108'};
condStr = {'Spatial','Symbolic','Conflict'};
%addpath ExtraFns

for i = 1:length(subjname);
    data{i,1} = loadTRsubjData(subjname{i},{'spat_ForcedRT_1','spat_ForcedRT_2','spat_ForcedRT_3'});
    data{i,2} = loadTRsubjData(subjname{i},{'arrow_ForcedRT_1','arrow_ForcedRT_2','arrow_ForcedRT_3'});
    data{i,3} = loadTRsubjData(subjname{i},{'col_ForcedRT_1','col_ForcedRT_2','col_ForcedRT_3'});
    data{i,4} = loadTRsubjData(subjname{i},{'col_all_ForcedRT_1','col_all_ForcedRT_2','col_all_ForcedRT_3','col_all_ForcedRT_4','col_all_ForcedRT_5','col_all_ForcedRT_6'});

    for c=1:4
        data{i,c}.goalAng_col = data{i,c}.goalAng_symb;
        data{i,c}.reachErr_col = data{i,c}.reachErr_symb;
    end
end


save ConflictDataRaw_Expt3
%}
%%
clear all
load ConflictDataRaw_Expt3
%%
Nc = 4;
% figure out symbol goals and hit rate in conflict
for s=1:length(subjname)
    symb_key(s,1) = NaN; % arrow_key maps between image numbers and arrow directions
    for i=1:4
        ii = find(data{s,2}.tFile(:,11)==i+8); 
        symb_key(s,i+1) = data{s,2}.tFile(ii(1),14);
    end
    % apply to conflict block
    for i=[1 3] % no arrow blocks
        data{s,i}.goalAng_symb = NaN*ones(data{s,i}.Ntrials,1)';
    end
    for i=[2 4] % arrow blocks
        data{s,i}.goalAng_symb = symb_key(s,data{s,i}.tFile(:,11)-8*(data{s,i}.tFile(:,11)>0)+1);
    end
    %data{s,3}.goalDir_symb = NaN*ones(data{s,3}.Ntrials,1)';
    %data{s,4}.goalDir_symb = symb_key(s,data{s,4}.tFile(:,15)+1);
    for i=1:Nc
        data{s,i}.goalAng_symb = -mod(data{s,i}.goalAng_symb,360);
        data{s,i}.reachErr_symb = data{s,i}.reachDir-data{s,i}.goalAng_symb;
        data{s,i}.reachErr_symb = mod(data{s,i}.reachErr_symb,360)-180;
    end
end

save ConflictDataRaw_Expt3

%% convert to compact format for analysis
%

clear all
load ConflictDataRaw_Expt3
for s=1:length(subjname)
    for c=1:4
        d{c}.RT(s,:) = data{s,c}.RT;
        d{c}.reachDir(s,:) = data{s,c}.reachDir;
        d{c}.goalAng_symb(s,:) = data{s,c}.goalAng_symb;
        d{c}.goalAng_spat(s,:) = data{s,c}.goalAng_spat;
        d{c}.goalAng_col(s,:) = data{s,c}.goalAng_col;
        d{c}.peakVel(s,:) = data{s,c}.pkVel;
        d{c}.reachErr_spat(s,:) = data{s,c}.reachErr_spat;
        d{c}.reachErr_symb(s,:) = data{s,c}.reachErr_symb;
        d{c}.reachErr_col(s,:) = data{s,c}.reachErr_col;
    end
end

for c=1:4
    d{c}.Nsubjs = size(d{c}.RT,1);
end


%% split into congruent/incongruent trials
% NB - currently hacked as don't know which trials are catch trials. Just
% taking first subset of trials to make up right number. Need to fix later
for s=1:length(subjname)
    for c=4
        icongruent = find(d{c}.goalAng_spat(s,:) == d{c}.goalAng_symb(s,:) & d{c}.goalAng_spat(s,:) == d{c}.goalAng_col(s,:));
        if(length(icongruent)>24)
            icongruent = icongruent(1:24);
        end
        iincongruent = find(d{c}.goalAng_spat(s,:) ~= d{c}.goalAng_symb(s,:) & d{c}.goalAng_spat(s,:) ~= d{c}.goalAng_col(s,:) & d{c}.goalAng_col(s,:) ~= d{c}.goalAng_symb(s,:));
        if(length(iincongruent)>144)
            iincongruent = iincongruent(1:144);
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
        
        d{c}.congruent.reachErr_col(s,:) = d{c}.reachErr_col(s,icongruent);
        d{c}.incongruent.reachErr_col(s,:) = d{c}.reachErr_col(s,iincongruent);
    end
end

save ConflictDataRawCompact_Expt3 d
%}