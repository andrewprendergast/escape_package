% looks at each parameter within experiment

for i = 1:nExp
    expIdx{i,:} = find([escapes.expNum]==i);
end

for j = 1:nAnalyses
    for i = 1:nExp
        [expmeans{j,i}, experrors{j,i}] = grpstats([escapes(expIdx{i}).(incAnalyses{j})], [escapes(expIdx{i}).genotype], {'mean', 'sem'});
    end
end

fExp = figure();
set(fExp, 'Position', [1 1200 1200 300]);

cmap = colormap(hsv(nExp));

for j = 1:nAnalyses
    subplot(1,nAnalyses,j)
    title((incAnalyses{j}))
    hold on
    for i = 1:nExp
        errorbar(expmeans{j,i}, experrors{j,i}, 'Color', cmap(i,:))
    end
end

fExp2 = figure();
set(fExp2, 'Position', [1 1200 1600 1200]);

% clever struct sorting method, here showing all escapes grouped two ways

for i = 1:nAnalyses
    subplot(2,nAnalyses,i)
    [paramValues sortIndex] = sort([escapes.expNum]);
    gscatter([1:nFiles], [escapes(sortIndex).(incAnalyses{i})], paramValues, hsv(nExp), '.', 10, 'doleg')
    title(incAnalyses{i})
    
    subplot(2,nAnalyses,nAnalyses+i)
    [paramValues sortIndex] = sort([escapes.genotype]);
    gscatter([1:nFiles], [escapes(sortIndex).(incAnalyses{i})], paramValues, hsv(3), '.', 10, 'doleg')
    title(incAnalyses{i})
end