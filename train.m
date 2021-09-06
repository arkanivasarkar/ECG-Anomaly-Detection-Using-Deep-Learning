function train



%% data loading and pre-processing
load('Training_dataset.mat');


% summary(Labels)

% segment samples
[Signals,Labels] = segSampl(Signals,Labels);

% splitting into classes

afibX = Signals(Labels=='A');
afibY = Labels(Labels=='A');
normalX = Signals(Labels=='N');
normalY = Labels(Labels=='N');
OtX = Signals(Labels=='O');
OtY = Labels(Labels=='O');
NsX = Signals(Labels=='~');
NsY = Labels(Labels=='~');



% 80-20 Train-test split
[trainIndA,~,testIndA] = dividerand(717,0.8,0.0,0.2);
[trainIndN,~,testIndN] = dividerand(4929,0.8,0.0,0.2);
[trainIndO,~,testIndO] = dividerand(2597,0.8,0.0,0.2);
[trainIndNs,~,testIndNs] = dividerand(151,0.8,0.0,0.2);



XTrainA = afibX(trainIndA);
YTrainA = afibY(trainIndA);
XTrainN = normalX(trainIndN);
YTrainN = normalY(trainIndN);
XTestA = afibX(testIndA);
YTestA = afibY(testIndA);
XTestN = normalX(testIndN);
YTestN = normalY(testIndN);
XTrainO = OtX(trainIndO);
YTrainO = OtY(trainIndO);
XTestO = OtX(testIndO);
YTestO = OtY(testIndO);
XTrainNs = NsX(trainIndNs);
YTrainNs = NsY(trainIndNs);
XTestNs = NsX(testIndNs);
YTestNs = NsY(testIndNs);



%% data augmentation

XTrain = [repmat(XTrainA(1:560),7,1); repmat(XTrainO(1:1960),2,1); repmat(XTrainNs(1:112),35,1); XTrainN(1:3920)];
YTrain = [repmat(YTrainA(1:560),7,1); repmat(YTrainO(1:1960),2,1); repmat(YTrainNs(1:112),35,1); YTrainN(1:3920)];

XTest = [repmat(XTestA(1:140),7,1); repmat(XTestO(1:490),2,1); repmat(XTestNs(1:28),35,1); XTestN(1:980)];
YTest = [repmat(YTestA(1:140),7,1);repmat(YTestO(1:490),2,1); repmat(YTestNs(1:28),35,1); YTestN(1:980)];



%% feature extraction - wavelet, rr, spectralprop

% wavelet decomposition
count = 1;
wavedecTrain1 = cellfun(@(x)waveletdecomposition(x,count),XTrain,'UniformOutput',false);
wavedecTest1 = cellfun(@(x)waveletdecomposition(x,count),XTest,'UniformOutput',false); 

count = count+1;
wavedecTrain2 = cellfun(@(x)waveletdecomposition(x,count),XTrain,'UniformOutput',false);
wavedecTest2 = cellfun(@(x)waveletdecomposition(x,count),XTest,'UniformOutput',false);

count = count+1;
wavedecTrain3 = cellfun(@(x)waveletdecomposition(x,count),XTrain,'UniformOutput',false);
wavedecTest3 = cellfun(@(x)waveletdecomposition(x,count),XTest,'UniformOutput',false);

count = count+1;
wavedecTrain4 = cellfun(@(x)waveletdecomposition(x,count),XTrain,'UniformOutput',false);
wavedecTest4 = cellfun(@(x)waveletdecomposition(x,count),XTest,'UniformOutput',false);

count = count+1;
wavedecTrain5 = cellfun(@(x)waveletdecomposition(x,count),XTrain,'UniformOutput',false);
wavedecTest5 = cellfun(@(x)waveletdecomposition(x,count),XTest,'UniformOutput',false);

count = count+1;
wavedecTrain6 = cellfun(@(x)waveletdecomposition(x,count),XTrain,'UniformOutput',false);
wavedecTest6 = cellfun(@(x)waveletdecomposition(x,count),XTest,'UniformOutput',false);


%RR interval features
count = 1;
RRTrain1 = cellfun(@(x)RRfeatures(x,count),XTrain,'UniformOutput',false);
RRTest1 = cellfun(@(x)RRfeatures(x,count),XTest,'UniformOutput',false);

count = count+1;
RRTrain2 = cellfun(@(x)RRfeatures(x,count),XTrain,'UniformOutput',false);
RRTest2 = cellfun(@(x)RRfeatures(x,count),XTest,'UniformOutput',false);

count = count+1;
RRTrain3 = cellfun(@(x)RRfeatures(x,count),XTrain,'UniformOutput',false);
RRTest3 = cellfun(@(x)RRfeatures(x,count),XTest,'UniformOutput',false);


%spectral features

count = 1;
spectTrain1 = cellfun(@(x)spectfeatures(x,count),XTrain,'UniformOutput',false);
spectTest1 = cellfun(@(x)spectfeatures(x,count),XTest,'UniformOutput',false);

count = count+1;
spectTrain2 = cellfun(@(x)spectfeatures(x,count),XTrain,'UniformOutput',false);
spectTest2 = cellfun(@(x)spectfeatures(x,count),XTest,'UniformOutput',false);

%concatenate features
XTrain2 = cellfun(@(x,y,z,w,a,b,c,d,m,n,k)[x;y;z;w;a;b;c;d;m;n;k],wavedecTrain1,wavedecTrain2,wavedecTrain3,wavedecTrain4,wavedecTrain5,wavedecTrain6,RRTrain1,RRTrain2,RRTrain3,spectTrain1,spectTrain2,'UniformOutput',false);
XTest2 = cellfun(@(x,y,z,w,a,b,c,d,m,n,k)[x;y;z;w;a;b;c;d;m;n;k],wavedecTest1,wavedecTest2,wavedecTest3,wavedecTest4,wavedecTest5,wavedecTest6,RRTest1,RRTest2,RRTest3,spectTest1,spectTest2,'UniformOutput',false);


%% standardization

XTrain_SD = cellfun(@(x)normalize(x,'zscore'),XTrain2,'UniformOutput',false);
XTest_SD = cellfun(@(x)normalize(x,'zscore'),XTest2,'UniformOutput',false);


%% training and validation of deep learning models

lstm_model(XTrain,YTrain,XTest_SD,YTest,150,128)  %lstm

bilstm_model(XTrain_SD,YTrain,XTest_SD,YTest,200,128)  %bilstm

gru_model(XTrain,YTrain,XTest_SD,YTest,200,128)   %gru




