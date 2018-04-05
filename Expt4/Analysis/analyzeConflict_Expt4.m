% analyze TR Conflict Data - Experiment 1
clear all
load ConflictDataRawCompact_Expt4

%% sliding-window analysis
RTmax = .6; % maximum RT to consider
TOL = 45; % angle tolerance on what is considered a reach error
xplot = [0:.001:RTmax]; % points to compute sliding window around
w = .05; % 50 ms sliding window size

for c=1:6
    d{c}.hit_symb = abs(d{c}.reachErr_symb)<TOL;
    d{c}.hit_spat = abs(d{c}.reachErr_spat)<TOL;
    d{c}.hit_col = abs(d{c}.reachErr_col)<TOL;
    
    % congruent/incongruent
    if(c>=4)
        d{c}.congruent.hit_symb = abs(d{c}.congruent.reachErr_symb)<TOL;
        d{c}.congruent.hit_spat = abs(d{c}.congruent.reachErr_spat)<TOL;
        d{c}.congruent.hit_col = abs(d{c}.congruent.reachErr_col)<TOL;
        d{c}.incongruent.hit_symb = abs(d{c}.incongruent.reachErr_symb)<TOL;
        d{c}.incongruent.hit_spat = abs(d{c}.incongruent.reachErr_spat)<TOL;
        d{c}.incongruent.hit_col = abs(d{c}.incongruent.reachErr_col)<TOL;
    end
    
    for s=1:d{c}.Nsubjs
        d{c}.phit_symb(s,:) = sliding_window(d{c}.RT(s,:),d{c}.hit_symb(s,:),xplot,w);
        d{c}.phit_spat(s,:) = sliding_window(d{c}.RT(s,:),d{c}.hit_spat(s,:),xplot,w);
        d{c}.phit_col(s,:) = sliding_window(d{c}.RT(s,:),d{c}.hit_col(s,:),xplot,w);
        
        % congruent/incongruent
        if(c>=4)
            d{c}.congruent.phit_symb(s,:) = sliding_window(d{c}.congruent.RT(s,:),d{c}.congruent.hit_symb(s,:),xplot,w);
            d{c}.congruent.phit_spat(s,:) = sliding_window(d{c}.congruent.RT(s,:),d{c}.congruent.hit_spat(s,:),xplot,w);
            d{c}.congruent.phit_col(s,:) = sliding_window(d{c}.congruent.RT(s,:),d{c}.congruent.hit_col(s,:),xplot,w);
            d{c}.incongruent.phit_symb(s,:) = sliding_window(d{c}.incongruent.RT(s,:),d{c}.incongruent.hit_symb(s,:),xplot,w);
            d{c}.incongruent.phit_spat(s,:) = sliding_window(d{c}.incongruent.RT(s,:),d{c}.incongruent.hit_spat(s,:),xplot,w);
            d{c}.incongruent.phit_col(s,:) = sliding_window(d{c}.incongruent.RT(s,:),d{c}.incongruent.hit_col(s,:),xplot,w);
        end
    end
end

save ConflictData_Expt4_sw d xplot

%% model fits

