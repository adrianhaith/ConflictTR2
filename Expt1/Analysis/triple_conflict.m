% 3-event model: A, notA, B

% nice params:
% pA = [0.16 .024 .94];
% pB = [.3 .07 .88];
% pC = [.3 .05 .88];

pA = [0.2 .04 .94];
pB = [.35 .09 .88];
pC = [.4 .07 .88];

a = pA(3);

[xx Acdf] = model_sigmoid(pA,RTplot,4);
[xx Bcdf] = model_sigmoid(pB,RTplot,4);
[xx Ccdf] = model_sigmoid(pC,RTplot,4);

figure(23); clf; hold on
plot(RTplot,Acdf,'r')
plot(RTplot,Bcdf,'b')
plot(RTplot,Ccdf,'g')
%%
pp = [(1-Acdf).*(1-Bcdf).*(1-Ccdf);
      Acdf.*(1-Bcdf).*(1-Ccdf);
      (1-Acdf).*Bcdf.*(1-Ccdf);
      (1-Acdf).*(1-Bcdf).*Ccdf;
      Acdf.*Bcdf.*(1-Ccdf);
      (1-Acdf).*Bcdf.*Ccdf;
      Acdf.*(1-Bcdf).*Ccdf;
      Acdf.*Bcdf.*Ccdf];
  
  
aa = [.25 ; % !A !B !C
      pA(3); % A !B !C 
      .25 ; % !A B !C
      (1-pC(3))/3; % !A !B C
      .25 ; % A B !C
      (1-pC(3))/3; % !A B C
      (1-pC(3))/3; % A !B C
      (1-pC(3))/3]; % A B C

ac = [.25; % !A !B !C
      (1-pA(3))/3; % A !B !C 
      .25; % !A B !C
      pC(3); % !A !B C
      .25; % A B !C
      pC(3); % !A B C
      pC(3); % A !B C
      pC(3)]; % A B C
  
probA = sum(repmat(aa,1,size(pp,2)).*pp);
probC = sum(repmat(ac,1,size(pp,2)).*pp);
probO = 1-probA-probC



figure(20); clf; hold on
plot(RTplot,probA,'r')
plot(RTplot,probC,'g')
plot(RTplot,probO,'m')

axis([0 .6 0 1])
plot([0 .6],[.25 .25],'k:')

%% same but including congruent trials
aa = [.25 ; % !A !B !C
      pA(3); % A !B !C 
      .25 ; % !A B !C
      .25; % !A !B C
      .25 ; % A B !C
      .25; % !A B C
      .25; % A !B C
      .25]; % A B C

ac = [.25; % !A !B !C
      .25; % A !B !C 
      .25; % !A B !C
      pC(3); % !A !B C
      .25; % A B !C
      pC(3); % !A B C
      pC(3); % A !B C
      pC(3)]; % A B C

probA = sum(repmat(aa,1,size(pp,2)).*pp);
probC = sum(repmat(ac,1,size(pp,2)).*pp);
probO = 1-probA-probC

figure(21); clf; hold on
plot(RTplot,probA,'r')
plot(RTplot,probC,'g')
plot(RTplot,probO,'m')

axis([0 .6 0 1])
plot([0 .6],[.25 .25],'k:')

shadedErrorBar(RTplot,conf.phit_spat,.1./sqrt(conf.N),'r');
shadedErrorBar(RTplot,conf.phit_symb,.1./sqrt(symb.N),'g');