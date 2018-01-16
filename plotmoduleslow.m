
%% establish plotting set
sswim=sswimdata([sswimdata.error]==0 & [sswimdata.cat]==2 ); %
maskEmptyId = arrayfun(  @(sswim)isempty(sswim.IBI),  sswim  );
[sswim(maskEmptyId).IBI] = deal(nan);

incAnalyses = {
    'duration',...
    'distance',...
    'speed',...
    'nBends',...
    'TBF',...
    'hDirect',...
    'IBI'...
    };

nAnalyses = length(incAnalyses);

% change this to change whether we average within larvae or not

doAverage = 1;

% begin plotting

if doAverage == 0; % no averaging

  
    % plot all escape latencies as per second histogram

%     latHist = figure();
%     hist([sswim.latency], cutoff-2)

    % scatter all points by experiment for each parameter

    fPoints = figure();
    set(fPoints, 'Position', [1 1 1200 1200]);

    for i = 1:nAnalyses

        s(i) = subplot(1,nAnalyses,i);
%         gscatter([sswim.geno], [sswim.(incAnalyses{i})], expNum)
        scatter([sswim.geno], [sswim.(incAnalyses{i})], 30, '.')
        title(incAnalyses{i})
        hold on
        
        [indMeans{i}, indErr{i}] = grpstats([sswim.(incAnalyses{i})], [sswim.geno], {'mean', 'sem'});
        groups = unique([sswim.geno]);
        groups = groups(~isnan(groups));

        bins = unique([sswim.geno]);

        xlim([min(bins)-1, max(bins)+1])
        
        ax = gca;
        set(ax, 'XTickLabel', {'', 'CTL', 'BoTx', '', ''});
        
        jitter
        
        errorbar(groups, indMeans{i}, indErr{i}, 'rx', 'LineWidth', 1);
        
    end

    % statistics

    for i = 1:nAnalyses

        % anova

        [p(i), table{i}, stats{i}] = anovan([sswim.(incAnalyses{i})], {[sswim.geno]}, 'model', 'interaction', 'varnames', {'Genotype'}, 'display', 'off');

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

        perLarva{i,1} = grpstats([sswim.(incAnalyses{i})], [sswim.fishID], {'mean'});
        perLarva{i,2} = grpstats([sswim.geno], [sswim.fishID]);
        perLarva{i,3} = grpstats([sswim.expNum], [sswim.fishID]);

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
                
        groups = unique([sswim.geno]);
        groups = groups(~isnan(groups));

        bins = unique([sswim.geno]);

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