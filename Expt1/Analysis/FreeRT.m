% Analyze FreeRT conflict data
%{
clear all

subjname = {'S101','S102','S103','S104','S105','S106','S108'};
condStr = {'Spatial','Symbolic','Conflict'};
addpath ExtraFns

Nsubj = length(subjname);

for i = 1:Nsubj;
    data{i,1} = loadTRsubjData(subjname{i},{'spat_FreeRT_1',});
    data{i,2} = loadTRsubjData(subjname{i},{'symb_FreeRT_1',});
    data{i,3} = loadTRsubjData(subjname{i},{'conf_FreeRT_1',});
end
save conflict_FreeRT
%}
%%
load conflict_FreeRT
bins = [0:.025:1];
for s=1:Nsubj
    figure(60+s); clf; hold on
    for c=1:3
        subplot(3,1,c); hold on
        hist(data{s,c}.RT,bins,'color','r');
        axis([0 1 0 40])
    end
end

%%
figure(60); clf; hold on
title('All subjects')
face_cols = [1 0 0; 0 1 0; 0 0 0];
for c=1:3
    RTall{c} = [];
    for s=1:Nsubj
        RTall{c} = [RTall{c} data{s,c}.RT(data{s,c}.RT<2)];
    end
    %subplot(3,1,c); hold on
    [nb xb] = hist(RTall{c},bins);
    %h = findobj(gca,'Type','patch');
    %h.FaceColor = [1 0 0];
    bh = bar(xb,nb);
    set(bh,'facecolor',face_cols(c,:));
    %set(get(gca,'child'),'FaceColor',face_cols(c,:),'EdgeColor','w');
    xlim([0 1])
end
       
%%
for c=1:3
    for s=1:Nsubj
        igood = data{s,c}.RT<2 & data{s,c}.RT>0;
        RTmedian(s,c) = median(data{s,c}.RT(igood)');
        RTmean(s,c) = mean(data{s,c}.RT(igood)');
    end
end

figure(61); clf; hold on
plot([0 1 2],RTmean,'.-')
plot([0 1 2],mean(RTmean),'k-','linewidth',2)
axis([-.02 2.02 0 1])
ylabel('mean RT')
text(0,0.7,'spatial')
text(1,0.7,'symbolic')
text(2,0.7,'conflict')
%%
[t p_spat_symb] = ttest(RTmean(:,2),RTmean(:,1),1,'paired')
[t p_conf] = ttest(RTmean(:,3),RTmean(:,2),1,'paired')

%[h p] = ttest2(RTmean(:,1),RTmean(:,2))
%disp(['Difference between symbolic and conflict = ',num2str(mean(RTmean(:,3) - RTmean(:,2))),]);

%disp(['mean RTs:  spatial = ',num2str(mean(RTmean(:,1))),';   symbolic = ',num2str(mean(RTmean(:,2))),';   conflict = ',num2str(mean(RTmean(:,3)))])

%% KDE to visualize RT distributions
xplot = [0:.001:1];
figure(70); clf; hold on
for c=1:3
    igood = RTall{c}<2 & RTall{c}>0;
    F(c,:) = ksdensity(RTall{c}(igood),xplot,'bandwidth',.025)
    plot(xplot,F(c,:),'color',face_cols(c,:),'linewidth',2)
end

%% scatter plot
figure(71); clf; hold on
for c=1:3
    for s=1:7
        Ntrials = size(data{s,c}.RT,2);
        plot(linspace(c-.25, c+.25, Ntrials),data{s,c}.RT,'.')
    end
end

%% congruent vs incongruent
RTall_congruent = [];
RTall_incongruent = [];
for s=1:Nsubj
    icongruent = find(data{s,3}.goalAng_symb==data{s,3}.goalAng_spat);
    iincongruent = find(data{s,3}.goalAng_symb~=data{s,3}.goalAng_spat);
    data{s,3}.congruent.RT = data{s,3}.RT(icongruent);
    data{s,3}.incongruent.RT = data{s,3}.RT(iincongruent);
    
    RTall_congruent = [RTall_congruent data{s,3}.congruent.RT];
    RTall_incongruent = [RTall_incongruent data{s,3}.incongruent.RT];
end

figure(72); clf; hold on
plot(xplot,ksdensity(RTall_congruent,xplot,'bandwidth',.025),'r','linewidth',2)
plot(xplot,ksdensity(RTall_incongruent,xplot,'bandwidth',.025),'g','linewidth',2)  
plot(xplot,ksdensity(RTall{2},xplot,'bandwidth',.025),'k','linewidth',2)
%% estimate speed-accuracy tradeoffs from FreeRT data
TOL = 45; % 45 tolerance on reach errors
w = .05; % 50 ms sliding window
for s=1:Nsubj
    for c=1:3
        data{s,c}.hit_spat = abs(data{s,c}.reachErr_spat)<TOL;
        data{s,c}.phit_spat = sliding_window(data{s,c}.RT,data{s,c}.hit_spat,xplot,w);
        
        data{s,c}.hit_symb = abs(data{s,c}.reachErr_symb)<TOL;
        data{s,c}.phit_symb = sliding_window(data{s,c}.RT,data{s,c}.hit_symb,xplot,w);
    end
end

figure(73); clf; hold on
for c=1:3
    subplot(3,1,c); hold on
    for s=1:Nsubj
        plot(xplot,data{s,c}.phit_spat,'r')
        plot(xplot,data{s,c}.phit_symb,'b')
    end
end

% averages
for c=1:3
    for s=1:Nsubj
        d_Free{c}.phit_spat(s,:) = data{s,c}.phit_spat;
        d_Free{c}.phit_symb(s,:) = data{s,c}.phit_symb;
    end
end
figure(74); clf; hold on
subplot(3,1,1); hold on
shadedErrorBar(xplot,nanmean(d_Free{1}.phit_spat),seNan(d_Free{1}.phit_spat),'r')
axis([0 1 0 1])

subplot(3,1,2); hold on
shadedErrorBar(xplot,nanmean(d_Free{2}.phit_symb),seNan(d_Free{2}.phit_spat),'b')
axis([0 1 0 1])

subplot(3,1,3); hold on
shadedErrorBar(xplot,nanmean(d_Free{3}.phit_spat),seNan(d_Free{3}.phit_spat),'r')
shadedErrorBar(xplot,nanmean(d_Free{3}.phit_symb),seNan(d_Free{3}.phit_spat),'b')
axis([0 1 0 1])

save Conflict_Expt1_FreeRT_compact d_Free

%% scatter plots for Free RT

figure(77); clf; hold on
subplot(2,1,1); hold on
for ss = 1:Nsubj;
    plot(1000*data{ss,1}.RT,data{ss,1}.reachErr_spat,'.')
    axis([0 1000 -180 180])
end
subplot(2,1,2); hold on
for ss = 1:Nsubj;
    plot(1000*data{ss,2}.RT,data{ss,2}.reachErr_symb,'.')
    axis([0 1000 -180 180])
end

%% congruent vs incongruent
