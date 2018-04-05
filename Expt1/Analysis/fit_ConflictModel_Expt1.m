% fit conflict model to data from Experiment 1
%

clear all
addpath ../../Fitting
load ConflictData_Expt1_sw

for s=1:d{1}.Nsubjs
    for c=1:2
        model(s,c) = fit_model(d{c}.RT(s,:),d{c}.response(s,:),1);
    end
end
%%
% visualize fit
for c=1:2
    figure(c); clf; hold on
    for s=1:d{1}.Nsubjs
        subplot(2,4,s); hold on
        plot(model(s,c).xplot,model(s,c).presponse')
        if(c==1)
            plot(d{c}.xplot,d{c}.phit_spat(s,:))
        elseif(c==2)
            plot(d{c}.xplot,d{c}.phit_symb(s,:))
        end
    end
end

%% fit conflict condition

for s=1:d{1}.Nsubjs
    model_conflict(s) = fit_model(d{3}.incongruent.RT(s,:),d{3}.incongruent.response(s,:),2);
end

%% visual fits
figure(3); clf; hold on
for s=1:d{1}.Nsubjs
    subplot(2,4,s); hold on
    plot(model_conflict(s).xplot,model_conflict(s).presponse(1,:),'r')
    plot(model_conflict(s).xplot,model_conflict(s).presponse(2,:),'b')
    plot(d{3}.xplot,d{3}.incongruent.phit_spat(s,:),'r')
    plot(d{c}.xplot,d{3}.incongruent.phit_symb(s,:),'b')
end

%% Feedforward Model Predictions
for s=1:d{1}.Nsubjs
    model_conflict(s).predicted.params = [model(s,1).paramsOpt(1:2) model(s,2).paramsOpt(1:3) .25];
    model_conflict(s).predicted.presponse = getResponseProbs(xplot,model_conflict(s).predicted.params,2,1);
end
    
figure(4); clf; hold on
for s=1:d{1}.Nsubjs
    subplot(2,4,s); hold on
    plot(model_conflict(s).xplot,model_conflict(s).predicted.presponse(1,:),'r')
    plot(model_conflict(s).xplot,model_conflict(s).predicted.presponse(2,:),'b')
    plot(d{3}.xplot,d{3}.incongruent.phit_spat(s,:),'r')
    plot(d{c}.xplot,d{3}.incongruent.phit_symb(s,:),'b')
end
    
%% fit model to group data
grp_model(1) = fit_model(reshape(d{1}.RT,1,8*204),reshape(d{1}.response,1,8*204),1)
grp_model(2) = fit_model(reshape(d{2}.RT,1,8*204),reshape(d{2}.response,1,8*204),1)
grp_model(3) = fit_model(reshape(d{3}.incongruent.RT,1,8*72),reshape(d{3}.incongruent.response,1,8*72),2)
    
%% visualize results
figure(5); clf; hold on
subplot(1,2,1); hold on
plot([0 .6],[.25 .25],'k--')
plot(d{1}.xplot,nanmean(d{1}.phit_spat),'r')
plot(d{1}.xplot,grp_model(1).presponse(1,:),'r','linewidth',2)
plot(d{2}.xplot,nanmean(d{2}.phit_symb),'b')
plot(d{2}.xplot,grp_model(2).presponse(1,:),'b','linewidth',2)
axis([0 .6 0 1])

subplot(1,2,2); hold on
plot([0 .6],[.25 .25],'k--')
plot(d{3}.xplot,nanmean(d{3}.phit_spat),'r')
plot(d{3}.xplot,nanmean(d{3}.phit_symb),'b')
%plot(d{3}.xplot,grp_model(3).presponse(1,:),'r','linewidth',2)
%plot(d{3}.xplot,grp_model(3).presponse(2,:),'b','linewidth',2)
plot(d{3}.xplot,nanmean(1-d{3}.incongruent.phit_spat-d{3}.incongruent.phit_symb)/2,'m')
axis([0 .6 0 1])

grp_model(3).predicted.params = [grp_model(1).paramsOpt(1:2) grp_model(2).paramsOpt(1:3) .25];
grp_model(3).predicted.presponse = getResponseProbs(d{3}.xplot,grp_model(3).predicted.params,2,1);
grp_model(3).presponse_congruent = getResponseProbs(d{3}.xplot,grp_model(3).paramsOpt,2,0);

%plot(d{3}.xplot,grp_model(3).predicted.presponse(1,:),'r:','linewidth',2)
%plot(d{3}.xplot,grp_model(3).predicted.presponse(2,:),'b:','linewidth',2)

grp_model(3).predicted.presponse_congruent = getResponseProbs(d{3}.xplot,grp_model(3).predicted.params,2,0);
plot(d{3}.xplot,grp_model(3).predicted.presponse_congruent(1,:),'r:','linewidth',2)
plot(d{3}.xplot,grp_model(3).predicted.presponse_congruent(2,:),'b:','linewidth',2)
plot(d{3}.xplot,grp_model(3).presponse_congruent(1,:),'r','linewidth',2)
plot(d{3}.xplot,grp_model(3).presponse_congruent(2,:),'b','linewidth',2)

%% make little gaussians
figure(6); clf; hold on
grp_model(1).pdf = normpdf(xplot,grp_model(1).paramsOpt(1),grp_model(1).paramsOpt(2));
grp_model(2).pdf = normpdf(xplot,grp_model(2).paramsOpt(1),grp_model(2).paramsOpt(2));
%grp_model(1).pdf = normpdf(xplot,grp_model(1).paramsOpt(1),grp_model(1).paramsOpt(2));
%grp_model(1).pdf = normpdf(xplot,grp_model(1).paramsOpt(1),grp_model(1).paramsOpt(2));
plot(grp_model(1).pdf)
plot(grp_model(2).pdf)
xlim([0 600])