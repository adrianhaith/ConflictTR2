function [presponse p_noconfl] = getResponseProbs(RT,params)
% returns response probabilities (correct, habit, error) given RTs and
% parameters
paramsA = params(1:3);
paramsB = params(4:6);
paramsC = params(7:9);
q0 = params(10);
aA = params(11); aaA = 1-aA;
aB = params(12); aaB = 1-aB;

PhiA = normcdf(RT,paramsA(1),paramsA(2)); % probability that A has been planned by RT
PhiB = normcdf(RT,paramsB(1),paramsB(2));
PhiC = normcdf(RT,paramsC(1),paramsC(2));

qA = paramsA(3); qqA = (1-qA)/3;
qB = paramsB(3); qqB = (1-qB)/3;
qC = paramsC(3); qqC = (1-qC)/3;

%alpha = zeros(5,4);

    % set up parameters:
    %     p(r) = alpha(.,1)*(1-PhiA)*(1-PhiB) + alpha(.,2)*PhiA*(1-PhiB) +
    %     alpha(.,3)*(1-PhiA)*PhiB + alpha(.,4)*PhiA*PhiB

        A_symb = [q0 q0 q0 q0;
                 qA qqA qqA qqA;
                 qqB qB qqB qqB;
                 qqC qqC qC qqC;
                 qqB qB qqB qqB;
                 qqC qqC qC qqC;
                 qqC qqC qC qqC;
                 qqC qqC qC qqC];
                 
        A_noconfl = [q0 q0 q0;
                     qA q0 q0; 
                     q0 qB q0;
                     q0 q0 qC;
                     qA qB q0;
                     qA q0 qC;
                     q0 qB qC;
                     qA qB qC];
             
             
     A_nosymb = [q0 q0 q0 q0;
                        qA qqA qqA qqA;
                        qA qqA qqA qqA;
                        qqC qqC qC qqC;
                        qA qqA qqA qqA;
                        qqC qqC qC qqC;
                        qqC qqC qC qqC;
                        qqC qqC qC qqC];
                    
    A_mix = [q0 q0 q0 q0;
             aA*qA+aaA*q0 aA*qqA+aaA*q0 aA*qqA+aaA*q0 aA*qqA+aaA*q0;
             aB*qqB+aaB*q0 aB*qB+aaB*q0 aB*qqB+aaB*q0 aB*qqB+aaB*q0;
             qqC qqC qC qqC;
             aB*qqB+aA*aaB*qA+aaA*aaB*q0 aB*qB+aA*aaB*qqA+aaA*aaB*q0 aB*qqB+aA*aaB*qqA+aaA*aaB*q0 aB*qqB+aA*aaB*qqA+aaA*aaB*q0;
             qqC qqC qC qqC;
             qqC qqC qC qqC;
             qqC qqC qC qqC];
              
             
                        A = aB*A_symb + (1-aB)*A_nosymb;
                        A = A_mix;
                        %A = A_symb;
                        
%for i=1:5
%    presponse(i,:) = alpha(i,1)*(1-PhiA).*(1-PhiB) + alpha(i,2)*PhiA.*(1-PhiB) + alpha(i,3)*(1-PhiA).*PhiB + alpha(i,4)*PhiA.*PhiB;
%end
Phi = [(1-PhiA).*(1-PhiB).*(1-PhiC);
        PhiA.*(1-PhiB).*(1-PhiC);
        (1-PhiA).*PhiB.*(1-PhiC);
        (1-PhiA).*(1-PhiB).*PhiC;
        PhiA.*PhiB.*(1-PhiC);
        PhiA.*(1-PhiB).*PhiC;
        (1-PhiA).*PhiB.*PhiC;
        PhiA.*PhiB.*PhiC];
presponse = A'*Phi;

p_noconfl = A_noconfl'*Phi;