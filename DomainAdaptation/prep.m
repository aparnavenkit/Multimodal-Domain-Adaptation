sub_file = 'Data/subs.txt';

fidb = fopen(sub_file);
data = textscan(fidb,'%s\t%s\t%s\t%s','Delimiter','\t');
subs.start = data{1,1};
subs.end = data{1,2};
subs.entStem = data{1,3};
subs.text = data{1,4};

extFeatures = load('Data/ExternalBinarized.txt'); 
intFeatures = load('Data/InternalBinarized.txt'); 
frame_ids = load('Data/pics.txt');

run animalnames
extFeatures(:,129) = extFeatures(:,129)+1;

% Link Frames and Subs -- Baseline - text only
noOfNames = 19; 
noOfFrames = 401; %length(frame_pics)
noOfFeatures = size(intFeatures,2);
noOfBins = 2;

fileId = fopen('Data/posClosest.txt');
posNames = textscan(fileId,'%d#%s\n');
posNames = posNames{2};

fclose(fileId);
strnamescell=cellstr(strnames);
actual_labels = fetchGroundTruth(noOfFrames,noOfNames);

frame = struct('id',0,'pos','','binnedFeatures',zeros(1,noOfFeatures),...
    'guessed','','real','');
frames = repmat(frame,noOfFrames,1);

for i = 1:noOfFrames %length(frame_pics)
    frames(i).id = frame_ids(i);
    pos = strread(strtrim(char(posNames{i})),'%s','delimiter',',_');
    posInd = zeros(1,length(pos));
    for j = 1:length(pos)
        posInd(j) = findNameInNames(pos{j},strnames);
    end
    frames(i).pos = posInd(find(posInd));
    frames(i).binnedFeatures = intFeatures(i,:);
    frames(i).guessed = frames(i).pos;
    frames(i).real = find(actual_labels(i,:));
    text = [num2str(frames(i).id) ' '];
end
