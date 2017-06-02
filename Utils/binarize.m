function binTrain = binarize(varargin)
training = varargin{1};
binTrain = zeros(size(training));

if nargin >1
    threshold = varargin{2};
else
    threshold = 0.5
end
for i = 1:size(training,2) % For each feature
    %avg(i) = mean(training(:,i));
    %mid(i) = mean([max(training(:,i)),min(training(:,i))])
    thresh(i) = max(training(:,i))*threshold
    binTrainVec = zeros(size(training,1),1);
    binTrainVec(training(:,i)>=thresh(i))=1;
    binTrain(:,i) = binTrainVec;
end