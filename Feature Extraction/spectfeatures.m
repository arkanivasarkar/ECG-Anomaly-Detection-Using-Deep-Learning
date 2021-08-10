function pout = spectfeatures(ecg,count,fs)

ifq = instfreq(ecg,fs);
ifq = (ifq)';
ifq=repmat(ifq,1,36);
ifq=ifq(1:9000);

se = pentropy(ecg,fs);
se = (se)';
se=repmat(se,1,36);
se=se(1:9000);

switch count
    case 1
        pout = ifq;
    case 2
        pout = se;
end
end


