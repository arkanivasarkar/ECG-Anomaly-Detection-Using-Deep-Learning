% 6-level decomposition using db4 wavelet
function OP = waveletdecomposition(signal,count)

% Defining wavelet's name and level of decomposition
waveletName='db4';
level=5;

% 1-D wavelet decomposition
[c,l]=wavedec(signal,level,waveletName);

%wavelet coefficients
D1 = wrcoef('d',c,l,waveletName,1);
D2 = wrcoef('d',c,l,waveletName,2);
D3 = wrcoef('d',c,l,waveletName,3);
D4 = wrcoef('d',c,l,waveletName,4);
D5 = wrcoef('d',c,l,waveletName,5);
A5 = wrcoef('a',c,l,waveletName,5);



switch count
    case 1
        OP = D1;
    case 2
        OP = D2;
    case 3
        OP = D3;
    case 4
        OP = D4;
    case 5
        OP = D5;
    case 6
        OP = A5;
end    
end



    
