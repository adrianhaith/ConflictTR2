%% raw scatter plots
clear all
load TRconflict_data_raw
condStr = {'Spatial','Arrow','Color','Arrow/Spatial','Color/Spatial','Color/Arrow','Triple1','Triple2'};
RTmax = .7;
% for s=1:length(subjname)
%     figure(i); clf; hold on
%     for c=[1 4]
%         subplot(3,2,c-6); hold on
%         title(condStr{c})
%         plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
%         plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
%         plot(data{s,c}.RT,data{s,c}.reachDir_goal,'.','markersize',13)
%         axis([0 RTmax -180 180])
%         xlabel('Reaction Time (s)')
%         ylabel('Goal Error')
%         
%         subplot(3,2,2+c-6); hold on
%         title(condStr{c})
%         plot(data{s,c}.RT,data{s,c}.reachDir_spat,'.','markersize',13)
%         plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
%         plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
%         axis([0 RTmax -180 180])
%         axis([0 RTmax -180 180])
%         xlabel('Reaction Time (s)')
%         ylabel('Spatial Error')
%         
%         subplot(3,2,4+c-6); hold on
%         title(condStr{c})
%         plot(data{s,c}.RT,data{s,c}.reachDir_symb,'.','markersize',13)
%         plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
%         plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
%         axis([0 RTmax -180 180])
%         axis([0 RTmax -180 180])
%         xlabel('Reaction Time (s)')
%         ylabel('Symbol Error')
%     end
% end




%% sliding window
RTplot = [0:.001:1];
w = .075; % sliding window width
TOL = 30; % hit tolerance +/-

for s=1:length(subjname)
    for c = 1:Nc
        hit_goal = abs(data{s,c}.reachDir_goal)<TOL;
        hit_symb = abs(data{s,c}.reachDir_symb)<TOL;
        hit_spat = abs(data{s,c}.reachDir_spat)<TOL;
        for i=1:length(RTplot)
            t = RTplot(i);
            igood = find(data{s,c}.RT>t-w/2 & data{s,c}.RT<t+w/2);
            if(length(igood)>3)
                phit_goal(s,i,c) = mean(hit_goal(igood));
                phit_symb(s,i,c) = mean(hit_symb(igood));
                phit_spat(s,i,c) = mean(hit_spat(igood));
            else
                phit_goal(s,i,c) = NaN;
                phit_symb(s,i,c) = NaN;
                phit_spat(s,i,c) = NaN;
            end
        end
    end
    %phit_symb(2,:) = NaN; % set to NaNs since this is meaningless data
end

%% save compact version of data
for s=1:length(subjname)
    for c=1:4
        d(s,c).phit_col = phit_goal(s,:,c);
        d(s,c).phit_symb = phit_symb(s,:,c);
        d(s,c).phit_spat = phit_spat(s,:,c);
        
        d(s,c).RT = data{s,c}.RT;
        d(s,c).pkVel = data{s,c}.pkVel;
        d(s,c).colAng = data{s,c}.goalAng;
        d(s,c).spatAng = data{s,c}.spatAng;
        d(s,c).symbAng = data{s,c}.goalDir_symb';
        d(s,c).reachDir = data{s,c}.reachDir;
        d(s,c).Ntrials = data{s,c}.Ntrials;
        d(s,c).targOn = data{s,c}.targ_appear_time;
        
        d(s,c).reachDir_symb = data{s,c}.reachDir_symb;
        d(s,c).reachDir_col = data{s,c}.reachDir_goal';
        d(s,c).reachDir_spat = data{s,c}.reachDir_spat';
        
        d(s,c).hit_symb = abs(d(s,c).reachDir_symb)<TOL;
        d(s,c).hit_col = abs(d(s,c).reachDir_col)<TOL;
        d(s,c).hit_spat = abs(d(s,c).reachDir_spat)<TOL;
    end
end

