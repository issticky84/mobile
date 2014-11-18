function W = Mask_adjac_time (n, nn)
  
% ADJAC Make sparse adjacency matrix based on nearest neigbors in Euclidean space
% 
% W = adjac (DATA, nn)
%
%   DATA is a N x hidim matrix representing N points in R^hidim
%   nn is the number of nearest neighbors
%   for each vertex i, for each vertex j that is among i's nn nearest neighbors
%      there is an entry W(i,j) = W(j,i) with the distance in R^hidim
%      between i and j.
%   W(i,i)=0 isnt stored.
%   Each row has (at least) nn nonzero entries. Not necessarily exactly.
%
%   step is a value that can be modified to optimize this code's
%   running on your machine.  L2_distance is called on a step x N matrix.
%
%   The number of points processed is reported every stepsbetweenreport*step
%    points processed.
%
% Original code by Misha Belkin (misha@cs.uchicago.edu)
% Modified by Dinoj Surendran (dinoj@cs.uchicago.edu), April/May 2004
  
if nargin < 2, nn = 10;end
if nargin < 3, step=128;end
if nargin < 4, stepsbtwnreport=5;end
  
%n=size(DATA,1);
%W=sparse(n,n);
W = zeros(n);

k_2 = nn/2; %nn/2
%vect_weight = horzcat(vect_temp1,vect_temp2);
for i=1:n
    vect = i-k_2:1:i+k_2;
    if i<=k_2  
          W(i,1:k_2+i) = 1;
    else
        for k=1:length(vect);
            if vect(k)>0 & vect(k)<=n
                W(i,vect(k)) = 1;
            end
        end
    end
    W(i,i) = 0;
end



