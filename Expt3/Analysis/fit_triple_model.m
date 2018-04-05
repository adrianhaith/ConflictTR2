% fit triple-conflict data
clear all
load triple_conflict_data
Nsubj = size(d,1);

xplot = [0:.001:1];
%pInit = [.25 .03 .95 .3 .04 .95 .4 .04 .7 .25 .7 .9]; % subj 6
pInit = [.22 .03 .8 .3 .04 .8 .35 .06 .7 .25 .7 .9]
% bounds
UB = [.8 .4 1 .8 .4 1 .8 .4 1 .5 1 1];
LB = [0 .01 .5 0 .01 .5 0 .01 .5 0 0 0];

% equality constraints
Aeq = [0 0 0 0 0 0 0 0 0 1 0 0]; % initial error is .25;
Beq = [.25];

% inequality constraints
A = [1 0 0 -1 0 0 0 0 0 0 0 0; % means must be staggered appropriately
    0 0 0 1 0 0 -1 0 0 0 0 0];
B = [0;0];



presponse = getResponseProbs3(xplot,pInit);

habit_lik(d(1,4).diff.RT,d(1,4).diff.response,pInit)

for s=1:Nsubj
    
    like_fun = @(params) habit_lik(d(s,4).diff.RT,d(s,4).diff.response,params);
    LLinit(s) = like_fun(pInit);
    [pOpt(s,:), LLopt(s)] = fmincon(like_fun,pInit,A,B,Aeq,Beq,LB,UB);
    [~, Lv{s}] = like_fun(pOpt(s,:));
    [~, LvI{s}] = like_fun(pInit);
    %pOpt(s,11) = 0;
    [model_fit(:,:,s) fit_noconfl(:,:,s)] = getResponseProbs3(xplot,pOpt(s,:));
    [model_fitI(:,:,s) init_noconfl(:,:,s)] = getResponseProbs3(xplot,pInit);
    
    figure(30+s); clf; hold on
    subplot(2,1,1); hold on
    plot(xplot,d(s,4).diff.phit_spat,'r')
    plot(xplot,d(s,4).diff.phit_symb,'g')
    plot(xplot,d(s,4).diff.phit_col,'m')
    plot(xplot,1-d(s,4).diff.phit_spat-d(s,4).diff.phit_symb-d(s,4).diff.phit_col,'c')
    
    plot(xplot,model_fit(1,:,s),'r','linewidth',2)
    plot(xplot,model_fit(2,:,s),'g','linewidth',2)
    plot(xplot,model_fit(3,:,s),'m','linewidth',2)
    plot(xplot,model_fit(4,:,s),'c','linewidth',2)
    
    plot(xplot,fit_noconfl(1,:,s),'r--')
    plot(xplot,fit_noconfl(2,:,s),'g--')
    plot(xplot,fit_noconfl(3,:,s),'m--')
    
    title('MLE')
    
    subplot(2,1,2); hold on
    plot(xplot,d(s,4).diff.phit_spat,'r')
    plot(xplot,d(s,4).diff.phit_symb,'g')
    plot(xplot,d(s,4).diff.phit_col,'m')
    plot(xplot,1-d(s,4).diff.phit_spat-d(s,4).diff.phit_symb-d(s,4).diff.phit_col,'c')
    
    
    plot(xplot,model_fitI(1,:,s),'r','linewidth',2)
    plot(xplot,model_fitI(2,:,s),'g','linewidth',2)
    plot(xplot,model_fitI(3,:,s),'m','linewidth',2)
    plot(xplot,model_fitI(4,:,s),'c','linewidth',2)
    title('Init')
    % plot contributions to the likelihood
    Lv{s}(Lv{s}==0)=NaN;
    figure(2); clf; hold on
    subplot(2,1,1); hold on
    plot(d(s,4).diff.RT,log(Lv{s}(1,:)),'ro')
    plot(d(s,4).diff.RT,log(Lv{s}(2,:)),'go')
    plot(d(s,4).diff.RT,log(Lv{s}(3,:)),'mo')
    plot(d(s,4).diff.RT,log(Lv{s}(4,:)),'co')
    title('MLE')
    
   -[ nansum(log(Lv{s}),2) nansum(log(LvI{s}),2)]
   
    subplot(2,1,2); hold on
    plot(d(s,4).diff.RT,log(LvI{s}(1,:)),'ro')
    plot(d(s,4).diff.RT,log(LvI{s}(2,:)),'go')
    plot(d(s,4).diff.RT,log(LvI{s}(3,:)),'mo')
    plot(d(s,4).diff.RT,log(LvI{s}(4,:)),'co')
    title('initial')
end
