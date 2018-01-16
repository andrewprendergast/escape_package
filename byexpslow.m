% looks at each parameter within experiment

for i = 1:nExp
    expIdx{i,:} = find([sswim.expNum]==i);
end

for j = 1:nAnalyses
    for i = 1:nExp
        [expmeans{j,i}, experrors{j,i}] = grpstats([sswim(expIdx{i}).(incAnalyses{j})], [sswim(expIdx{i}).geno], {'mean', 'sem'});
    end
end

fExp = figure();
set(fExp, 'Position', [100 100 1200 300]);

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
set(fExp2, 'Position', [1 1 1600 1200]);

% clever struct sorting method, here showing all sswim grouped two ways

for i = 1:nAnalyses
    subplot(2,nAnalyses,i)
    [paramValues sortIndex] = sort([sswim.expNum]);
    gscatter([1:nFiles], [sswim(sortIndex).(incAnalyses{i})], paramValues, hsv(nExp), '.', 10, 'doleg')
    title(incAnalyses{i})
    
    subplot(2,nAnalyses,nAnalyses+i)
    [paramValues sortIndex] = sort([sswim.geno]);
    gscatter([1:nFiles], [sswim(sortIndex).(incAnalyses{i})], paramValues, hsv(3), '.', 10, 'doleg')
    title(incAnalyses{i})
end