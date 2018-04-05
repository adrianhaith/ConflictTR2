% plot conflict data Expt 1
clear all
addpath ExtraFns

load ConflictData_Expt2_sw

fhandle = figure(1); clf; hold on
    set(fhandle, 'Position', [600, 100, 300, 900]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white

subplot(4,1,1); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{1}.phit_spat),seNan(d{1}.phit_spat),'r',1)
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
shadedErrorBar(1000*xplot,nanmean(d{4}.phit_spat),seNan(d{4}.phit_spat),'r',1)
%shadedErrorBar(1000*xplot,nanmean(d{1}.phit_spat),seNan(d{1}.phit_spat),'r')
shadedErrorBar(1000*xplot,nanmean(d{4}.phit_symb),seNan(d{4}.phit_symb),'b',1)
%shadedErrorBar(1000*xplot,nanmean(d{2}.phit_symb),seNan(d{2}.phit_symb),'b')
axis([0 1000*max(xplot) 0 1])
xlabel('Preparation Time')
ylabel('Proportion')

%%
fhandle = figure(2); clf; hold on
    set(fhandle, 'Position', [600, 100, 500, 300]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white
    
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.phit_spat),seNan(d{3}.phit_spat),'r')
shadedErrorBar(1000*xplot,nanmean(d{3}.phit_symb),seNan(d{3}.phit_symb),'b')
shadedErrorBar(1000*xplot,nanmean(d{4}.phit_spat),seNan(d{4}.phit_spat),'r--')
shadedErrorBar(1000*xplot,nanmean(d{4}.phit_symb),seNan(d{4}.phit_symb),'b--')
axis([0 1000*max(xplot) 0 1])

%% congruent/incongruent
fhandle = figure(3); clf; hold on
    set(fhandle, 'Position', [600, 100, 800, 600]); % set size and loction on screen
    set(fhandle, 'Color','w') % set background color to white
    
subplot(1,2,1); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.congruent.phit_spat),seNan(d{3}.congruent.phit_spat),'r')
axis([0 1000*max(xplot) 0 1])

%subplot(2,2,2); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{4}.congruent.phit_spat),seNan(d{4}.congruent.phit_spat),'r--')
axis([0 1000*max(xplot) 0 1]) 

subplot(1,2,2); hold on
plot(1000*[0 max(xplot)],[.25 .25],'k')
shadedErrorBar(1000*xplot,nanmean(d{3}.incongruent.phit_spat),seNan(d{3}.incongruent.phit_spat),'r')
shadedErrorBar(1000*xplot,nanmean(d{3}.incongruent.phit_symb),seNan(d{3}.incongruent.phit_symb),'b')
shadedErrorBar(1000*xplot,nanmean(d{4}.incongruent.phit_spat),seNan(d{4}.incongruent.phit_spat),'r--')
shadedErrorBar(1000*xplot,nanmean(d{4}.incongruent.phit_symb),seNan(d{4}.incongruent.phit_symb),'b--')
axis([0 1000*max(xplot) 0 1])