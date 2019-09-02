function [res1,resM1] = consistencyAdjustment(M,mask)
n=size(M,1);
MkpMk=mask+mask';
A1=MkpMk-diag(sum(MkpMk));
B1=sum(M'-M,2);
A1=A1(1:n-1,1:n-1);
B1=B1(1:n-1,1);
u=pcg(-A1,B1);
u=[u;0];
uIt=sparse(1:n,1:n,u);
resM1=M-mask*uIt+uIt*mask;
resMsM=resM1-M;
res1=0.5*sum(sum(resMsM.*resMsM));
end