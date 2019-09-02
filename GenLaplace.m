function[X]=GenLaplace(m,n,mu,b)
% Generating [m \times n] random variables with Laplace(mu, b) distribution 
% Ref:
% See Section Generating random variables according to the Laplace distribution
% in http://en.wikipedia.org/wiki/Laplace_distribution
U=unifrnd(-0.5,0.5,m,n);
X=mu-b*sign(U).*log(1-2*abs(U));