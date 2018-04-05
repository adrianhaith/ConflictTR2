% plot conflict data Expt 1
clear all
addpath ExtraFns

load ConflictData_Expt1_sw

fhandle = figure(1); clf; hold on
    set(fhandle, 'Position', [600, 100, 300, 900]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white

subplot(4,1,1); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{1}.phit_spat),seNan(d{1}.phit_spat),'r',1)
plot(1000*xplot,nanmean(d{3}.congruent.phit_spat),'r--')
axis([0 1000*max(xplot) 0 1])
xlabel('Preparation Time')
ylabel('Proportion')

subplot(4,1,2); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{2}.phit_symb),seNan(d{2}.phit_symb),'b',1)
axis([0 1000*max(xplot) 0 1])
xlabel('Preparation Time')
ylabel('Proportion')

subplot(4,1,3); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.phit_spat),seNan(d{3}.phit_spat),'r',1)
%shadedErrorBar(1000*xplot,nanmean(d{1}.phit_spat),seNan(d{1}.phit_spat),'r')
shadedErrorBar(1000*xplot,nanmean(d{3}.phit_symb),seNan(d{3}.phit_symb),'b',1)
%shadedErrorBar(1000*xplot,nanmean(d{2}.phit_symb),seNan(d{2}.phit_symb),'b')
axis([0 1000*max(xplot) 0 1])
xlabel('Preparation Time')
ylabel('Proportion')

subplot(4,1,4); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.incongruent.phit_spat),seNan(d{3}.incongruent.phit_spat),'r',1)
%shadedErrorBar(1000*xplot,nanmean(d{1}.phit_spat),seNan(d{1}.phit_spat),'r')
shadedErrorBar(1000*xplot,nanmean(d{3}.incongruent.phit_symb),seNan(d{3}.incongruent.phit_symb),'b',1)
%shadedErrorBar(1000*xplot,nanmean(d{2}.phit_symb),seNan(d{2}.phit_symb),'b')
axis([0 1000*max(xplot) 0 1])
xlabel('Preparation Time')
ylabel('Proportion')

%% congruent/incongruent breakdown
fhandle = figure(2); clf; hold on
    set(fhandle, 'Position', [600, 100, 800, 300]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white
    
subplot(1,2,1); hold on
title('congruent trials')
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.congruent.phit_spat),seNan(d{3}.congruent.phit_spat),'r')

subplot(1,2,2); hold on
title('incongruent trials')
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.incongruent.phit_spat),seNan(d{3}.incongruent.phit_spat),'r')
shadedErrorBar(1000*xplot,nanmean(d{3}.incongruent.phit_symb),seNan(d{3}.incongruent.phit_symb),'b')
shadedErrorBar(1000*xplot,nanmean(1-d{3}.incongruent.phit_symb-d{3}.incongruent.phit_spat)/2,seNan(1-d{3}.incongruent.phit_spat-d{3}.incongruent.phit_symb)/2,'m')
plot(1000*xplot,nanmean(d{3}.congruent.phit_spat),'r--')
plot(1000*xplot,nanmean(d{2}.phit_symb),'b--')

