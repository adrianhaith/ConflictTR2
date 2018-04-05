% break down triple conflict data by trial type
clear all
load triple_conflict_data

addpath ExtraFns

xplot = [0:.001:1];

phit_spat_all_confl = [];
phit_symb_all_confl = [];
phit_col_all_confl = [];
phit_other_all_confl = [];

phit_congruent = [];

Nsubj = size(d,1);

for s = 1:Nsubj;
c = 4;

i_all_diff = find(d(s,c).spatAng~=d(s,c).symbAng & d(s,c).symbAng~=d(s,c).colAng & d(s,c).colAng~=d(s,c).spatAng & ~isnan(d(s,c).symbAng));
i_congruent = find(d(s,c).spatAng==d(s,c).symbAng & d(s,c).symbAng==d(s,c).colAng);

d(s,c).congruent.phit = sliding_window(d(s,c).RT(i_congruent),d(s,c).hit_spat(i_congruent),xplot,.05);

figure(20+s); clf; hold on
subplot(2,1,1); hold on
%plot(xplot,d(s,c).congruent.phit,'b')

d(s,c).diff.RT = d(s,c).RT(i_all_diff);
d(s,c).diff.hit_spat = d(s,c).hit_spat(i_all_diff);
d(s,c).diff.hit_symb = d(s,c).hit_symb(i_all_diff);
d(s,c).diff.hit_col = d(s,c).hit_col(i_all_diff);

d(s,c).diff.response = 4*ones(1,size(d(s,c).diff.RT,2));
d(s,c).diff.response(d(s,c).diff.hit_spat)=1;
d(s,c).diff.response(d(s,c).diff.hit_symb)=2;
d(s,c).diff.response(d(s,c).diff.hit_col)=3;

d(s,c).diff.phit_spat = sliding_window(d(s,c).RT(i_all_diff),d(s,c).hit_spat(i_all_diff),xplot,.05);
d(s,c).diff.phit_symb = sliding_window(d(s,c).RT(i_all_diff),d(s,c).hit_symb(i_all_diff),xplot,.05);
d(s,c).diff.phit_col = sliding_window(d(s,c).RT(i_all_diff),d(s,c).hit_col(i_all_diff),xplot,.05);
d(s,c).diff.phit_other = 1-d(s,c).diff.phit_spat - d(s,c).diff.phit_symb - d(s,c).diff.phit_col;


plot(xplot,d(s,c).diff.phit_spat,'r')
plot(xplot,d(s,c).diff.phit_symb,'g')
plot(xplot,d(s,c).diff.phit_col,'m')
plot(xplot,d(s,c).diff.phit_other,'c')

xlim([0 .8])

phit_spat_all_confl = [phit_spat_all_confl; d(s,c).diff.phit_spat];
phit_symb_all_confl = [phit_symb_all_confl; d(s,c).diff.phit_symb];
phit_col_all_confl = [phit_col_all_confl; d(s,c).diff.phit_col];
phit_other_all_confl = [phit_other_all_confl; d(s,c).diff.phit_other];

phit_congruent = [phit_congruent; d(s,c).congruent.phit];

end

dAll.phit_spat_all_confl = phit_spat_all_confl;
dAll.phit_symb_all_confl = phit_symb_all_confl;
dAll.phit_col_all_confl = phit_col_all_confl;
dAll.phit_other_all_confl = phit_other_all_confl;
dAll.phit_congruent = phit_congruent;


% phit_spat_all_confl = reshape([d(:,4).phit_spat],1001,Nsubj)';
% phit_symb_all_confl = reshape([d(:,4).phit_symb],1001,Nsubj)';
% phit_col_all_confl = reshape([d(:,4).phit_col],1001,Nsubj)';

dAll.phit_spat_all_bsl = reshape([d(:,1).phit_spat],1001,Nsubj)';
dAll.phit_symb_all_bsl = reshape([d(:,2).phit_symb],1001,Nsubj)';
dAll.phit_col_all_bsl = reshape([d(:,3).phit_col],1001,Nsubj)';


%%
rng = 1:600;
figure(2); clf; hold on
subplot(3,1,1); hold on
plot([0 .6],[.25 .25],'k:')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_spat_all_bsl(:,rng)),seNan(dAll.phit_spat_all_bsl(:,rng)),'k')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_symb_all_bsl(:,rng)),seNan(dAll.phit_symb_all_bsl(:,rng)),'b')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_col_all_bsl(:,rng)),seNan(dAll.phit_col_all_bsl(:,rng)),'m')
axis([0 .6 0 1])

subplot(3,1,2); hold on
plot([0 .6],[.25 .25],'k:')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_spat_all_confl(:,rng)),seNan(dAll.phit_spat_all_confl(:,rng)),'k')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_symb_all_confl(:,rng)),seNan(dAll.phit_symb_all_confl(:,rng)),'b')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_col_all_confl(:,rng)),seNan(dAll.phit_col_all_confl(:,rng)),'m')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_other_all_confl(:,rng)),seNan(dAll.phit_other_all_confl(:,rng)),'c')
%plot(xplot(rng),nanmean(dAll.phit_congruent(:,rng)),'k')
axis([0 .6 0 1])

subplot(3,1,3); hold on
plot([0 .6],[.25 .25],'k:')
shadedErrorBar(xplot(rng),nanmean(dAll.phit_congruent(:,rng)),seNan(dAll.phit_congruent(:,rng)),'m')
axis([0 .6 0 1])

%%
save triple_conflict_data d dAll

