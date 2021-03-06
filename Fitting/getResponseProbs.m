function presponse = getResponseProbs(RT,params,Nresponses,incongruent)
% returns response probabilities (correct, habit, error) given RTs and
% parameters
if(nargin<4)
    incongruent = 1;
end
for i=1:Nresponses
    p_mu_var(i,:) = [params([2*i-1 2*i])]; % mean and variance for each process
    q(i) = .95; % asymptotic error for each processes
end
q(Nresponses) = params(2*Nresponses+1); % specify asymptotic error for Nth process

initAE = params(end);

for i=1:Nresponses
    Phi(i,:) = normcdf(RT,p_mu_var(i,1),p_mu_var(i,2)); % probability that A has been planned by RT
end
%PhiB = normcdf(RT,paramsB(1),paramsB(2));

% build Alpha
switch(Nresponses)
    % set up parameters:
    %     p(r) = alpha(.,1)*(1-PhiA)*(1-PhiB) + alpha(.,2)*PhiA*(1-PhiB) +
    %     alpha(.,3)*(1-PhiA)*PhiB + alpha(.,4)*PhiA*PhiB

    case 1
        Alpha(1,:) = [.25 q(1)]; % [p(r=A|!A) p(r=A|A)]
        Alpha(2,:) = [.75 (1-q(1))]; % [p(r=B|!A) p(r=B|A)]
        %Alpha(3,:) = [.5-initAE (1-qA)/3 (1-qB)/3 (1-qB)/3]; % other responses
        %Alpha(4,:) = [initAE qA initAE qA]; % mapping A, no-conflict
        %Alpha(5,:) = [initAE initAE qB qB]; % mapping B, no-conflict
        
        PhiAll = [1-Phi(1,:); Phi(1,:)];
        
    case 2
        if(incongruent)
            Alpha(1,:) = [.25 q(1) (1-q(2))/3 (1-q(2))/3]; % [p(r=A|!A!B) p(r=A|A!B) p(r=A|!AB) p(r=A|AB)]
            Alpha(2,:) = [.25 (1-q(1))/3 q(2) q(2)]; % [p(r=B|!A!B) p(r=B|A!B) p(r=B|!AB) p(r=B|AB)]
            Alpha(3,:) = [.5 2*(1-q(1))/3 2*(1-q(2))/3 2*(1-q(2))/3]; % [p(r=C|!A!B) p(r=C|A!B) p(r=C|!AB) p(r=C|AB)]
            Alpha(4,:) = [initAE q(1) q(1) q(1)]; % p(r=A), no-conflict
            Alpha(5,:) = [initAE initAE q(2) q(2)]; % p(r=B), no-conflict
            
            PhiAll = [(1-Phi(1,:)).*(1-Phi(2,:)); Phi(1,:).*(1-Phi(2,:)); (1-Phi(1,:)).*Phi(2,:); Phi(1,:).*Phi(2,:)];
        
        else
            Alpha(1,:) = [.25 q(1) .25 .25]; % [p(r=A|!A!B) p(r=A|A!B) p(r=A|!AB) p(r=A|AB)]
            Alpha(2,:) = [.25 .25 q(2) q(2)]; % [p(r=B|!A!B) p(r=B|A!B) p(r=B|!AB) p(r=B|AB)]
            Alpha(3,:) = [.25 .25 .25 .25]; % [p(r=C|!A!B) p(r=C|A!B) p(r=C|!AB) p(r=C|AB)]
            Alpha(4,:) = [initAE q(1) q(1) q(1)]; % p(r=A), no-conflict
            Alpha(5,:) = [initAE initAE q(2) q(2)]; % p(r=B), no-conflict
            
            PhiAll = [(1-Phi(1,:)).*(1-Phi(2,:)); Phi(1,:).*(1-Phi(2,:)); (1-Phi(1,:)).*Phi(2,:); Phi(1,:).*Phi(2,:)];
        end
        
    otherwise disp('No such case - 1 or 2')
end
        
%for i=1:5
%    presponse(i,:) = alpha(i,1)*(1-PhiA).*(1-PhiB) + alpha(i,2)*PhiA.*(1-PhiB) + alpha(i,3)*(1-PhiA).*PhiB + alpha(i,4)*PhiA.*PhiB;
%end


%Phi = [(1-PhiA).*(1-PhiB); PhiA.*(1-PhiB); (1-PhiA).*PhiB; PhiA.*PhiB];
presponse = Alpha*PhiAll;