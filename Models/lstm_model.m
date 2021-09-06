function lstm_model(XTrain,YTrain,epochs,MiniBatchSize)

layers = [ ...
    sequenceInputLayer(3)
    lstmLayer(120,'OutputMode','sequence')
    dropoutLayer(0.2)
    lstmLayer(100,'OutputMode','last')
    dropoutLayer(0.2)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',epochs, ...
    'MiniBatchSize', MiniBatchSize, ...
    'InitialLearnRate', 0.005, ...
    'GradientThreshold', 1, ...
    'ExecutionEnvironment',"auto",...
    'plots','training-progress', ...
    'Verbose',false);

lstmnet = trainNetwork(XTrain,YTrain,layers,options);
pred = classify(lstmnet,XTest);

Accuracy = sum(pred == YTest)/numel(YTest)*100

figure
confusionchart(YTest,pred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart');
end