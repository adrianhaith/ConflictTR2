function model = fit_model(RT,response,Nprocesses)
% fits selection model to forced RT data by max. likelihood
%
% Inputs:
%       RT - vector of reaction times for each trial (in s)
%       response - vector of response IDs (1 = spatial, 2 = symbolic, 3 =
%       other)
%       Nprocesses - (1-3) number of processes (and, accordingly, response types)
%       
% Outputs:
%       params - optimized parameters
%       presponse - time-varying response probabilities
%
%
% Model parametrization:
%       params = [ [mu_i sigma_i] - mean and variability of RT
%                                   distribution for each process
%                   qN            - asymptotic error for last process
%                   qInit ]         - lower asymptotic error
%

optimizer='fmincon'; % 'bads' or 'fmincon'

% set up bounds for model
LB_soft = .0001; % lower bound close to 0
UB_soft = .9999; % upper bound close to 1

% set up bounds and constraints
switch Nprocesses
    case 1
        paramsInit = [.4 .05 .95 .25];
        LB = [0 .01 .5 LB_soft];
        PLB = [.2 .02 .6 .1];
        UB = [.75 100 UB_soft .4];
        PUB = [.7 .1 UB_soft .4];
        
        A = []; B = []; % inequality constraints
    case 2
        paramsInit = [.4 .05 .5 .05 .95 .25];
        LB = [0 .01 0 .01 .5 LB_soft];
        PLB = [.2 .02 .2 .02 .6 .1];
        UB = [.75 100 .75 100 UB_soft .5];
        PUB = [.7 .1 .7 .1 UB_soft .4];
        
        A = [1 0 -1 0 0 0]; B = [0]; % inequality constraints (mu1 < mu2)
        
    case 3
        paramsInit = [.4 .05 .4 .05 .5 .05 .95 .25];
        LB = [0 .01 0 .01 0 .01 .5 LB_soft];
        PLB = [.2 .02 .2 .02 .2 .02 .6 .1];
        UB = [.75 100 .75 100 .75 100 UB_soft .5];
        PUB = [.7 .1 .7 .1 .7 .1 UB_soft .4];
        
        A = [1 0 -1 0 0 0 0 0; 0 0 1 0 -1 0 0 0]; B = [0; 0]; % inequality constraints (mu1<m2; mu2<mu3)
end
Aeq = []; Beq = [];

% weed out bad trials
good_trials = ~isnan(RT);
RT = RT(good_trials);
response = response(good_trials);


like_fun = @(params) habit_lik(RT,response,params,Nprocesses);


model.xplot = [0:.001:.6];
model.nLL_init = like_fun(paramsInit);
%keyboard
switch(optimizer)
    case 'bads'
        [model.paramsOpt, model.LLopt] = bads(like_fun,paramsInit,LB,UB,PLB,PUB);
        
    case 'fmincon'
        %[model(m).paramsOpt(subject,:,c), model(m).LLopt(c,subject)] = fmincon(like_fun,paramsInit,A,B,Aeq,Beq,LB,UB);
        [model.paramsOpt, model.LLopt] = fmincon(like_fun,paramsInit,A,B,Aeq,Beq,LB,UB);
end


model.presponse = getResponseProbs(model.xplot,model.paramsOpt,Nprocesses)
model.nLL = like_fun(model.paramsOpt);
                

