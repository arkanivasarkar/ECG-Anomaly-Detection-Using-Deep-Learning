function bilstm_model(XTrain,YTrain,XTest,YTest,epochs,MiniBatchSize)
layers = [ ...
    sequenceInputLayer(2)
    bilstmLayer(120,'OutputMode','last')
    dropoutLayer(0.2)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer
    ];

options = trainingOptions('adam', ...
    'MaxEpochs',epochs, ...
    'MiniBatchSize', MiniBatchSize, ...
    'InitialLearnRate', 0.005, ...
    'GradientThreshold', 1, ...
    'ExecutionEnvironment',"auto",...
    'plots','training-progress', ...
    'Verbose',false);

bilstmnet = trainNetwork(XTrain,YTrain,layers,options);

pred = classify(bilstmnet,XTest);

Accuracy = sum(pred == YTest)/numel(YTest)*100

figure
confusionchart(YTest,pred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart');
end
