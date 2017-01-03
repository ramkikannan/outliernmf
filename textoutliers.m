function [ Z,W,H,errChange ] = textoutliers( A,k,alpha,beta )
%this function solves the equation
% A = ||A-Z-WH||_F^2 + alpha ||Z||_2,1 + beta ||H||_1
% A is a sparse matrix of size mxn
% the Z matrix is the outlier matrix.
[m,n]=size(A);
%numIterations is used for convergence of W,H
numIterationsWH = 10;
numIterations = 10;
%first fix W,H and solve Z.
W = rand(m,k);
H = rand(k,n);
D = A-W*H;
currentIteration=1;
Z = zeros(m,n);
%prevErr =  norm(D-Z,'fro')+alpha*sum(sqrt(sum(Z.^2)))+beta * norm(H,1);
prevErr = norm(D,'fro') + beta * norm(H,1);
currentErr = prevErr - 1;
errChange=zeros(numIterations,1);
%convergence is when A \approx WH
while(currentIteration < numIterations)
    colnormdi=sqrt(sum(D.^2));
    colnormdi_factor=colnormdi-(alpha);
    colnormdi_factor(colnormdi_factor<0)=0;
    Z=bsxfun(@rdivide,D,colnormdi);
    Z=bsxfun(@times,Z,colnormdi_factor);
    D = A-Z;
    [W,H,~]=hals(D,W,H,k,1e-6,numIterationsWH,beta);
    D = A-W*H;
    if (currentIteration>1)
        prevErr = currentErr;
    end
    errChange(currentIteration)=prevErr;
    currentErr = norm(D-Z,'fro')+alpha*sum(sqrt(sum(Z.^2)))+beta * norm(H,1);
    disp ([currentIteration prevErr norm(D-Z,'fro')/norm(A,'fro')]);
    currentIteration = currentIteration + 1;
end
errChange(currentIteration)=currentErr;
end
