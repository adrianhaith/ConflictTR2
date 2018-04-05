% fit model to aggregate data
clear all
load triple_conflict_data
addpath ExtraFns

Nsubj = size(d,1);
xplot = [0:.001:1];
%pInit = [.25 .03 .95 .3 .04 .95 .4 .04 .7 .25 .7 .9]; % subj 6
pInit = [.22 .03 .8 .3 .04 .8 .35 .06 .7 .25 .7 .9]
% bounds
UB = [.8 .4 1 .8 .4 1 .8 .4 1 .5 1 1];
LB = [0 .01 .5 0 .01 .5 0 .01 .5 0 0 0];

% equality constraints
Aeq = [0 0 0 0 0 0 0 0 0 1 0 0; % initial error is .25;
    0 0 1 0 0 0 0 0 0 0 0 0; % asymptotic error for A = 1 (to avoid redundancy)
    0 0 0 0 0 1 0 0 0 0 0 0]; % asymptotic error for B = 1 (to avoid redundancy)
Beq = [.25; 1; 1];

% inequality constraints
A = [1 0 0 -1 0 0 0 0 0 0 0 0; % means must be staggered appropriately
    0 0 0 1 0 0 -1 0 0 0 0 0];
B = [0;0];

RTall = [];
responseAll = [];

for s=1:Nsubj
    RTall = [RTall d(s,4).diff.RT];
    responseAll = [responseAll d(s,4).diff.response];
end

like_fun = @(params) habit_lik(RTall,responseAll,params);
LLinit = like_fun(pInit);
[pOpt, LLopt] = fmincon(like_fun,pInit,A,B,Aeq,Beq,LB,UB);
[~, Lv{s}] = like_fun(pOpt);
[~, LvI{s}] = like_fun(pInit);
%pOpt(s,11) = 0;
[model_fit fit_noconfl] = getResponseProbs3(xplot,pOpt);

%%
% sliding window on aggregate data
w = .05;
p_spat = sliding_window(RTall, responseAll==1, xplot, w);
p_arrow = sliding_window(RTall, responseAll==2, xplot, w);
p_col = sliding_window(RTall, responseAll==3, xplot, w);

figure(1); clf; hold on
subplot(3,1,1); hold on
plot(xplot,p_spat,'r','linewidth',2)
plot(xplot,p_arrow,'g','linewidth',2)
plot(xplot,p_col,'m','linewidth',2)
axis([0 .6 0 1])

subplot(3,1,2); hold on
plot(xplot,model_fit(1,:),'r','linewidth',2)
plot(xplot,model_fit(2,:),'g','linewidth',2)
plot(xplot,model_fit(3,:),'m','linewidth',2)
axis([0 .6 0 1])

subplot(3,1,3); hold on
plot(xplot,fit_noconfl(1,:),'r','linewidth',2)
plot(xplot,fit_noconfl(2,:),'g','linewidth',2)
plot(xplot,fit_noconfl(3,:),'m','linewidth',2)
axis([0 .6 0 1])
