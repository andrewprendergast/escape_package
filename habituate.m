fTrialsAll = figure();
set(fTrialsAll, 'Position', [1 1200 1800 200]);

for i = 1:nAnalyses
    
    [trialMeans{i}, trialErr{i}] = grpstats([escapes.(incAnalyses{i})], [escapes.trial], {'mean', 'sem'});
    
    s(i) = subplot(1, nAnalyses, i);
    hold on
    title(incAnalyses{i})
    set(s(i), 'XTick', [1, 2, 3, 4, 5]);
    xlim([0 6]);
    
    errorbar(trialMeans{i}, trialErr{i});

end

fTrialsGeno = figure()
set(fTrialsGeno, 'Position', [1 1200 1800 200]);
cmap = hsv(nGrps);

for j = 1:nAnalyses
    s(j) = subplot(1, nAnalyses, j);
    for i = 0:nGrps-1
    
    grpIdx = find([escapes.genotype]==i);
    grpTemp = [escapes.(incAnalyses{j})];
    allTrial = [escapes.trial];
    
    grpAnal = grpTemp(grpIdx);
    grpTrial = allTrial(grpIdx);
    
    [trialMeansGrp{i+1,j} trialErrGrp{i+1,j}] = grpstats(grpAnal, grpTrial, {'mean', 'sem'});
    title(incAnalyses{j})

    errorbar(trialMeansGrp{i+1,j}, trialErrGrp{i+1,j}, 'Color', cmap(i+1,:))
    hold on
    end
    xlim([0 6]);
    set(s(j), 'XTick', [1, 2, 3, 4, 5]);
end