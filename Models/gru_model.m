function gru_model(XTrain,YTrain,epochs,MiniBatchSize)

layers = [ ...
    sequenceInputLayer(2)
    gruLayer(120,'OutputMode','sequence')
    dropoutLayer(0.2)
    gruLayer(100,'OutputMode','last')
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

grunet = trainNetwork(XTrain,YTrain,layers,options);
pred = classify(grunet,XTest);

Accuracy = sum(pred == YTest)/numel(YTest)*100

figure
confusionchart(YTest,pred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart');
end