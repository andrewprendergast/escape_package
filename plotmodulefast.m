
%% establish plotting set

incAnalyses = {
    'duration',...
    'distance',...
    'speed',...
    'nBends',...
    'tbf'...
    };

nAnalyses = length(incAnalyses);

% change this to change whether we average within larvae or not

doAverage = 0;

% begin plotting

if doAverage == 0; % no averaging

    % plot all escape latencies as per second histogram

%     latHist = figure();
%     hist([escapes.latency], cutoff-2)

    % scatter all points by experiment for each parameter

    fPoints = figure();
    set(fPoints, 'Position', [1 1 1200 1200]);

    for i = 1:nAnalyses

        s(i) = subplot(1,nAnalyses,i);
%         gscatter([escapes.genotype], [escapes.(incAnalyses{i})], expNum)
        scatter([escapes.genotype], [escapes.(incAnalyses{i})], 30, '.')
        title(incAnalyses{i})
        hold on
        
        [indMeans{i}, indErr{i}] = grpstats([escapes.(incAnalyses{i})], [escapes.genotype], {'mean', 'sem'});
        groups = unique([escapes.genotype]);
        groups = groups(~isnan(groups));

        bins = unique([escapes.genotype]);

        xlim([min(bins)-1, max(bins)+1])
        
        ax = gca;
        set(ax, 'XTickLabel', {'', 'CTL', 'BoTx', '', ''});
        
        jitter
        
        errorbar(groups, indMeans{i}, indErr{i}, 'rx', 'LineWidth', 1);
        
    end

    % statistics

    for i = 1:nAnalyses

        % anova

        [p(i), table{i}, stats{i}] = anovan([escapes.(incAnalyses{i})], {[escapes.genotype]}, 'model', 'interaction', 'varnames', {'Genotype'}, 'display', 'off');

        % post hoc tests for anything less than 0.10

        if p(i) < 0.10
            figure()
            posthoc{i} = multcompare(stats{i}, 'dim', [1], 'ctype', 'scheffe');
            title(incAnalyses{i});
        else
        end

    end

elseif doAverage == 1; % averaging within larvae
    
    % average within larvae
    
    for i = 1:nAnalyses

        perLarva{i,1} = grpstats([escapes.(incAnalyses{i})], [escapes.larvaNew], {'mean'});
        perLarva{i,2} = grpstats([escapes.genotype], [escapes.larvaNew]);
        perLarva{i,3} = grpstats([escapes.expNum], [escapes.larvaNew]);

    end
    
    % plot
    
    fMeans = figure();
    set(fMeans, 'Position', [1 1 1200 1200]);

    for i = 1:nAnalyses

        s(i) = subplot(1,nAnalyses,i);
%         gscatter(perLarva{i,2}, perLarva{i,1}, perLarva{i,3})
        scatter(perLarva{i,2}, perLarva{i,1}, 50, '.')
        title(strcat(incAnalyses{i}, ' grouped'))
        hold on
                
        [grpMeans{i}, grpErr{i}] = grpstats(perLarva{i,1}, perLarva{i,2}, {'mean', 'sem'});
                
        groups = unique([escapes.genotype]);
        groups = groups(~isnan(groups));

        bins = unique([escapes.genotype]);

        xlim([min(bins)-1, max(bins)+1])
        
        ax = gca;
        set(ax, 'XTickLabel', {'', 'CTL', 'BoTx', '', ''});

        jitter
        
        errorbar(groups, grpMeans{i}, grpErr{i}, 'rx', 'LineWidth', 1);
   
    end
    
    % statistics
    
    for i = 1:nAnalyses

        % anova

        [p(i), table{i}, stats{i}] = anovan(perLarva{i,1}, perLarva{i,2}, 'model', 'interaction', 'varnames', {'Genotype'}, 'display', 'off');

        % post hoc tests for anything less than 0.10

        if p(i) < 0.10
            figure()
            posthoc{i} = multcompare(stats{i}, 'dim', [1], 'ctype', 'scheffe');
            title(incAnalyses{i});
        else
        end

    end
    
else
    
end