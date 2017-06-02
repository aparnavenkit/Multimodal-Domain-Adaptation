function [precision,recall,f1] = evaluateAlignment(frames,noOfNames,actual_labels)
guessedLabels = zeros(length(frames),noOfNames);
for i = 1:length(frames)
    for j = 1:length(frames(i).guessed)
        if frames(i).guessed(j) ~= 0
            guessedLabels(i,frames(i).guessed(j)) = 1;
        end
    end
end


%% Find precision, recall n F1
for i = 1:noOfNames %size(guessedLabels,2) % go over each column, this gives class-wise numbers
    guesses(i) = length(find(guessedLabels(:,i) == 1));
    relevant(i) = length(find(actual_labels(:,i) == 1));
    relevantGuesses(i) = length(intersect(find(guessedLabels(:,i) == 1),find(guessedLabels(:,i) == actual_labels(:,i))));
end

precision = sum(relevantGuesses)/sum(guesses);
recall = sum(relevantGuesses)/sum(relevant);
f1 = 2*precision*recall/(precision+recall);

% Number of labels predicted for each frame
% for i = 1:length(frames)
%     no(i)=length(find(guessedLabels(i,:)==1));
% end
% find(no>1) 
% % Empty matrix: 1-by-0
% find(no==1) 
% % 255
% find(no==0)