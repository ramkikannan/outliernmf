function [ W,H,errChange ] = hals( A,Winit,Hinit,k,tolerance,numIterations,beta)
%solves A=WH 
%A = mxn matrix
%W = mxk 
%H = kxn
%k = low rank
%implementation of the algorithm2 from 
%http://www.bsp.brain.riken.jp/publications/2009/Cichocki-Phan-IEICE_col.pdf
W=Winit;
H=Hinit;
prevError=norm(A-W*H,'fro');
currError = prevError+1;
currentIteration=1;
errChange=zeros(1,numIterations);
while (abs(currError-prevError)>tolerance && currentIteration<numIterations)
    %update W;
    AHt=A*H';
    HHt=H*H';
    %to avoid divide by zero error.
    HHtDiag=diag(HHt);
    HHtDiag(HHtDiag==0)=eps;
    for x=1:k 
        Wx = W(:,x) + (AHt(:,x)-W*HHt(:,x))/HHtDiag(x);
        Wx(Wx<eps)=eps;
        W(:,x)=Wx;
    end
    %update H
    WtA=W'*A;
    WtW=W'*W;
    %to avoid divide by zero error.
    WtWDiag=diag(WtW);
    WtWDiag(WtWDiag==0)=eps;
    for x=1:k
        Hx = H(x,:)+(WtA(x,:)-WtW(x,:)*H)/WtWDiag(x);
        Hx=Hx-beta/WtWDiag(x);
        Hx(Hx<eps)=eps;
        H(x,:)=Hx;
    end
    if (currentIteration>1)
        prevError=currError;
    end
    errChange(currentIteration)=prevError;
    currError=norm(A-W*H,'fro');
    currentIteration=currentIteration+1;
end
end
