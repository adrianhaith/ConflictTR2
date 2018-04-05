function pOpt = fit_speed_accuracy_AE(RT,hit)
% generates parametric fit to speed-accuracy trade-off data

%figure(10); clf; hold on
%subplot(2,1,1); hold on
% plot(RT,reachDir,'.');
xplot = [0:.001:.8];
% plot([0 .5],22.5*[1 1],'k:')
% plot([0 .5],-22.5*[1 1],'k:')

sigma = .1; % slope
mu = .15; % middle of slope
AE = .9; % asymptotic error

pInit = [sigma mu -log(1/AE - 1)];
pInit = [.144 .0365 .938];
pInit(3) = -log(1/pInit(3)-1);
Ntargs = 4;

% get rid of bad trials
igood = find(~isnan(RT) & ~isnan(hit));
RT = RT(igood);
hit = hit(igood);

%LLall = hit.*log((1/8+AE*normcdf(RT,mu,sigma)*7/8)) + (1-hit).*log(1-(1/8+AE*normcdf(RT,mu,sigma)*7/8));
% log-likelihood of all data
LL = @(params) -sum(hit.*log((1/Ntargs+normcdf(RT,params(1),params(2))*((1/(1+exp(-params(3))))-1/Ntargs))) + (1-hit).*log(1-(1/Ntargs+normcdf(RT,params(1),params(2))*((1/(1+exp(-params(3))))-1/Ntargs))));
LL([mu sigma AE])

pOpt = [mu sigma AE];
pOpt = fminsearch(LL,pInit); % try to find the optimum
LL(pOpt)
%pOpt(3) = AE;
pOpt(3) = 1/(1+exp(-pOpt(3)));
%% sliding window to visualize data
w = 0.1;
for i=1:length(xplot)
    igood = find(RT>xplot(i)-w/2 & RT<=xplot(i)+w/2);
    phit_sliding(i) = mean(hit(igood));
end
% plot fit
%subplot(2,1,2); hold on
%ycdf = normcdf(xplot,pOpt(1),pOpt(2));
%plot(xplot,1/Ntargs + ycdf*(pOpt(3)-1/Ntargs),'b','linewidth',2);
%plot(xplot,phit_sliding)
