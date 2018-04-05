% analyze TR Conflict Data - Experiment 1
clear all
load ConflictDataRawCompact_Expt1
addpath ExtraFns
%% sliding-window analysis
RTmax = .6; % maximum RT to consider
TOL = 45; % angle tolerance on what is considered a reach error
xplot = [0:.001:RTmax]; % points to compute sliding window around
w = .05; % 50 ms sliding window size

for c=1:3
    d{c}.xplot = xplot;
    d{c}.hit_symb = abs(d{c}.reachErr_symb)<TOL;
    d{c}.hit_spat = abs(d{c}.reachErr_spat)<TOL;
    
    % congruent/incongruent
    if(c==3)
        d{c}.congruent.hit_symb = abs(d{c}.congruent.reachErr_symb)<TOL;
        d{c}.congruent.hit_spat = abs(d{c}.congruent.reachErr_spat)<TOL;
        d{c}.incongruent.hit_symb = abs(d{c}.incongruent.reachErr_symb)<TOL;
        d{c}.incongruent.hit_spat = abs(d{c}.incongruent.reachErr_spat)<TOL;
    end
    
    for s=1:d{c}.Nsubjs
        d{c}.phit_symb(s,:) = sliding_window(d{c}.RT(s,:),d{c}.hit_symb(s,:),xplot,w);
        d{c}.phit_spat(s,:) = sliding_window(d{c}.RT(s,:),d{c}.hit_spat(s,:),xplot,w);
        
        % congruent/incongruent
        if(c==3)
            d{c}.congruent.phit_symb(s,:) = sliding_window(d{c}.congruent.RT(s,:),d{c}.congruent.hit_symb(s,:),xplot,w);
            d{c}.congruent.phit_spat(s,:) = sliding_window(d{c}.congruent.RT(s,:),d{c}.congruent.hit_spat(s,:),xplot,w);
            
            d{c}.incongruent.phit_symb(s,:) = sliding_window(d{c}.incongruent.RT(s,:),d{c}.incongruent.hit_symb(s,:),xplot,w);
            d{c}.incongruent.phit_spat(s,:) = sliding_window(d{c}.incongruent.RT(s,:),d{c}.incongruent.hit_spat(s,:),xplot,w);
            
        end
        
        % response id for incongruent
        if(c==3)
            d{c}.incongruent.response = 3*ones(size(d{c}.incongruent.hit_spat));
            d{c}.incongruent.response(d{c}.incongruent.hit_spat) = 1;
            d{c}.incongruent.response(d{c}.incongruent.hit_symb) = 2;
        elseif (c==1)
            d{c}.response = 2*ones(size(d{c}.hit_spat));
            d{c}.response(d{c}.hit_spat) = 1;
        else
            d{c}.response = 2*ones(size(d{c}.hit_spat));
            d{c}.response(d{c}.hit_symb) = 1;
        end
    end
    
    
    
end


save ConflictData_Expt1_sw d xplot


