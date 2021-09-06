function [signalsOut, labelsOut] = segSampl(signalsIn,labelsIn)
%resample all signals to 9000 samples
trgtLength = 9000;
signalsOut = {};
labelsOut = {};

for i = 1:numel(signalsIn)    
    x = signalsIn{i};
    y = labelsIn(i);
        
    x = x(:);
        
    num = floor(length(x)/trgtLength);
    if num == 0
        continue;
    end
       
    x = x(1:num*trgtLength);     
    n = reshape(x,trgtLength,num); 
    y = repmat(y,[num,1]);
    signalsOut = [signalsOut; mat2cell(n.',ones(num,1))]; 
    labelsOut = [labelsOut; cellstr(y)]; 
end

labelsOut = categorical(labelsOut);

end