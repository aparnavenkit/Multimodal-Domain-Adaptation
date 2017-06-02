function pos = findNameInNames(posName,strnames)
pos = 0;
for i = 1:length(strnames)
    if findstr(strnames(i,:),posName)
        pos = i;
    end
end