%% computational model for triple conflict task
% fit models to single conditions
addpath ExtraFns

clear all
load triple_conflict_data
Nsubj = size(d,1);
for s=1:Nsubj
    disp(['s = ',num2str(s)])
    d(s,1).params = fit_speed_accuracy(d(s,1).RT,d(s,1).hit_spat);
    d(s,2).params = fit_speed_accuracy(d(s,2).RT,d(s,2).hit_symb);
    d(s,3).params = fit_speed_accuracy(d(s,3).RT,d(s,3).hit_col);
end

%% fit to pooled data
p_spat = fit_speed_accuracy([d(:,1).RT],[d(:,1).hit_spat])
p_symb = fit_speed_accuracy([d(:,2).RT],[d(:,2).hit_symb])
p_col = fit_speed_accuracy([d(:,3).RT],[d(:,3).hit_col])

%% use these parameters to compute triple conflict behavior
xplot = [0:.001:1];

paramsAll = [p_spat(1:3) p_symb(1:3) p_col(1:3) .25 1 1];

%{
Phi1 = normcdf(xplot,p_spat(1),p_spat(2));
Phi2 = normcdf(xplot,p_symb(1),p_symb(2));
Phi3 = normcdf(xplot,p_col(1),p_col(2));

q0 = .25;
q1 = .95; qq1 = (1-q1)/3;
q2 = .95; qq2 = (1-q2)/3;
q3 = p_col(3); qq3 = (1-q3)/3;

PHI = [(1-Phi1).*(1-Phi2).*(1-Phi3);
       Phi1.*(1-Phi2).*(1-Phi3);
       (1-Phi1).*Phi2.*(1-Phi3);
       (1-Phi1).*(1-Phi2).*Phi3;
       Phi1.*Phi2.*(1-Phi3);
       Phi1.*(1-Phi2).*Phi3;
       (1-Phi1).*Phi2.*Phi3;
       Phi1.*Phi2.*Phi3];
   
A = [q0 q0 q0 q0;
     q1 qq1 qq1 qq1;
     qq2 q2 qq2 qq2;
     qq3 qq3 q3 qq3;
     qq2 q2 qq2 qq2;
     qq3 qq3 q3 qq3;
     qq3 qq3 q3 qq3;
     qq3 qq3 q3 qq3];
 %}
 %p_response = A'*PHI;
 p_response = getResponseProbs3(xplot,paramsAll);
 
 figure(5); clf; hold on
 plot(xplot,p_response','linewidth',2);
     
xlim([0 .8])
ylim([0 1])

%% now do same for single subjects

for s=1:Nsubj
    p_spat(s,:) = fit_speed_accuracy(d(s,1).RT,d(s,1).hit_spat);
    p_symb(s,:) = fit_speed_accuracy(d(s,2).RT,d(s,2).hit_symb);
    p_col(s,:) = fit_speed_accuracy(d(s,3).RT,d(s,3).hit_col);
end
%%
clear p_response
  for s=1:Nsubj  
      
      paramsAll(s,:) = [p_spat(s,1:3) p_symb(s,1:3) p_col(s,1:3) .25 .7 .6];
      paramsAll(s,5) = 1.2*paramsAll(s,5);
      paramsAll(s,4) = paramsAll(s,4)+ .02;
      paramsAll(s,3) = 1;
      paramsAll(s,6) = 1;
     %{ 
      
    Phi1 = normcdf(xplot,p_spat(s,1),p_spat(s,2));
    Phi2 = normcdf(xplot,p_symb(s,1),p_symb(s,2));
    Phi3 = normcdf(xplot,p_col(s,1),p_col(s,2));
    
    q0 = .25;
    q1 = .9; qq1 = (1-q1)/3;
    q2 = .9; qq2 = (1-q2)/3;
    q3 = p_col(s,3); qq3 = (1-q3)/3;
    
    PHI = [(1-Phi1).*(1-Phi2).*(1-Phi3);
        Phi1.*(1-Phi2).*(1-Phi3);
        (1-Phi1).*Phi2.*(1-Phi3);
        (1-Phi1).*(1-Phi2).*Phi3;
        Phi1.*Phi2.*(1-Phi3);
        Phi1.*(1-Phi2).*Phi3;
        (1-Phi1).*Phi2.*Phi3;
        Phi1.*Phi2.*Phi3];
    
    A = [q0 q0 q0 q0;
        q1 qq1 qq1 qq1;
        qq2 q2 qq2 qq2;
        qq3 qq3 q3 qq3;
        qq2 q2 qq2 qq2;
        qq3 qq3 q3 qq3;
        qq3 qq3 q3 qq3;
        qq3 qq3 q3 qq3];
    
    A_nosymb = [q0 q0 q0 q0;
        q1 qq1 qq1 qq1;
        q0 q0 q0 q0;
        qq3 qq3 q3 qq3;
        q1 qq1 qq1 qq1;
        qq3 qq3 q3 qq3;
        qq3 qq3 q3 qq3;
        qq3 qq3 q3 qq3];
    
    alpha = 0.5;
    %A_nosymb = alpha*A+(1-alpha)*A_nosymb;
    %}
    [p_response(s,:,:) p_response_nosymb(s,:,:)] = getResponseProbs3(xplot,paramsAll(s,:));%(A'*PHI)';
    %p_response_nosymb(s,:,:) = (A_nosymb'*PHI)';
    %{
    p_nosymb = A_nosymb'*PHI;
    for c=1:4
        p_repsonse(s,:,c) = p(c,:);
        p_response_nosymb
    p_response_nosymb(s,:,:) = A_nosymb'*PHI;
    %}
    rng = 1:1001;
    figure(20+s);
    subplot(2,2,2); cla; hold on
    plot(xplot,d(s,4).diff.phit_spat(rng),'r','linewidth',1.5)
    plot(xplot,d(s,4).diff.phit_symb(rng),'g','linewidth',1.5)
    plot(xplot,d(s,4).diff.phit_col(rng),'m','linewidth',1.5)
    plot(xplot,d(s,4).diff.phit_other(rng),'c','linewidth',1.5)
    
    subplot(2,2,4); cla; hold on
    plot(xplot,squeeze(p_response(s,1,:)),'r','linewidth',2);
    plot(xplot,squeeze(p_response(s,2,:)),'g','linewidth',2);
    plot(xplot,squeeze(p_response(s,3,:)),'m','linewidth',2);
    plot(xplot,1-sum(squeeze(p_response(s,1:3,:))),'c','linewidth',2);
    
    %plot(xplot,p_response_nosymb(s,:,1),'r:','linewidth',2)
    %plot(xplot,p_response_nosymb(s,:,2),'g:','linewidth',2)
    %plot(xplot,p_response_nosymb(s,:,3),'m:')
    
    xlim([0 .8])
    ylim([0 1])
    
    %figure(20+s); 
    subplot(2,2,1); cla; hold on
    plot(xplot,d(s,1).phit_spat(rng),'r','linewidth',1.5)
    plot(xplot,d(s,2).phit_symb(rng),'g','linewidth',1.5)
    plot(xplot,d(s,3).phit_col(rng),'m','linewidth',1.5)
    axis([0 .8 0 1])
    
    subplot(2,2,3); cla; hold on
    plot(xplot,p_spat(s,4)+(p_spat(s,3)-p_spat(s,4))*normcdf(xplot,p_spat(s,1),p_spat(s,2)),'r','linewidth',2)
    plot(xplot,p_symb(s,4)+(p_symb(s,3)-p_symb(s,4))*normcdf(xplot,p_symb(s,1),p_symb(s,2)),'g','linewidth',2)
    plot(xplot,p_col(s,4)+(p_col(s,3)-p_col(s,4))*normcdf(xplot,p_col(s,1),p_col(s,2)),'m','linewidth',2)
    axis([0 .8 0 1])
end
%% plot aggregate predictions

figure(20); clf; hold on
rng = 1:1001;
dt = 0.0;
subplot(2,1,1); hold on
plot([0 .6],[.25 .25],'k:')
shadedErrorBar(xplot,nanmean(dAll.phit_spat_all_confl(:,rng)),seNan(dAll.phit_spat_all_confl(:,rng)),'r')
shadedErrorBar(xplot,nanmean(dAll.phit_symb_all_confl(:,rng)),seNan(dAll.phit_symb_all_confl(:,rng)),'g')
shadedErrorBar(xplot,nanmean(dAll.phit_col_all_confl(:,rng)),seNan(dAll.phit_col_all_confl(:,rng)),'m')
shadedErrorBar(xplot,nanmean(dAll.phit_other_all_confl(:,rng)),seNan(dAll.phit_other_all_confl(:,rng)),'c')
xlim([0 .6])
ylim([0 1])

subplot(2,1,2); hold on
plot([0 .6],[.25 .25],'k:')
plot(xplot+dt,mean(squeeze(p_response(:,1,:))),'r','linewidth',2)
plot(xplot+dt,mean(squeeze(p_response(:,2,:))),'g','linewidth',2)
plot(xplot+dt,mean(squeeze(p_response(:,3,:))),'m','linewidth',2)
plot(xplot+dt,mean(1-squeeze(p_response(:,1,:))-squeeze(p_response(:,2,:))-squeeze(p_response(:,3,:))),'c','linewidth',2)
xlim([0 .6])
ylim([0 1])
plot(xplot+dt,mean(squeeze(p_response_nosymb(:,1,:))),'r:')
plot(xplot+dt,mean(squeeze(p_response_nosymb(:,2,:))),'g:')