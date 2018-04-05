% compare across experiments
clear all
load ../../Expt1/Analysis/ConflictData_Expt1_sw
d1 = d;
load ../../Expt2/Analysis/ConflictData_Expt2_sw
d2 = d;
load ConflictData_Expt3_sw
d3 = d;

figure(101); clf; hold on
subplot(2,2,1); hold on
plot([0 .6],[.25 .25],'k')
plot(xplot,nanmean(d1{1}.phit_spat),'r','linewidth',1)
plot(xplot,nanmean(d2{1}.phit_spat),'r','linewidth',2)
plot(xplot,nanmean(d3{1}.phit_spat),'r','linewidth',3)

%subplot(3,2,1); hold on
plot(xplot,nanmean(d1{2}.phit_symb),'b','linewidth',1)
plot(xplot,nanmean(d2{3}.phit_symb),'b','linewidth',2)
plot(xplot,nanmean(d3{3}.phit_col),'b','linewidth',3)

plot(xplot,nanmean(d3{2}.phit_symb),'g','linewidth',3)

subplot(2,2,2); hold on
plot([0 .6],[.25 .25],'k')
plot(xplot,nanmean(d1{3}.phit_spat),'r','linewidth',1)
plot(xplot,nanmean(d2{3}.phit_spat),'r','linewidth',2)
plot(xplot,nanmean(d2{4}.phit_spat),'r:','linewidth',2)
plot(xplot,nanmean(d3{4}.phit_spat),'r','linewidth',3)

%subplot(3,2,3); hold on
plot(xplot,nanmean(d1{3}.phit_symb),'b','linewidth',1)
plot(xplot,nanmean(d2{3}.phit_symb),'b','linewidth',2)
plot(xplot,nanmean(d2{4}.phit_symb),'b:','linewidth',2)
plot(xplot,nanmean(d3{4}.phit_col),'b','linewidth',3)

plot(xplot,nanmean(d3{4}.phit_symb),'g','linewidth',3)

subplot(2,2,3); hold on
plot([0 .6],[.25 .25],'k')
plot(xplot,nanmean(d1{3}.incongruent.phit_spat),'r','linewidth',1)
plot(xplot,nanmean(d2{3}.incongruent.phit_spat),'r','linewidth',2)
plot(xplot,nanmean(d2{4}.incongruent.phit_spat),'r:','linewidth',2)
plot(xplot,nanmean(d3{4}.incongruent.phit_spat),'r','linewidth',3)

%subplot(3,2,5); hold on
plot(xplot,nanmean(d1{3}.incongruent.phit_symb),'b','linewidth',1)
plot(xplot,nanmean(d2{3}.incongruent.phit_symb),'b','linewidth',2)
plot(xplot,nanmean(d2{4}.incongruent.phit_symb),'b:','linewidth',2)
plot(xplot,nanmean(d3{4}.incongruent.phit_col),'b','linewidth',3)

plot(xplot,nanmean(d3{4}.incongruent.phit_symb),'g','linewidth',3)