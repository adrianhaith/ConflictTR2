function [y ycdf] = model_sigmoid(p,t,Ntargs)
% outputs sigmoid generated with parameters t, at times t

ycdf = normcdf(t,p(1),p(2));
y = 1/Ntargs + ycdf*(p(3)-1/Ntargs);