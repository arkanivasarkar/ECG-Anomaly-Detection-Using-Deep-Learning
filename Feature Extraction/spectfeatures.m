function feat = spectfeatures(ecg,count,fs)

ifq = instfreq(ecg,fs); #instantenous freq
ifq = (ifq)';

se = pentropy(ecg,fs); #spect entropy
se = (se)';

switch count
    case 1
        feat = ifq;
    case 2
        feat = se;
end
end


