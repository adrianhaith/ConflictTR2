% make figures for conflict paper/poster
s=1; % subject number to plot

figure(1); clf; hold on
rng = 1:600;

% single subject
subplot(4,3,1); hold on
plot(RTplot(rng),phit_goal(s,rng,1),'r')
plot([0 .6],[.25 .25],'k:')

subplot(4,3,4); hold on
plot(RTplot(rng),phit_goal(s,rng,2),'g')
plot([0 .6],[.25 .25],'k:')

subplot(4,3,7); hold on
plot(RTplot(rng),phit_goal(s,rng,3),'g')
plot(RTplot(rng),phit_symb(s,rng,3),'r')
%plot(RTplot(rng),1-phit_goal(s,rng,3)-phit_symb(s,rng,3),'m')
plot([0 .6],[.25 .25],'k:')
plot([0 .6],[0 0],'k')

% group average
subplot(4,3,2); hold on
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,1)),seNaN(phit_goal(:,rng,1)),'r',1)
plot([0 .6],[.25 .25],'k:')
plot([0 .6],[0 0],'k')

subplot(4,3,5); hold on
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,2)),seNaN(phit_goal(:,rng,2)),'g',1)
plot([0 .6],[.25 .25],'k:')

subplot(4,3,8); hold on
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,3)),seNaN(phit_goal(:,rng,3)),'g',1)
shadedErrorBar(RTplot(rng),nanmean(phit_symb(:,rng,3)),seNaN(phit_symb(:,rng,3)),'r',1)
%shadedErrorBar(RTplot(rng),nanmean(1-phit_symb(:,rng,3)-phit_goal(:,rng,3)),seNaN(1-phit_symb(:,rng,3)-phit_goal(:,rng,3)),'m',1)
plot([0 .6],[.25 .25],'k:')
plot([0 .6],[0 0],'k')

% conflict vs no-conflict
subplot(4,3,10); hold on
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,2)),seNaN(phit_goal(:,rng,2)),'k',1)
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,3)),seNaN(phit_goal(:,rng,3)),'g',1)
plot([0 .6],[.25 .25],'k:')

subplot(4,3,11); hold on
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,1)),seNaN(phit_goal(:,rng,1)),'k',1)


%% make figs for ziggy experiment

shadedErrorBar(RTplot(rng),nanmean(phit_symb(:,rng,3)),seNaN(phit_symb(:,rng,3)),'r',1)
plot([0 .6],[.25 .25],'k:')

%% model
%generate and plot model predictions (run fitModelConflict.m first)
%spat.pOpt(2) = .04;
%spat.pOpt(1) = .22;
%symb.pOpt(1) = .35;

subplot(4,3,3); hold on
[spat.phit_model spat.ycdf] = model_sigmoid(spat.pOpt,RTplot,4);
plot(RTplot(rng),spat.phit_model(rng),'r');
axis([0 .6 0 1]);
plot([0 .6],[.25 .25],'k:')

subplot(4,3,6); hold on
[symb.phit_model symb.ycdf] = model_sigmoid(symb.pOpt,RTplot,4);
plot(RTplot(rng),symb.phit_model(rng),'g');
axis([0 .6 0 1]);
plot([0 .6],[.25 .25],'k:')

aa = [.25 .25 symb.pOpt(3)];
conf.phit_symb_model = sum([aa(1)*(1-symb.ycdf).*(1-spat.ycdf); aa(2)*spat.ycdf.*(1-symb.ycdf); aa(3)*symb.ycdf]);

ab = [.25 spat.pOpt(3) .25];
conf.phit_spat_model = sum([ab(1)*(1-symb.ycdf).*(1-spat.ycdf); ab(2)*spat.ycdf.*(1-symb.ycdf); ab(3)*symb.ycdf]);

subplot(4,3,9); hold on
plot(RTplot(rng),conf.phit_symb_model(rng),'g')
plot(RTplot(rng),conf.phit_spat_model(rng),'r')
%plot(RTplot(rng),1-conf.phit_symb_model(rng)-conf.phit_spat_model(rng),'m')
%axis([0 .6 0 1]);
plot([0 .6],[.25 .25],'k:')
plot([0 .6],[0 0],'k')


