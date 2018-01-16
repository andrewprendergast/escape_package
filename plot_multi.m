function [h1, h2, counts] = plot_multi(combined, time)

% test for presence of time variable

[m,n] = size(combined);

if n == 6;
    hasTime = 1;
else
    hasTime = 0;
end

% no time variable

if hasTime == 0;

    condSet = unique(combined(:,5));
    nGrps = length(unique(combined(:,5)));

    dorsal = combined((combined(:,2)==1),:);
    ventral = combined((combined(:,2)==2),:);

    [dMean, dErr] = grpstats(dorsal(:,3)./time, dorsal(:,5), {'mean', 'sem'});
    [vMean, vErr] = grpstats(ventral(:,3)./time, ventral(:,5), {'mean', 'sem'});


    h1 = figure();
    set(h1, 'Position', [1 1200 1200 600]);
    
    scatter(dorsal(:,5), dorsal(:,3)./time, 100, 'k', '.')
    hold on
    xlim([0,condSet(end)+1]);
    jitter
    title('dorsal')
    errorbar([condSet], dMean, dErr, 'LineStyle', 'none', 'LineWidth', 2, 'Marker', '+');

    h2 = figure();
    set(h2, 'Position', [1 1200 1200 600]);    
    
    scatter(ventral(:,5), ventral(:,3)./time, 100, 'k', '.')
    hold on
    xlim([0,condSet(end)+1]);
    jitter
    title('ventral')
    errorbar([condSet], vMean, vErr, 'LineStyle', 'none', 'LineWidth', 2, 'Marker', '+');

% yes time variable

elseif hasTime == 1;
    
    nCond = length(unique(combined(:,5)));
    nTimes = length(unique(combined(:,6)));
    nGrps = nCond * nTimes;
    
    dorsal = combined((combined(:,2)==1),:);
    ventral = combined((combined(:,2)==2),:);
    
    % develop averages for each time point
    
    dStatMat = zeros(nTimes, 2, nCond);
    
    for i = 1:nCond;
        temp = dorsal(dorsal(:,5)==i,:);
        [x, y] = grpstats(temp(:,3)./time, temp(:,6), {'mean', 'sem'});
        dStatMat(:,1,i) = x;
        dStatMat(:,2,i) = y;
        clear x
        clear y
        clear temp
    end
    
    vStatMat = zeros(nTimes, 2, nCond);
    
    for i = 1:nCond;
        temp = ventral(ventral(:,5)==i,:);
        [x, y] = grpstats(temp(:,3)./time, temp(:,6), {'mean', 'sem'});
        vStatMat(:,1,i) = x;
        vStatMat(:,2,i) = y;
        clear x
        clear y
        clear temp
    end
        
    
    % set horizontal offset for column scatter
    
    offset = 0.5/(nCond-1);
    offsetMat = [-0.25:offset:0.25];
    
    colorMat = hsv(nCond);
    dColorMat = colorMat./2;
    
    h1 = figure();
    set(h1, 'Position', [1 1200 1200 600]);
    
    for i = 1:nCond;
        
    temp = dorsal(dorsal(:,5)==i,:);
    
    scatter(temp(:,6)+offsetMat(i), temp(:,3)./time, 100, colorMat(i,:), '.')
    hold on
    xlim([min(combined(:,6))-1,max(combined(:,6))+1]);
    set(gca, 'Xtick', (unique(dorsal(:,6))'));
    jitter
    errorbar(unique(temp(:,6)+offsetMat(i)), dStatMat(:,1,i)', dStatMat(:,2,i)', 'Color', dColorMat(i,:));
    clear temp
    title('dorsal cells')
    end
    
    h2 = figure();
    set(h2, 'Position', [1 1200 1200 600]);
    
    for i = 1:nCond;
        
    temp = ventral(ventral(:,5)==i,:);
    
    scatter(temp(:,6)+offsetMat(i), temp(:,3)./time, 100, colorMat(i,:), '.')
    hold on
    xlim([min(combined(:,6))-1,max(combined(:,6))+1]);
    set(gca, 'Xtick', (unique(ventral(:,6))'));
    jitter
    errorbar(unique(temp(:,6)+offsetMat(i)), vStatMat(:,1,i)', vStatMat(:,2,i)', 'Color', dColorMat(i,:));
    clear temp
    title('ventral cells')
    end

end

% show n per group

if hasTime == 0;

    [peaks, locs] = findpeaks(combined(:,1));
    categories = unique(combined(:,5));
    index = combined(locs,5);

    index(end+1,:) = index(end,:); % corrects error due to findpeaks

    counts = [categories,zeros(length(categories),1)];

    for i = 1:length(categories)
        counts(i,2) = length(find(index==categories(i)));
    end

elseif hasTime == 1;
    
    counts = []

end