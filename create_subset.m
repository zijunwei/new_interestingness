% create a list of videos (150) for subject test


%%
% current set fdm's width to be 15, but the exact value has to be
% re-computed




AllIOs={VideoEntropy.entropy};

MaxIOs=cellfun(@(x)max(x), AllIOs,'uniformoutput',false);
MaxIOs=cell2mat(MaxIOs);


MinIOs=cellfun(@(x)min(x), AllIOs,'uniformoutput',false);
MinIOs=cell2mat(MinIOs);

Diffs=(MaxIOs-MinIOs);

[s_Diffs,sortedIdx]=sort(Diffs,'descend');


selectedIdx=sortedIdx(1:150);

selectedVideoNames={VideoEntropy(selectedIdx).videoname};