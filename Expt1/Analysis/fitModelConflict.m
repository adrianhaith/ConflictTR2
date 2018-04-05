% fit model to Montrell's conflict data
%clear all
%load TRconflict_ALL
%%
Ntargs = 4;
Nsubj = size(d,1);
%
for s = 1:Nsubj;
    
    RTplot = [0:.001:1];
    
    
    % spatial
    
    pOpt_spat = fit_speed_accuracy_AE2(d{s,1}.RT,d{s,1}.hit_goal');
    ycdf_spat = normcdf(RTplot,pOpt_spat(1),pOpt_spat(2));
    
    % symbolic
    pOpt_symb = fit_speed_accuracy_AE2(d{s,2}.RT,d{s,2}.hit_goal');
    ycdf_symb = normcdf(RTplot,pOpt_symb(1),pOpt_symb(2));
    
    % symbolic conflict
    pOpt_symb_conf = fit_speed_accuracy_AE2(d{s,3}.RT,d{s,3}.hit_goal');
    ycdf_symb_conf = normcdf(RTplot,pOpt_symb_conf(1),pOpt_symb_conf(2));
    
    % errors
    a = [.25 pOpt_spat(3) (1-pOpt_symb(3))/3];
    pErr = a(1)*(1-ycdf_spat).*(1-ycdf_symb)+ a(2)*ycdf_spat.*(1-ycdf_symb)+ a(3)*ycdf_symb;
    
    
    %
    figure(100+s); clf; hold on
    plot(RTplot,meanNaN(phit_symb(s,:,1)),'b','linewidth',2)
    plot(RTplot,1/Ntargs + ycdf_spat*(pOpt_spat(3)-1/Ntargs),'b','linewidth',1);
    
    plot(RTplot,meanNaN(phit_goal(s,:,2)),'g','linewidth',2)
    plot(RTplot,1/Ntargs + ycdf_symb*(pOpt_symb(3)-1/Ntargs),'g','linewidth',1);
        
    plot(RTplot,phit_symb(s,:,3),'r','linewidth',2)
    plot(RTplot,pErr,'r')
    
    plot(RTplot,phit_goal(s,:,3),'m','linewidth',2)
    plot(RTplot,1/Ntargs + ycdf_symb_conf*(pOpt_symb_conf(3)-1/Ntargs),'m','linewidth',1)
    
end
%}

% 
%% aggregate data
% fit to pooled data - more robust relationship between non-conflict and
% conflict conditions
   
spat.RT = [];
spat.hit_goal = [];

%%
symb.RT = [];
symb.hit_goal = [];

conf.RT = [];
conf.hit_symb = [];
conf.hit_spat = [];

for s=1:Nsubj
    spat.RT = [spat.RT d{s,1}.RT];
    spat.hit_goal = [spat.hit_goal d{s,1}.hit_goal'];
   
    symb.RT = [symb.RT d{s,2}.RT];
    symb.hit_goal = [symb.hit_goal d{s,2}.hit_goal'];
    
    conf.RT = [conf.RT d{s,3}.RT];
    conf.hit_symb = [conf.hit_symb d{s,3}.hit_goal'];
    conf.hit_spat = [conf.hit_spat d{s,3}.hit_symb'];
end
   
% sliding window
w = .025;
[spat.phit_spat spat.N] = sliding_window(spat.RT,spat.hit_goal,RTplot,w)
[symb.phit_symb symb.N] = sliding_window(symb.RT,symb.hit_goal,RTplot,w)
[conf.phit_spat conf.N] = sliding_window(conf.RT,conf.hit_spat,RTplot,w)
[conf.phit_symb conf.N] = sliding_window(conf.RT,conf.hit_symb,RTplot,w)

spat.pOpt = fit_speed_accuracy_AE(spat.RT,spat.hit_goal);
symb.pOpt = fit_speed_accuracy_AE(symb.RT,symb.hit_goal);

[spat.phit_model spat.ycdf] = model_sigmoid(spat.pOpt,RTplot,4);
[symb.phit_model symb.ycdf] = model_sigmoid(symb.pOpt,RTplot,4);

%%
figure(10); clf; hold on
%subplot(2,1,1); hold on
plot(RTplot, spat.phit_spat,'m');
plot(RTplot, symb.phit_symb),'y';
plot(RTplot, conf.phit_spat,'r')
plot(RTplot, conf.phit_symb,'b')

shadedErrorBar(RTplot,spat.phit_spat,.1./sqrt(spat.N),'m');
shadedErrorBar(RTplot,symb.phit_symb,.1./sqrt(symb.N),'b');
shadedErrorBar(RTplot,conf.phit_spat,.1./sqrt(conf.N),'r');
%subplot(2,1,2); hold on
%%
spat.pOpt = fit_speed_accuracy_AE(spat.RT,spat.hit_goal);
symb.pOpt = fit_speed_accuracy_AE(symb.RT,symb.hit_goal);

%figure(11); clf; hold on
plot(RTplot,model_sigmoid(spat.pOpt,RTplot,4),'m--');
plot(RTplot,model_sigmoid(symb.pOpt,RTplot,4),'y--');

% predict behavior under conflict condition
aa = [.25 .25 symb.pOpt(3)];
conf.phit_symb_model = sum([aa(1)*(1-symb.ycdf).*(1-spat.ycdf); aa(2)*spat.ycdf.*(1-symb.ycdf); aa(3)*symb.ycdf]);

ab = [.25 spat.pOpt(3) .25];
conf.phit_spat_model = sum([ab(1)*(1-symb.ycdf).*(1-spat.ycdf); ab(2)*spat.ycdf.*(1-symb.ycdf); ab(3)*symb.ycdf]);

plot(RTplot,conf.phit_symb_model,'b--')

%pInit = [.144 .0365 .938];

%plot(RTplot,model_sigmoid(pInit,RTplot,4),'k')
plot(RTplot,conf.phit_spat_model,'r--')
%%
axis([0 .6 0 1])

%% fit to conflict condition
%{
conf.pOpt_symb = fit_speed_accuracy_AE(conf.RT,conf.hit_symb);
plot(RTplot,model_sigmoid(conf.pOpt_symb,RTplot,4),'g')

% plot p(error|RT) for observed symbol responses
[conf.phit_model_symb conf.ycdf_symb] = model_sigmoid(conf.pOpt_symb,RTplot,4);
aa = [.25 .25 conf.pOpt_symb(3)];
conf.phit_symb_model2 = sum([aa(1)*(1-conf.ycdf_symb).*(1-spat.ycdf); aa(2)*spat.ycdf.*(1-conf.ycdf_symb); aa(3)*conf.ycdf_symb]);
%plot(RTplot,conf.phit_symb_model2,'y--')

ab = [.25 conf.pOpt_symb(3) .25];
conf.phit_spat_model2 = sum([ab(1)*(1-conf.ycdf_symb).*(1-spat.ycdf); ab(2)*spat.ycdf.*(1-conf.ycdf_symb); ab(3)*conf.ycdf_symb]);
plot(RTplot,conf.phit_spat_model2,'r-')
%}