save triple_conflict_data d
%% show unary speed-accuracy tradeoffs
for s=1:length(subjname)
    figure(s); clf; hold on
    subplot(2,1,1); hold on
    plot(RTplot, (phit_spat(s,:,1)),'k','linewidth',2)
    %plot(RTplot, phit_goal(s,:,1),'ko')
    %plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    
    %subplot(3,1,2); hold on
    %plot(RTplot, phit_goal(s,:,2),'b','linewidth',2)
    plot(RTplot, (phit_symb(s,:,2)),'b','linewidth',2)
    %plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    
    %subplot(3,1,3); hold on
    plot(RTplot, (phit_goal(s,:,3)),'m','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    legend('spatial','arrows','color')
    legend boxoff
end

%% show triple-conflict trade-offs
for s=1:length(subjname)
    figure(s);
    subplot(2,1,2); hold on
    plot(RTplot,(phit_spat(s,:,4)),'k','linewidth',2)
    plot(RTplot,(phit_symb(s,:,4)),'b','linewidth',2)
    plot(RTplot,(phit_goal(s,:,4)),'m','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    legend('spatial','arrow','color')
    legend boxoff
end


figure(101); clf; hold on
subplot(2,1,1); hold on
shadedErrorBar(RTplot, nanmean(phit_spat(:,:,1)),seNan(phit_spat(:,:,1)),'k',1)
shadedErrorBar(RTplot, nanmean(phit_symb(:,:,2)),seNan(phit_symb(:,:,2)),'b',1)
shadedErrorBar(RTplot, nanmean(phit_goal(:,:,3)),seNan(phit_goal(:,:,3)),'m',1)
plot([0 .7],[.25 .25],'k')
axis([0 RTmax -.05 1.05])
legend('spatial','arrow','color')
legend boxoff

subplot(2,1,2); hold on
shadedErrorBar(RTplot, nanmean(phit_spat(:,:,4)),seNan(phit_spat(:,:,4)),'k',1)
shadedErrorBar(RTplot, nanmean(phit_symb(:,:,4)),seNan(phit_symb(:,:,4)),'b',1)
shadedErrorBar(RTplot, nanmean(phit_goal(:,:,4)),seNan(phit_goal(:,:,4)),'m',1)
plot([0 .7],[.25 .25],'k')
axis([0 RTmax -.05 1.05])
legend('spatial','arrow','color')
legend boxoff



% figure(14); clf; hold on
% subplot(2,1,1); hold on
% plot(RTplot,phit_spat(s,:,8),'k','linewidth',2)
% plot(RTplot,phit_symb(s,:,8),'b','linewidth',2)
% plot(RTplot,phit_goal(s,:,8),'m','linewidth',2)
% plot([0 .7],[.25 .25],'k')
% axis([0 RTmax -.05 1.05])
% legend('spatial','arrow','color')
% legend boxoff
% 
% subplot(2,1,2); hold on
% plot(RTplot,phit_spat(s,:,9),'k','linewidth',2)
% plot(RTplot,phit_symb(s,:,9),'b','linewidth',2)
% plot(RTplot,phit_goal(s,:,9),'m','linewidth',2)
% plot([0 .7],[.25 .25],'k')
% axis([0 RTmax -.05 1.05])
% legend('spatial','arrow','color')
% legend boxoff
% %%
% for s=1:length(subjname)
%     figure(40+s); clf; hold on
%     plot(RTplot,phit_goal(s,:,1),'k','linewidth',2)
%     plot(RTplot,phit_goal(s,:,2),'g','linewidth',2)
%     plot(RTplot,phit_goal(s,:,3),'m','linewidth',2)
%     plot(RTplot,phit_goal(s,:,4),'y','linewidth',2)
% end
% %% day 2 SATs
% for s=1:length(subjname)
%     figure(60+s); clf; hold on
%     subplot(2,2,1); hold on
%     title('color')
%     plot(RTplot,phit_goal(s,:,5),'m','linewidth',2)
%     plot(RTplot,phit_goal(s,:,3),'m:','linewidth',2)
%     plot([0 .7],[.25 .25],'k')
%     axis([0 .7 0 1])
%     
%     subplot(2,2,2); hold on
%     title('symbol')
%     plot(RTplot,phit_goal(s,:,6),'g','linewidth',2)
%     plot(RTplot,phit_goal(s,:,2),'g:','linewidth',2)
%     plot([0 .7],[.25 .25],'k')
%     axis([0 .7 0 1])
%     
%     subplot(2,2,3); hold on
%     title('color during conflict')
%     plot(RTplot,phit_goal(s,:,7),'k','linewidth',2)
%     plot(RTplot,phit_goal(s,:,4),'k:','linewidth',2)
%     
%     plot([0 .7],[.25 .25],'k')
%     axis([0 .7 0 1])
%     subplot(2,2,4); hold on
%     title('symbol during conflict')
%     plot(RTplot,phit_symb(s,:,7),'b','linewidth',2)
%     plot(RTplot,phit_symb(s,:,4),'b:','linewidth',2)
%     plot([0 .7],[.25 .25],'k')
%     axis([0 .7 0 1])
% end
% 
% %% conflict
% for s=1:length(subjname)
%     figure(70+s); clf; hold on
%     subplot(2,1,1); hold on
%     title('Day 1')
%     plot(RTplot,phit_goal(s,:,4),'m','linewidth',2)
%     plot(RTplot,phit_symb(s,:,4),'r','linewidth',2)
%     plot(RTplot([1 end]),[.25 .25],'k-')
%     legend('color','symbol')
%     plot([0 .7],[.25 .25],'k')
%     axis([0 .7 0 1])
%     
%     subplot(2,1,2); hold on
%     title('Day 2')
%     plot(RTplot,phit_goal(s,:,7),'m','linewidth',2)
%     plot(RTplot,phit_symb(s,:,7),'r','linewidth',2)
%     plot(RTplot([1 end]),[.25 .25],'k-')
%     legend('color','symbol')
%     plot([0 .7],[.25 .25],'k')
%     axis([0 .7 0 1])
% end
% 
% %%
% for s=1:length(subjname)
%     figure(30+s); clf; hold on
%  
%         subplot(2,1,1); hold on
%         title('symbolic');
%         plot(RTplot,phit_goal(s,:,2),'g','linewidth',3)
%         plot(RTplot,phit_goal(s,:,3),'k','linewidth',2)
%         plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
%         legend('No-Conflict','conflict')
%         legend boxoff
%         axis([0 RTmax -.05 1.05])
%     
%         subplot(2,1,2); hold on
%         title('spatial');
%         plot(RTplot,phit_symb(s,:,1),'r','linewidth',3)
%         plot(RTplot,phit_symb(s,:,3),'k','linewidth',2)
%         plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
%         legend('No-conflict','Conflict')
%         legend boxoff
%         axis([0 RTmax -.05 1.05])
% end
% 
% %%
% figure(51); clf; hold on
% for c=1:3
%     subplot(3,1,c); hold on
%     title(condStr{c});
%     plot(RTplot,meanNaN(phit_goal(:,:,c)),'g','linewidth',3)
%     plot(RTplot,meanNaN(phit_symb(:,:,c)),'r','linewidth',2)
%     shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,c)),stdNaN(phit_goal(:,:,c))/sqrt(length(subjname)),'g',.5)
%     shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,c)),stdNaN(phit_symb(:,:,c))/sqrt(length(subjname)),'r',.5)
%     plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
%     legend('p(move to correct goal)','p(move to symbol location')
%     legend boxoff
%     axis([0 RTmax -.05 1.05])
% end
% %% compare speed-accuracy curves in conflict versus non-conflict scenarios
% figure(52); clf; hold on
% subplot(2,1,1); hold on
% shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,1)),stdNaN(phit_symb(:,:,1))/sqrt(length(subjname)),'r',.5)
% shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,3)),stdNaN(phit_symb(:,:,3))/sqrt(length(subjname)),'k',.5)
% axis([0 RTmax -.05 1.05])
% 
% subplot(2,1,2); hold on
% shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,2)),stdNaN(phit_goal(:,:,2))/sqrt(length(subjname)),'g',.5)
% shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,3)),stdNaN(phit_goal(:,:,3))/sqrt(length(subjname)),'k',.5)
% axis([0 RTmax -.05 1.05])
% xlabel('Reaction Time / s')
% ylabel('Probability')
% 
% %%
% save TRconflict_ALL data phit_goal phit_symb
% 
