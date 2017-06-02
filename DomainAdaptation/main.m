clear
clc
usePrior = false;
%% Prep
run prep
frames = frames(1:noOfFrames);
[b_precision,b_recall,b_f1] = evaluateAlignment(frames,noOfNames,actual_labels);

disp('************************************************************')
disp(['Baseline using only text'])
disp(['Precision: ' num2str(b_precision,'%.4f') ', Recall: ' num2str(b_recall,'%.4f') ...
    ', F1: ' num2str(b_f1,'%.4f')])
disp('************************************************************')
%printGuessed

%% Init

pfnMatrix = ones(noOfFeatures,noOfNames,noOfBins);
pfnNotMatrix = ones(noOfFeatures,noOfNames,noOfBins);
nameTotal = zeros(1,noOfNames);
for i = 1:length(extFeatures)
    for j = 1:noOfFeatures
        pfnMatrix(j,extFeatures(i,noOfFeatures+1),extFeatures(i,j)+1) = ...
            pfnMatrix(j,extFeatures(i,noOfFeatures+1),extFeatures(i,j)+1)+1;
        for k = 1:noOfNames
            if k ~= extFeatures(i,noOfFeatures+1)
                pfnNotMatrix(j,k,extFeatures(i,j)+1) = ...
                    pfnNotMatrix(j,k,extFeatures(i,j)+1)+1;
            end
        end
    end
    nameTotal(extFeatures(i,noOfFeatures+1))= ...
        nameTotal(extFeatures(i,noOfFeatures+1))+1;
end

iter = 1;
max_iter=11;
i_precision = zeros(1,max_iter);
i_recall = zeros(1,max_iter);
i_f1 = zeros(1,max_iter);

while iter<=max_iter
%% Estimate likelihoods: E-step
evaluate = true;
useWeight = false;
for i = 1:length(frames)
    frames(i).guessed = [];
    prob = zeros(1,noOfNames);
    probNot = zeros(1,noOfNames);
    count = 0;
    features = frames(i).binnedFeatures;
    for name = 1:noOfNames 
        if name ~=0
            if usePrior
                prob(name) = nameTotal(name)/sum(nameTotal);
            else
                prob(name) = 1;
                probNot(name) = 1;
            end
            f = zeros(1,noOfFeatures);
            fNot = zeros(1,noOfFeatures);
            for j = 1:noOfFeatures
                f(j) = pfnMatrix(j,name,features(j)+1)/sum(pfnMatrix(j,name,:));
                prob(name) = prob(name)*pfnMatrix(j,name,features(j)+1)/ ...
                    sum(pfnMatrix(j,name,:));
                probNot(name) = probNot(name)* ...
                    pfnNotMatrix(j,name,features(j)+1)/sum(pfnNotMatrix(j,name,:));
                fNot(j) = pfnNotMatrix(j,name,features(j)+1)/...
                    sum(pfnNotMatrix(j,name,:));
            end
            if (useWeight)
                if name == noOfNames
                    weightOfPositive = 1;
                else
                weightOfPositive = (sum(nameTotal)-nameTotal(name))/nameTotal(name);
                end
            else
                weightOfPositive = 1;
            end
            frames(i).likelihood(name) = weightOfPositive*prob(name)...
                /(weightOfPositive*prob(name)+probNot(name));

            if (evaluate)
                if (frames(i).likelihood(name) >=0.5) 
                    if(ismember(name,frames(i).pos))
                    count = count+1;
                    frames(i).guessed(count) = name;
                    end
                end
            end
        end     
    end
end
[i_precision(iter),i_recall(iter),i_f1(iter)] = evaluateAlignment(frames,noOfNames,actual_labels);

if iter == 1
    disp(['Models learned on ImageNet, applied as is'])
    disp(['Precision: ' num2str(i_precision(iter),'%.4f') ', Recall: ' ...
        num2str(i_recall(iter),'%.4f') ', F1: ' num2str(i_f1(iter),'%.4f')])
    disp('************************************************************')
elseif iter < max_iter
    disp(['After iteration: ' num2str(iter-1)])
    disp(['Precision: ' num2str(i_precision(iter),'%.4f') ', Recall: ' ...
        num2str(i_recall(iter),'%.4f') ', F1: ' num2str(i_f1(iter),'%.4f')])
else
    disp('************************************************************')
    disp(['Final results: ' num2str(iter)])
    disp(['Precision: ' num2str(i_precision(iter),'%.4f') ', Recall: ' ...
        num2str(i_recall(iter),'%.4f') ', F1: ' num2str(i_f1(iter),'%.4f')])
    disp('************************************************************')
end
%% update pfnMatrix: M-step
useWeight = false;
pfnMatrix = ones(noOfFeatures,noOfNames,noOfBins);
pfnNotMatrix = ones(noOfFeatures,noOfNames,noOfBins);

for i = 1:noOfFeatures
    for j = 1:length(frames)
       for name = 1:noOfNames
          if (useWeight)
            weightOfPositive = (sum(nameTotal)-nameTotal(name))/nameTotal(name);
          else
            weightOfPositive = 1;
          end

          if ismember(name,frames(j).pos)
              pfnMatrix(i,name,frames(j).binnedFeatures(i)+1) = ...
                pfnMatrix(i,name,frames(j).binnedFeatures(i)+1) + ...
                frames(j).likelihood(name)*weightOfPositive;
          else
              pfnNotMatrix(i,name,frames(j).binnedFeatures(i)+1) = ...
                  pfnNotMatrix(i,name,frames(j).binnedFeatures(i)+1) + ...
                  (1-frames(j).likelihood(name));
          end
       end
    end
end
iter=iter+1;
end