animal_name = strnamescell;
for f = 1:length(frames)
    %text = [num2str(frames(f).id) 
    realNames=[];
    for r = 1:length(frames(f).real)
       % realNames = [realNames ', ' animal_name{frames(f).real(r)}];
        realNames = [realNames ', ' strnamescell{frames(f).real(r)}];
    end
    realNames = realNames(3:end);
    guessedNames = [];
    guessed = frames(f).guessed(find(frames(f).guessed)); % Added on 17 nov16
    for g = 1:length(guessed)
    %for g = 1:length(frames(f).guessed)
        %guessedNames = [guessedNames ', ' animal_name{frames(f).guessed(g)}] ;
        guessedNames = [guessedNames ', ' animal_name{guessed(g)}] ; % Added on 17 nov 16
    end
    guessedNames = guessedNames(3:end);
    text = sprintf('Frame:\t%s\tReal:\t%s\tGuessed names:\t%s',num2str(frames(f).id),realNames,guessedNames);
    disp(text)
end