% congruent/incongruent breakdown of conflict data
clear all
load TRconflict_ALL

Nsubj = size(d,1);
RTplot = [0:.001:1];
w = .075;
for s=1:Nsubj
    % sliding window on full performance
    conf.phit_goal(s,:) = sliding_window(d{s,3}.RT,d{s,3}.hit_goal,RTplot,w);
    conf.phit_symb(s,:) = sliding_window(d{s,3}.RT,d{s,3}.hit_symb,RTplot,w);
    
    congr = (d{s,3}.goalAng == d{s,3}.spatAng);
    
    i_congruent = find(congr);    
    d{s,3}.congruent.RT = d{s,3}.RT(i_congruent);
    d{s,3}.congruent.hit_goal = d{s,3}.hit_goal(i_congruent);
    d{s,3}.congruent.hit_symb = d{s,3}.hit_symb(i_congruent);
  
    i_incongruent = find(~congr);
    d{s,3}.incongruent.RT = d{s,3}.RT(i_incongruent);
    d{s,3}.incongruent.hit_goal = d{s,3}.hit_goal(i_incongruent);
    d{s,3}.incongruent.hit_symb = d{s,3}.hit_symb(i_incongruent);

    % sliding window for incongruent trials
    incongruent.phit_goal(s,:) = sliding_window(d{s,3}.incongruent.RT,d{s,3}.incongruent.hit_goal,RTplot,w);
    incongruent.phit_symb(s,:) = sliding_window(d{s,3}.incongruent.RT,d{s,3}.incongruent.hit_symb,RTplot,w);
    
    congruent.phit_goal(s,:) = sliding_window(d{s,3}.congruent.RT,d{s,3}.congruent.hit_goal,RTplot,w);
    congruent.phit_symb(s,:) = sliding_window(d{s,3}.congruent.RT,d{s,3}.congruent.hit_symb,RTplot,w);
    
end
%%
% response breakdown on incongruent trials
figure(40); clf; hold on 
for s=1:Nsubj
    subplot(2,4,s); hold on
    plot(RTplot,incongruent.phit_symb(s,:),'r-','linewidth',2)
    %plot(RTplot,congruent.phit_symb(s,:),'r:')
    plot(RTplot,incongruent.phit_goal(s,:),'g-','linewidth',2)
    plot(RTplot,1-incongruent.phit_goal(s,:)-incongruent.phit_symb(s,:),'m','linewidth',2)
    plot([0 .6],[.25 .25],'k:')
    axis([0 .6 0 1])
end

% response breakdown on congruent trials
figure(41); clf; hold on 
for s=1:Nsubj
    subplot(2,4,s); hold on
    plot(RTplot,congruent.phit_symb(s,:),'r-','linewidth',2)
    %plot(RTplot,congruent.phit_goal(s,:),'g-','linewidth',2)
    plot(RTplot,1-congruent.phit_goal(s,:),'m','linewidth',2)
    plot([0 .6],[.25 .25],'k:')
    axis([0 .6 0 1])
end

% average across subjects
figure(42); clf; hold on
%subplot(1,2,1); hold on
%shadedErrorBar(RTplot,nanmean(congruent.phit_symb),seNaN(congruent.phit_symb),'k',1)
%shadedErrorBar(RTplot,nanmean(congruent.phit_goal),seNaN(congruent.phit_goal),'g',1)
%shadedErrorBar(RTplot,nanmean(1-congruent.phit_goal),seNaN(1-congruent.phit_goal),'y',1)

%subplot(1,2,2); hold on
shadedErrorBar(RTplot,nanmean(incongruent.phit_symb),seNaN(incongruent.phit_symb),'r',1)
shadedErrorBar(RTplot,nanmean(incongruent.phit_goal),seNaN(incongruent.phit_goal),'g',1)
shadedErrorBar(RTplot,nanmean(1-incongruent.phit_goal-incongruent.phit_symb),seNaN(1-incongruent.phit_goal-incongruent.phit_symb),'m',1)
%shadedErrorBar(RTplot,nanmean(phit_symb(:,:,1)),seNaN(phit_symb(:,:,1)),'b',1)
axis([0 .6 0 1])