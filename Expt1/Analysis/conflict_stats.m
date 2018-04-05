clear all
load TRconflict_ALL
RTplot = [0:.001:1];
condStr = {'Spatial','Symbolic','Conflict'};
%close all
clc
%%
for s=1:size(d,1)
    for c=1:3
        ii = min(find(phit_goal(s,:,c)>.5 & RTplot>.2));
        if(~isempty(ii))
            ihalf_goal(s,c) = ii;
            prep_time_goal(s,c) = RTplot(ihalf_goal(s,c));
        else
            ihalf_goal(s,c) = NaN;
            prep_time_goal(s,c) = NaN;
        end
        
        ii = min(find(phit_symb(s,:,c)>.5 & RTplot>.1));
        if(~isempty(ii))
            ihalf_symb(s,c) = ii;
            prep_time_symb(s,c) = RTplot(ihalf_symb(s,c));
        else
            ihalf_symb(s,c) = NaN;
            prep_time_symb(s,c) = NaN;
        end
        
        

    end
    RT_spat(s) = prep_time_symb(s,1);
    RT_spat_conf(s) = prep_time_symb(s,3);
    
    RT_symb(s) = prep_time_goal(s,2);
    RT_symb_conf(s) = prep_time_goal(s,3);
end
%% fix awkward subject
ihalf_goal(3,3) = max(find(phit_goal(3,:,3)<.5 & RTplot>.2))+1;
prep_time_goal(3,3) = RTplot(ihalf_goal(3,3));
RT_symb_conf(3) = prep_time_goal(3,3);
%%


figure(101); clf; hold on
for s=1:size(d,1)
    subplot(5,2,s); hold on
    plot(RTplot,phit_symb(s,:,1),'r','linewidth',1)
    plot(RTplot(ihalf_symb(s,1)),phit_symb(s,ihalf_symb(s,1),1),'r.','markersize',20)
    plot([0 .7],[.5 .5],'k')
    
    plot(RTplot,phit_goal(s,:,2),'g','linewidth',1)
    plot(RTplot(ihalf_goal(s,2)),phit_goal(s,ihalf_goal(s,2),2),'g.','markersize',20)
    
    plot(RTplot,phit_goal(s,:,3),'g:','linewidth',1)
    plot(RTplot(ihalf_goal(s,3)),phit_goal(s,ihalf_goal(s,3),3),'g.','markersize',20)
    
    plot(RTplot,phit_symb(s,:,3),'r:','linewidth',1)
    plot(RTplot(ihalf_symb(s,3)),phit_symb(s,ihalf_symb(s,3),3),'r.','markersize',20)
end

%%
figure(102); clf; hold on
%subplot(1,2,1); hold on
dx = linspace(-.02,.02,size(d,1))';
plot([0+dx 1+dx]',[RT_symb' RT_symb_conf']','g.-','markersize',10,'linewidth',2)
plot([0+dx 1+dx]',[RT_spat' RT_spat_conf']','r.-','markersize',10,'linewidth',2)
xlim([-.5 1.5])
ylim([0 .5])
text(-.1,.05,'No conflict')
text(.9,.05,'Conflict')
text(1.2,.18,'Spatial')
text(1.2,.38,'Symbolic')

plot([0 1],[mean(RT_symb) mean(RT_symb_conf)],'k--','linewidth',3)
plot([0 1],[mean(RT_spat) mean(RT_spat_conf)],'k--','linewidth',3)

[h p_condition] = ttest(RT_symb',RT_symb_conf',2,'paired')
[h p_conflict_spat] = ttest(RT_symb',RT_symb_conf',2,'paired')
[h p_conflict_symb] = ttest(RT_spat',RT_spat_conf',2,'paired')
[h p_interactions] = ttest(RT_spat'-RT_spat_conf',RT_symb'-RT_symb_conf',2,'paired')

%% make speed-accuracy figures
Nsubj = size(d,1);
RTmax = .7;
figure(51); clf; hold on

    subplot(3,1,1); hold on
    title('Spatial - no conflict');
    %plot(RTplot,meanNaN(phit_goal(:,:,1)),'g','linewidth',3)
    plot(RTplot,meanNaN(phit_symb(:,:,1)),'r','linewidth',2)
    %shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,c)),stdNaN(phit_goal(:,:,c))/sqrt(Nsubj),'g',.5)
    shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,1)),stdNaN(phit_symb(:,:,1))/sqrt(Nsubj),'r',.5)
    plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
    legend('p(success)')
    legend boxoff
    axis([0 RTmax -.05 1.05])
    
    subplot(3,1,2); hold on
    title('Symbolic - no conflict');
    %plot(RTplot,meanNaN(phit_goal(:,:,1)),'g','linewidth',3)
    plot(RTplot,meanNaN(phit_goal(:,:,2)),'g','linewidth',2)
    %shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,c)),stdNaN(phit_goal(:,:,c))/sqrt(Nsubj),'g',.5)
    shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,2)),stdNaN(phit_goal(:,:,2))/sqrt(Nsubj),'g',.5)
    plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
    legend('p(success)')
    legend boxoff
    axis([0 RTmax -.05 1.05])
    
    subplot(3,1,3); hold on
    title('Conflict condition');
    plot(RTplot,meanNaN(phit_goal(:,:,3)),'g','linewidth',2)
    plot(RTplot,meanNaN(phit_symb(:,:,3)),'r','linewidth',2)
    shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,3)),stdNaN(phit_goal(:,:,3))/sqrt(Nsubj),'g',.5)
    shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,3)),stdNaN(phit_symb(:,:,3))/sqrt(Nsubj),'r',.5)
    plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
    legend('p(move to instructed location','p(move to symbol location)')
    legend boxoff
    axis([0 RTmax -.05 1.05])    
    

%% compare speed-accuracy curves in conflict versus non-conflict scenarios
figure(52); clf; hold on
subplot(2,1,1); hold on
shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,1)),stdNaN(phit_symb(:,:,1))/sqrt(Nsubj),'r',.5)
shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,3)),stdNaN(phit_symb(:,:,3))/sqrt(Nsubj),'k',.5)
axis([0 RTmax -.05 1.05])

subplot(2,1,2); hold on
shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,2)),stdNaN(phit_goal(:,:,2))/sqrt(Nsubj),'g',.5)
shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,3)),stdNaN(phit_goal(:,:,3))/sqrt(Nsubj),'k',.5)
axis([0 RTmax -.05 1.05])
xlabel('Reaction Time / s')
ylabel('Probability')
