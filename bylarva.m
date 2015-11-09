% looks at each parameter per larva

index = unique([escapes.larvaNew]);
nLarvae = length(index);

for i = 1:nLarvae
    larvaIdx{i,:} = find([escapes.larvaNew]==index(i));
end

for j = 1:nAnalyses
    for i = 1:nLarvae
        [larvalmeans{j,i}] = nanmean([escapes(larvaIdx{i}).(incAnalyses{j})]);
        [larvalerrors{j,i}] = nanstd([escapes(larvaIdx{i}).(incAnalyses{j})]);
    end
end

for i = 1:nLarvae
    simpleGenotype(i) = nanmean([escapes(find([escapes.larvaNew]==index(i))).genotype]);
    simpleExperiment(i) = nanmean([escapes(find([escapes.larvaNew]==index(i))).expNum]);
end

for j = 1:nAnalyses
    fLarva(j) = figure();
    set(fLarva(j), 'Position', [1 1200 1200 1200]);
    errorbar(index,[larvalmeans{j,:}],[larvalerrors{j,:}], 'o')
% 	gscatter([escapes.larvaNew], [escapes.(incAnalyses{j})], [escapes.larvaNew], hsv(nLarvae), '.', 10, 'doleg')
    xlim([0, nLarvae])
    title((incAnalyses{j}))
end