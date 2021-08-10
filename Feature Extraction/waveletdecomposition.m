function OP = waveletdecomposition(signal,count)

#Defining wavelet's name and level of decomposition
waveletName='db4';
level=5;

% Multilevel 1-D wavelet decomposition
[c,l]=wavedec(signal,level,waveletName);

k=1;
n=45;
m=200;


D1 = wrcoef('d',c,l,waveletName,1);
% for i=1:m
%     D11(i)=mean(D1(k:k+n-1));
%     k=k+n;
% end
D2 = wrcoef('d',c,l,waveletName,2);
D3 = wrcoef('d',c,l,waveletName,3);

D4 = wrcoef('d',c,l,waveletName,4);

D5 = wrcoef('d',c,l,waveletName,5);

A5 = wrcoef('a',c,l,waveletName,5);
for i=1:m
    D11(i)=mean(D1(k:k+n-1));
    D21(i)=mean(D2(k:k+n-1));
    D31(i)=mean(D3(k:k+n-1));
    D41(i)=mean(D4(k:k+n-1));
    D51(i)=mean(D5(k:k+n-1));
    A51(i)=mean(A5(k:k+n-1));
    k=k+n;
end

switch count
    case 1
        OP = D11;
    case 2
        OP = D21;
    case 3
        OP = D31;
    case 4
        OP = D41;
    case 5
        OP = D51;
    case 6
        OP = A51;
end
    
end



    
