function actual_labels = fetchGroundTruth(noOfFrames,noOfNames)
fileId = fopen('Data/annotation.txt');
frame_ids = load('Data/pics.txt');

% Format: <name 1>#<keyframe nbr 2>#<animal 3>#<x 4>#<y 5>#<width
% 6>#<height 7>#<visibility 8>
annotations = textscan(fileId,'%s %d %s %d %d %d %d %s', 'Delimiter','#');
fclose(fileId);
gt_frames = annotations{2};
animals = annotations{3};

% Convert animal strings to numeric labels
run animalnames
animalLabel = zeros(1,length(animals));
for i = 1:length(animals)
    animalLabel(i) = find(ismember(strnames,animals(i)));
end
   
% Make a binary matrix indicating presence of animal for each frame
actual_labels=zeros(noOfFrames,noOfNames);
for i = 1:min([length(frame_ids),noOfFrames])
    indices = find(gt_frames==frame_ids(i));
    if ~isempty(indices)
        for j = 1:length(indices)
           actual_labels(i,animalLabel(indices(j))) = 1; 
        end
    end
end

