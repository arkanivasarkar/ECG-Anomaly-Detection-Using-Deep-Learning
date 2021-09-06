%%saving data in .mat file

data_folder = uigetdir(); %folder containing the signals
cd (data_folder)

ref = uigetfile(); % signal labels

tb = readtable(ref,'ReadVariableNames',false);
tb.Properties.VariableNames = {'Filename','Label'};

% toDelete = strcmp(tb.Label,'~');
% tb(toDelete,:) = [];


H = height(tb);
for i = 1:H
    fileData = load([tb.Filename{i},'.mat']);
    tb.Signal{i} = fileData.val;
end

Signals = tb.Signal; %signals in cell arrays
Labels = categorical(tb.Label); %labels in categorical array

save Dataset1.mat Signals Labels
disp('done')