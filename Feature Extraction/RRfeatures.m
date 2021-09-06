function OP1 = RRfeatures(ecg,count)
w=50/(250/2);
bw=w;

% notch filter 
[num,den]=iirnotch(w,bw);
ecg_notch = filter(num,den,ecg);

% Wavelet decomposition
[e,f]=wavedec(ecg_notch,10,'db6');
g=wrcoef('a',e,f,'db6',8);

ecg_wave=ecg_notch-g; 

ecg_smooth=smooth(ecg_wave); % using average filter to increase the performance of peak detection

N1=length(ecg_smooth);

hh=ecg_smooth;
j=[];
time=0;

%thresold setting 
th=0.45*max(hh);

for i=2:N1-1
    if((hh(i)>hh(i+1))&&(hh(i)>hh(i-1))&&(hh(i)>th))
        j(i)=hh(i);
        time(i)=[i-1]/250;
        
    end
end

j(j==0)=[];               
time(time==0)=[];     
m=(time)';               
k=length(m);

rr2=m(2:k);

rr1=m(1:k-1);


%RR intervals
rr3=rr2-rr1;
rr3=rr3';

if length(rr3)>=5
    rr=rr3(1:5);
    
elseif length(rr3)==0
    rr=[0,0,0,0,0];
    
    
elseif length(rr3)<5
    rr = rr3(1:length(rr3));
    n = 5 - length(rr3);
    rr(end+n)=0;
    
end

%heart rate variablity

hr=60./rr3;

if length(hr)>=5
    hrv=hr(1:5);
    
elseif length(hr)==0
    hrv=[0,0,0,0,0];
    
elseif length(hr)<5
    hrv = hr(1:length(hr));
    n = 5 - length(hr);
    hrv(end+n)=0;
    
end


ahr=mean(hr);       % mean heart rate;

%mean of RR interval
AVRR = mean(rr3);

%SD of RR interval
SDNN = std(rr3);

%rms RR interval
sq = diff(rr3).^2;
rms = sqrt(mean(sq));

%NN50- pair of RR more that 50
NN50 = sum(abs(diff(rr3))>.05);


if length(rr3)==0
    rrvec = [0,0,0,0,0];
else
    rrvec = [ahr, AVRR, SDNN, rms, NN50];
end




switch count
    case 1
        OP1 = rr;
    case 2
        OP1 = hrv;
    case 3
        OP3 = rrvec;
end

end


