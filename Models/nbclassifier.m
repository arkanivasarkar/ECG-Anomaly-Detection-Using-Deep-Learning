function nbclassifier(XTrain, YTrain)
clf = fitcnb(XTrain, YTrain);
pred = clf.predict;

Accuracy = sum(pred == YTest)/numel(YTest)*100

figure
confusionchart(YTest,pred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart');
end