function [s_relevantGuesses,s_relevant,s_guesses] = evaluateAlignmentRaw(frames,noOfNames,actual_labels)
% This function prints the actual number of correct guesses instead of
% percentages
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

s_relevantGuesses = sum(relevantGuesses);
s_relevant = sum(relevant);
s_guesses = sum(guesses);

