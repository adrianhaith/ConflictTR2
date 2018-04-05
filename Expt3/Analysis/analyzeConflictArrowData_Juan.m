% Analyze conflict data
clear all
%%
%{
subjname = {'Juan'};
condStr = {'Spatial','Arrow','Color','Arrow/Spatial','Color/Spatial','Color/Arrow','Triple'};
addpath ExtraFns
addpath ../../Conflict/Analysis

for s = 1:length(subjname);
    % day 1
    %
    %data{s,1} = loadTRsubjData(subjname{s},{'spat_forcedRT_1','spat_forcedRT_2'});
    data{s,1} = loadTRsubjData(subjname{s},{'arrow_forcedRT_1','arrow_forcedRT_2','arrow_forcedRT_3','arrow_ForcedRT_4'});
    %data{s,3} = loadTRsubjData(subjname{s},{'col_forcedRT_1','col_forcedRT_2'});
    data{s,2} = loadTRsubjData(subjname{s},{'arrow_spat_forcedRT_1','arrow_spat_forcedRT_2','arrow_spat_forcedRT_3','arrow_spat_forcedRT_4'});
    %data{s,5} = loadTRsubjData(subjname{s},{'col_spat_forcedRT_1','col_spat_forcedRT_2'});
    data{s,3} = loadTRsubjData(subjname{s},{'col_arrow_forcedRT_1','col_arrow_forcedRT_2','col_arrow_forcedRT_3','col_arrow_forcedRT_4','col_arrow_forcedRT_5'});
    %data{s,7} = loadTRsubjData(subjname{s},{'col_all_forcedRT_1','col_all_forcedRT_2','col_all_forcedRT_3','col_all_forcedRT_4','col_all_forcedRT_5','col_all_forcedRT_6'});  
    %data{s,8} = loadTRsubjData(subjname{s},{'col_all_forcedRT_1','col_all_forcedRT_2','col_all_forcedRT_3'});%,'col_all_forcedRT_4','col_all_forcedRT_5','col_all_forcedRT_6'});  
    %data{s,9} = loadTRsubjData(subjname{s},{'col_all_forcedRT_4','col_all_forcedRT_5','col_all_forcedRT_6'});
    
end

Nc = size(data,2); % Number of conditions
%%
% figure out symbol goals and hit rate in conflict
for s=1:length(subjname)
    symb_key(s,1) = NaN; % arrow_key maps between image numbers and arrow directions
    arr_imgnum = [9:12];
    for i=1:4
        ii = find(data{s,2}.tFile(:,15)==arr_imgnum(i)); 
        symb_key(s,arr_imgnum(i)+1) = data{s,2}.tFile(ii(1),14);
    end
    % apply to conflict block
    for i=[] % no arrow blocks
        data{s,i}.goalDir_symb = NaN*ones(data{s,i}.Ntrials,1)';
    end
    for i=[1 2 3] % arrow blocks
        data{s,i}.goalDir_symb = symb_key(s,data{s,i}.tFile(:,15)+1);
    end
    %data{s,3}.goalDir_symb = NaN*ones(data{s,3}.Ntrials,1)';
    %data{s,4}.goalDir_symb = symb_key(s,data{s,4}.tFile(:,15)+1);
    for i=1:Nc
        data{s,i}.goalDir_symb = -mod(data{s,i}.goalDir_symb,360);
        data{s,i}.reachDir_symb = data{s,i}.reachDir-data{s,i}.goalDir_symb;
        data{s,i}.reachDir_symb = mod(data{s,i}.reachDir_symb,360)-180;
    end
end

