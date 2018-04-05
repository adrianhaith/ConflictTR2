% Analyze conflict data
addpath ExtraFns
%
subjname = {'Benjamin','Kim','Akshay','Tanner','Juan','Jorge','Obi','Juan2'};
condStr = {'Spatial','Symbolic','Conflict'};
addpath ExtraFns

for i = 1:length(subjname);
    data{i,1} = loadTRsubjData(subjname{i},{'spat_ForcedRT_1','spat_ForcedRT_2'});
    data{i,2} = loadTRsubjData(subjname{i},{'symb_ForcedRT_1','symb_ForcedRT_2'});
    data{i,3} = loadTRsubjData(subjname{i},{'conf_ForcedRT_1','conf_ForcedRT_2'});
end

save TRconflict_data_raw
%}
%% raw scatter plots
clear all
load TRconflict_data_raw
RTmax = .7;
for i=1:length(subjname)
    figure(i); clf; hold on
    for c=1:3
        subplot(2,3,c); hold on
        title(condStr{c})
        plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
        plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
        plot(data{i,c}.RT,data{i,c}.reachDir_goal,'.')
        axis([0 RTmax -180 180])
        xlabel('Reaction Time (s)')
        ylabel('Goal Error')
        
        subplot(2,3,3+c); hold on
        title(condStr{c})
        plot(data{i,c}.RT,data{i,c}.reachDir_spat,'.')
        plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
        plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
        axis([0 RTmax -180 180])
        axis([0 RTmax -180 180])
        xlabel('Reaction Time (s)')
        ylabel('Stimulus Error')
    end
end
%% sliding window
RTplot = [0:.001:1];
w = .075; % sliding window width
TOL = 30; % hit tolerance +/-

for s=1:length(subjname)
    for c = 1:3
        data{s,c}.hit_goal = abs(data{s,c}.reachDir_goal)<TOL;
        data{s,c}.hit_symb = abs(data{s,c}.reachDir_spat)<TOL;
        for i=1:length(RTplot)
            t = RTplot(i);
            igood = find(data{s,c}.RT>t-w/2 & data{s,c}.RT<t+w/2);
            if(length(igood)>3)
                phit_goal(s,i,c) = mean(data{s,c}.hit_goal(igood));
                phit_symb(s,i,c) = mean(data{s,c}.hit_symb(igood));
            else
                phit_goal(s,i,c) = NaN;
                phit_symb(s,i,c) = NaN;
            end
        end
    end
    %phit_symb(2,:) = NaN; % set to NaNs since this is meaningless data
end
%% show speed-accuracy tradeoffs for each subject in each condition (new window fore each subject)
for s=1:length(subjname)
    figure(20+s); clf; hold on
    for c=1:3
        subplot(3,1,c); hold on
        title(condStr{c});
        plot(RTplot,phit_goal(s,:,c),'g','linewidth',3)
        plot(RTplot,phit_symb(s,:,c),'r','linewidth',2)
        plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
        legend('p(move to correct goal)','p(move to symbol location')
        legend boxoff
        axis([0 RTmax -.05 1.05])
    end
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
    plot(RTplot,nanmean(phit_goal(:,:,c)),'g','linewidth',3)
    plot(RTplot,nanmean(phit_symb(:,:,c)),'r','linewidth',2)
    shadedErrorBar(RTplot,nanmean(phit_goal(:,:,c)),stdNaN(phit_goal(:,:,c))/sqrt(length(subjname)),'g',.5)
    shadedErrorBar(RTplot,nanmean(phit_symb(:,:,c)),stdNaN(phit_symb(:,:,c))/sqrt(length(subjname)),'r',.5)
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

%% make compact
for i=1:length(subjname)
    for j=1:3
        d{i,j} = data{i,j};
        rmfield(d{i,j},'handPos')
        rmfield(d{i,j},'handPos_rotated')
        rmfield(d{i,j},'tanVel')
        rmfield(d{i,j},'handVel_rot')
    end
end
        

save TRconflict_ALL d phit_goal phit_symb
