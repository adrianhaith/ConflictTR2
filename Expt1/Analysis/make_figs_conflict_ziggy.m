%% make figs for ziggy experiment
figure(1); clf; hold on

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

%shadedErrorBar(RTplot(rng),nanmean(phit_symb(:,rng,3)),seNaN(phit_symb(:,rng,3)),'r',1)
%plot([0 .6],[.25 .25],'k:')

subplot(4,3,3); hold on
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,3)),seNaN(phit_goal(:,rng,3)),'r',1)
shadedErrorBar(RTplot(rng),nanmean(phit_symb(:,rng,3)),seNaN(phit_symb(:,rng,3)),'g',1)
shadedErrorBar(RTplot(rng),nanmean(phit_goal(:,rng,4)),seNaN(phit_goal(:,rng,4)),'b',1)
shadedErrorBar(RTplot(rng),nanmean(phit_symb(:,rng,4)),seNaN(phit_symb(:,rng,4)),'m',1)