save TRconflict_data_raw_Juan
%}
%% raw scatter plots
clear all
load TRconflict_data_raw_Juan
condStr = {'Arrow','Arrow/Spatial','Color/Arrow'};
RTmax = .7;
%{
for s=1:length(subjname)
    figure(i); clf; hold on
    for c=[7 8]
        subplot(3,2,c-6); hold on
        title(condStr{c})
        plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
        plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
        plot(data{s,c}.RT,data{s,c}.reachDir_goal,'.','markersize',13)
        axis([0 RTmax -180 180])
        xlabel('Reaction Time (s)')
        ylabel('Goal Error')
        
        subplot(3,2,2+c-6); hold on
        title(condStr{c})
        plot(data{s,c}.RT,data{s,c}.reachDir_spat,'.','markersize',13)
        plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
        plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
        axis([0 RTmax -180 180])
        axis([0 RTmax -180 180])
        xlabel('Reaction Time (s)')
        ylabel('Spatial Error')
        
        subplot(3,2,4+c-6); hold on
        title(condStr{c})
        plot(data{s,c}.RT,data{s,c}.reachDir_symb,'.','markersize',13)
        plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
        plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
        axis([0 RTmax -180 180])
        axis([0 RTmax -180 180])
        xlabel('Reaction Time (s)')
        ylabel('Symbol Error')
    end
end

%}


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
%% show unary speed-accuracy tradeoffs
for s=1:length(subjname)
    figure(1); clf; hold on
    %subplot(3,1,1); hold on
    plot(RTplot, phit_spat(s,:,1),'k','linewidth',2)
    %plot(RTplot, phit_goal(s,:,1),'ko')
    %plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    
    %subplot(3,1,2); hold on
    %plot(RTplot, phit_goal(s,:,2),'b','linewidth',2)
    plot(RTplot, phit_symb(s,:,2),'b','linewidth',2)
    %plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    
    %subplot(3,1,3); hold on
    plot(RTplot, phit_goal(s,:,3),'m','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    legend('spatial','arrows','color')
    legend boxoff
end

%% show binary speed-accuracy tradeoffs
for s=1:1
    figure(2); clf; hold on
    subplot(3,1,1); hold on
    plot(RTplot,phit_spat(s,:,1),'k','linewidth',2)
    plot(RTplot,phit_symb(s,:,1),'b','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    legend('spatial','arrows')
    legend boxoff
    
    subplot(3,1,2); hold on
    plot(RTplot,phit_spat(s,:,2),'k','linewidth',2)
    plot(RTplot,phit_goal(s,:,2),'m','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    legend('spatial','color')
    legend boxoff
    
    subplot(3,1,3); hold on
    plot(RTplot,phit_symb(s,:,3),'b','linewidth',2)
    plot(RTplot,phit_goal(s,:,3),'m','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 RTmax -.05 1.05])
    legend('arrow','color')
    legend boxoff
end
%% show triple-conflict trade-offs
figure(13); clf; hold on
plot(RTplot,phit_spat(s,:,7),'k','linewidth',2)
plot(RTplot,phit_symb(s,:,7),'b','linewidth',2)
plot(RTplot,phit_goal(s,:,7),'m','linewidth',2)
plot([0 .7],[.25 .25],'k')
axis([0 RTmax -.05 1.05])
legend('spatial','arrow','color')
legend boxoff

figure(14); clf; hold on
subplot(2,1,1); hold on
plot(RTplot,phit_spat(s,:,8),'k','linewidth',2)
plot(RTplot,phit_symb(s,:,8),'b','linewidth',2)
plot(RTplot,phit_goal(s,:,8),'m','linewidth',2)
plot([0 .7],[.25 .25],'k')
axis([0 RTmax -.05 1.05])
legend('spatial','arrow','color')
legend boxoff

subplot(2,1,2); hold on
plot(RTplot,phit_spat(s,:,9),'k','linewidth',2)
plot(RTplot,phit_symb(s,:,9),'b','linewidth',2)
plot(RTplot,phit_goal(s,:,9),'m','linewidth',2)
plot([0 .7],[.25 .25],'k')
axis([0 RTmax -.05 1.05])
legend('spatial','arrow','color')
legend boxoff
%%
for s=1:length(subjname)
    figure(40+s); clf; hold on
    plot(RTplot,phit_goal(s,:,1),'k','linewidth',2)
    plot(RTplot,phit_goal(s,:,2),'g','linewidth',2)
    plot(RTplot,phit_goal(s,:,3),'m','linewidth',2)
    plot(RTplot,phit_goal(s,:,4),'y','linewidth',2)
end
%% day 2 SATs
for s=1:length(subjname)
    figure(60+s); clf; hold on
    subplot(2,2,1); hold on
    title('color')
    plot(RTplot,phit_goal(s,:,5),'m','linewidth',2)
    plot(RTplot,phit_goal(s,:,3),'m:','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 .7 0 1])
    
    subplot(2,2,2); hold on
    title('symbol')
    plot(RTplot,phit_goal(s,:,6),'g','linewidth',2)
    plot(RTplot,phit_goal(s,:,2),'g:','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 .7 0 1])
    
    subplot(2,2,3); hold on
    title('color during conflict')
    plot(RTplot,phit_goal(s,:,7),'k','linewidth',2)
    plot(RTplot,phit_goal(s,:,4),'k:','linewidth',2)
    
    plot([0 .7],[.25 .25],'k')
    axis([0 .7 0 1])
    subplot(2,2,4); hold on
    title('symbol during conflict')
    plot(RTplot,phit_symb(s,:,7),'b','linewidth',2)
    plot(RTplot,phit_symb(s,:,4),'b:','linewidth',2)
    plot([0 .7],[.25 .25],'k')
    axis([0 .7 0 1])
end

%% conflict
for s=1:length(subjname)
    figure(70+s); clf; hold on
    subplot(2,1,1); hold on
    title('Day 1')
    plot(RTplot,phit_goal(s,:,4),'m','linewidth',2)
    plot(RTplot,phit_symb(s,:,4),'r','linewidth',2)
    plot(RTplot([1 end]),[.25 .25],'k-')
    legend('color','symbol')
    plot([0 .7],[.25 .25],'k')
    axis([0 .7 0 1])
    
    subplot(2,1,2); hold on
    title('Day 2')
    plot(RTplot,phit_goal(s,:,7),'m','linewidth',2)
    plot(RTplot,phit_symb(s,:,7),'r','linewidth',2)
    plot(RTplot([1 end]),[.25 .25],'k-')
    legend('color','symbol')
    plot([0 .7],[.25 .25],'k')
    axis([0 .7 0 1])
end

%%
for s=1:length(subjname)
    figure(30+s); clf; hold on
 
        subplot(2,1,1); hold on
        title('symbolic');
        plot(RTplot,phit_goal(s,:,2),'g','linewidth',3)
        plot(RTplot,phit_goal(s,:,3),'k','linewidth',2)
        plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
        legend('No-Conflict','conflict')
        legend boxoff
        axis([0 RTmax -.05 1.05])
    
        subplot(2,1,2); hold on
        title('spatial');
        plot(RTplot,phit_symb(s,:,1),'r','linewidth',3)
        plot(RTplot,phit_symb(s,:,3),'k','linewidth',2)
        plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
        legend('No-conflict','Conflict')
        legend boxoff
        axis([0 RTmax -.05 1.05])
end

%%
figure(51); clf; hold on
for c=1:3
    subplot(3,1,c); hold on
    title(condStr{c});
    plot(RTplot,meanNaN(phit_goal(:,:,c)),'g','linewidth',3)
    plot(RTplot,meanNaN(phit_symb(:,:,c)),'r','linewidth',2)
    shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,c)),stdNaN(phit_goal(:,:,c))/sqrt(length(subjname)),'g',.5)
    shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,c)),stdNaN(phit_symb(:,:,c))/sqrt(length(subjname)),'r',.5)
    plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
    legend('p(move to correct goal)','p(move to symbol location')
    legend boxoff
    axis([0 RTmax -.05 1.05])
end
%% compare speed-accuracy curves in conflict versus non-conflict scenarios
figure(52); clf; hold on
subplot(2,1,1); hold on
shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,1)),stdNaN(phit_symb(:,:,1))/sqrt(length(subjname)),'r',.5)
shadedErrorBar(RTplot,meanNaN(phit_symb(:,:,3)),stdNaN(phit_symb(:,:,3))/sqrt(length(subjname)),'k',.5)
axis([0 RTmax -.05 1.05])

subplot(2,1,2); hold on
shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,2)),stdNaN(phit_goal(:,:,2))/sqrt(length(subjname)),'g',.5)
shadedErrorBar(RTplot,meanNaN(phit_goal(:,:,3)),stdNaN(phit_goal(:,:,3))/sqrt(length(subjname)),'k',.5)
axis([0 RTmax -.05 1.05])
xlabel('Reaction Time / s')
ylabel('Probability')

%%
save TRconflict_ALL data phit_goal phit_symb