%% individual subject data
fhandle = figure(3); clf; hold on
    set(fhandle, 'Position', [100, 100, 1600, 800]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white
    
for s=1:d{1}.Nsubjs
    subplot(2,4,s); hold on
    plot(1000*[0 max(xplot)],[.25 .25],'k')
    plot(1000*xplot,d{1}.phit_spat(s,:),'r--')
    plot(1000*xplot,d{2}.phit_symb(s,:),'b--')
    plot(1000*xplot,d{3}.incongruent.phit_spat(s,:),'r')
    plot(1000*xplot,d{3}.incongruent.phit_symb(s,:),'b')
    plot(1000*xplot,1-d{3}.incongruent.phit_symb(s,:)-d{3}.incongruent.phit_spat(s,:),'m')
end

%%
load Conflict_Expt1_FreeRT_compact
RTmax = .6;

figure(4); clf; hold on
subplot(4,1,1); hold on
xplot = [0:.001:RTmax];
plot(xplot,nanmean(d{1}.phit_spat),'r')
plot(xplot,nanmean(d_Free{1}.phit_spat(:,1:length(xplot))),'r--')

subplot(4,1,2); hold on
plot(xplot,nanmean(d{2}.phit_symb),'b')
plot(xplot,nanmean(d_Free{2}.phit_symb(:,1:length(xplot))),'b--')

subplot(4,1,3); hold on
plot(xplot,nanmean(d{3}.phit_spat),'r')
plot(xplot,nanmean(d_Free{3}.phit_spat(:,1:length(xplot))),'r--')
plot(xplot,nanmean(d{3}.phit_symb),'b')
plot(xplot,nanmean(d_Free{3}.phit_symb(:,1:length(xplot))),'b--')

%% raw scatter plots
ss = 1;

fhandle = figure(5); clf; hold on
    set(fhandle, 'Position', [100, 100, 1200, 700]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white
    for c=1:3
        subplot(3,3,3*c-2); hold on
        plot([0 600],[0 0],'k')
        plot([0 600],[45 45],'k')
        plot([0 600],[-45 -45],'k')
        rDir = d{c}.reachDir(ss,:);
        %rDir(rDir<-135) = rDir(rDir<-135)+180;
        plot(1000*d{c}.RT(ss,:),rDir,'.')
        
        xlim([0 600])
        ylim([-180 180])
        
        subplot(3,3,3*c-1); hold on
        plot([0 600],[0 0],'k')
        plot([0 600],[45 45],'k')
        plot([0 600],[-45 -45],'k')
        plot(1000*d{c}.RT(ss,:),d{c}.reachErr_spat(ss,:),'.')
        axis([0 600 -180 180])
        
        subplot(3,3,3*c); hold on
        plot([0 600],[0 0],'k')
        plot([0 600],[45 45],'k')
        plot([0 600],[-45 -45],'k')
        plot(1000*d{c}.RT(ss,:),d{c}.reachErr_symb(ss,:),'.')
        axis([0 600 -180 180])
    end
    
%% nice figures for poster
ss = 2;
fhandle = figure(5); clf; hold on
set(fhandle, 'Position', [100, 100, 1200, 700]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white

subplot(3,3,3); hold on
%plot([0 600],[0 0],'color',.85*[1 1 1],'linewidth',40)
plot([0 600],[0 0],'k')
plot([0 600],[45 45],'k')
plot([0 600],[-45 -45],'k')
plot(1000*d{3}.RT(ss,:),d{3}.reachErr_spat(ss,:),'.','markersize',10)
axis([0 600 -180 180])
%yticks([-180 -90 0 90 180])
%yticklabels({'-180','-90','0','90','180'})
set(gca, 'YTick', [-180 -90 0 90 180])

subplot(3,3,4); hold on
plot([0 600],[0 0],'k')
plot([0 600],[45 45],'k')
plot([0 600],[-45 -45],'k')
plot(1000*d{1}.RT(ss,:),d{1}.reachErr_spat(ss,:),'.','markersize',10)
axis([0 600 -180 180])
set(gca, 'YTick', [-180 -90 0 90 180])

subplot(3,3,5); hold on
plot([0 600],[0 0],'k')
plot([0 600],[45 45],'k')
plot([0 600],[-45 -45],'k')
plot(1000*d{2}.RT(ss,:),d{2}.reachErr_symb(ss,:),'.','markersize',10)
axis([0 600 -180 180])
set(gca, 'YTick', [-180 -90 0 90 180])

subplot(3,3,6); hold on
plot([0 600],[0 0],'k')
plot([0 600],[45 45],'k')
plot([0 600],[-45 -45],'k')
plot(1000*d{3}.RT(ss,:),d{3}.reachErr_symb(ss,:),'.','markersize',10)
axis([0 600 -180 180])
set(gca, 'YTick', [-180 -90 0 90 180])

subplot(3,3,7); hold on
plot([0 600],[.25 .25],'k')
plot(1000*xplot,d{1}.phit_spat(ss,:),'r')
axis([0 600 0 1])
set(gca, 'YTick', [0 0.25 .5 .75 1])

subplot(3,3,8); hold on
plot([0 600],[.25 .25],'k')
plot(1000*xplot,d{2}.phit_symb(ss,:),'b')
axis([0 600 0 1])
set(gca, 'YTick', [0 0.25 .5 .75 1])

subplot(3,3,9); hold on
plot([0 600],[.25 .25],'k')
plot(1000*xplot,d{3}.phit_spat(ss,:),'r')
plot(1000*xplot,d{3}.phit_symb(ss,:),'b')
axis([0 600 0 1])
set(gca, 'YTick', [0 0.25 .5 .75 1])

%% plot peak velocities

% sliding window
for c=1:3
    for s=1:d{1}.Nsubjs
        d{c}.peakVel_sw(s,:) = sliding_window(d{c}.RT(s,:),d{c}.peakVel(s,:),xplot,.05);
        if(c==3)
            d{c}.congruent.peakVel_sw(s,:) = sliding_window(d{c}.congruent.RT(s,:),d{c}.congruent.peakVel(s,:),xplot,.05);
            d{c}.incongruent.peakVel_sw(s,:) = sliding_window(d{c}.incongruent.RT(s,:),d{c}.incongruent.peakVel(s,:),xplot,.05);
        end
    end
end

figure(6); clf; hold on

subplot(2,3,1); hold on
title('Spatial')
plot(xplot,nanmean(d{1}.phit_spat),'r')
axis([0 .6 0 1]);
xlabel('Prep time')
ylabel('p(success)')

subplot(2,3,2); hold on
title('Symbolic')
plot(xplot,nanmean(d{2}.phit_symb),'b')
axis([0 .6 0 1]);
xlabel('Prep time')
ylabel('p(success)')

subplot(2,3,3); hold on
title('Conflict')
plot(xplot,nanmean(d{3}.incongruent.phit_spat),'r')
plot(xplot,nanmean(d{3}.incongruent.phit_symb),'b')
plot(xplot,nanmean(d{3}.congruent.phit_spat),'r--')
axis([0 .6 0 1]);
xlabel('Prep time')
ylabel('p(success)')

for c=1:2
    subplot(2,3,c+3); hold on
    plot(xplot,nanmean(d{c}.peakVel_sw))
    xlim([0 .6])
    ylim([.005 .01])
    xlabel('Prep time')
    ylabel('peak velocity')
end
c=3;
    subplot(2,3,c+3); hold on
    plot(xplot,nanmean(d{c}.incongruent.peakVel_sw))
    plot(xplot,nanmean(d{c}.congruent.peakVel_sw),'--')
    xlim([0 .6])
    ylim([.005 .01])
        xlabel('Prep time')
    ylabel('peak velocity')
