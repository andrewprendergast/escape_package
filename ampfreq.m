nGrps = length(groups);
nPeaks = 5; % change this to change trim level

% establish bounds for struct so that everything fits prior to trimming

for i = 1:nFiles
    [m(i), n(i)] = size(escapes(i).consPeaks);
end

clear n
maxLength = max(m);
clear m

% preallocate block struct

clear block

for i = 1:nGrps
    block(i).idx = nan(nFiles,1);
    block(i).name = nan(nFiles,1);
    block(i).posBends = nan(nFiles, maxLength);
    block(i).negBends = nan(nFiles, maxLength);
    block(i).hemi = nan(nFiles, maxLength);
end

% place consPeaks data in block struct

for i = 1:nGrps
    for j = 1:nFiles
        if escapes(j).genotype == groups(i) && escapes(j).isEscape == 1 && escapes(j).latency < (20*frameInt) % exclusion criteria
            
            block(i).idx(j) = j; % this is the escape index
            block(i).name(j) = escapes(j).larvaNew; % this is the larva name for grouping purposes
            
            clear m
            clear n
            
            [m, n] = size(escapes(j).consPeaks(or(escapes(j).consPeaks(:,5)==1,escapes(j).consPeaks(:,5)==3),2));
            
            block(i).posBends(j,1:m) = escapes(j).consPeaks(or(escapes(j).consPeaks(:,5)==1,escapes(j).consPeaks(:,5)==3),2);
            
            clear m
            clear n
            
            [m, n] = size(escapes(j).consPeaks(or(escapes(j).consPeaks(:,5)==2,escapes(j).consPeaks(:,5)==4),2));
            
            block(i).negBends(j,1:m) = escapes(j).consPeaks(or(escapes(j).consPeaks(:,5)==2,escapes(j).consPeaks(:,5)==4),2);
            
            clear m
            clear n
            
            [m, n] = size(escapes(j).consPeaks(:,6));
            
            block(i).hemi(j,1:m) = (escapes(j).consPeaks(:,6).*frameInt);
        else
        end
    end
end

% trim block struct to size of nPeaks (necessary?)

for i = 1:nGrps
    block(i).posBends = block(i).posBends(:,1:nPeaks);
    block(i).negBends = block(i).negBends(:,1:nPeaks);
    block(i).hemi = block(i).hemi(:,1:(nPeaks*2));
end

% convert hemicycle to full cycle

idxOne = [1:2:nPeaks*2];
idxTwo = [2:2:nPeaks*2];

for i = 1:nGrps
    for j = 1:nPeaks
        block(i).full(:,j) = (nanmean([block(i).hemi(:,idxOne(j)), block(i).hemi(:,idxTwo(j))],2)*2);
    end
end

% get population averages

for i = 1:nGrps
    block(i).indMeansPos = nanmean(block(i).posBends);
    block(i).indMeansNeg = nanmean(block(i).negBends);
    block(i).indMeansFull = nanmean(block(i).full);
    
    block(i).indErrsPos = nanstd(block(i).posBends)./sqrt(sum(~isnan(block(i).posBends)));
    block(i).indErrsNeg = nanstd(block(i).negBends)./sqrt(sum(~isnan(block(i).negBends)));
    block(i).indErrsFull = nanstd(block(i).full)./sqrt(sum(~isnan(block(i).full)));
end
    
% plotting

% all amplitudes by genotype

fAmp = figure();
set(fAmp, 'Position', [1 1200 1200 1200]);

padding = (nGrps+1);
plotBlock = padding*nPeaks;
cmap = [0.831 0 0; 0 0 0; 0 0.831 0.831; 0 0 0]; % define manually

subplot(2,2,1)
for i = 1:plotBlock
    for j = 1:nFiles
        if i <= nGrps
        scatter(i:padding:plotBlock, [block(i).posBends(j,:)], 3, cmap(i,:), '.')
        hold on
        else
        end
    end
end

jitter

for i = 1:padding
    if i <= nGrps
    errorbar(i:padding:plotBlock, block(i).indMeansPos, block(i).indErrsPos, '.k', 'LineWidth', 1);
    else
    end
end

ax = gca;
set(ax, 'XTick', 0:plotBlock);
set(ax, 'XTickLabel', {'', '+/+', '+/-', '-/-'});
ylim([0 200])

subplot(2,2,3)
for i = 1:plotBlock
    for j = 1:nFiles
        if i <= nGrps
        scatter(i:padding:plotBlock, [block(i).negBends(j,:)], 3, cmap(i,:), '.')
        hold on
        else
        end
    end
end

jitter

for i = 1:padding
    if i <= nGrps
    errorbar(i:padding:plotBlock, block(i).indMeansNeg, block(i).indErrsNeg, '.k', 'LineWidth', 1);
    else
    end
end

ax = gca;
set(ax, 'XTick', 0:plotBlock);
set(ax, 'XTickLabel', {'', '+/+', '+/-', '-/-'});
set(ax, 'XAxisLocation', 'top')
ylim([-200 0])

subplot(2,2,[2,4])
for i = 1:plotBlock
    for j = 1:nFiles
        if i <= nGrps
        scatter(i:padding:plotBlock, [block(i).full(j,:)], 3, cmap(i,:), '.')
        hold on
        else
        end
    end
end

jitter

for i = 1:padding
    if i <= nGrps
    errorbar(i:padding:plotBlock, block(i).indMeansFull, block(i).indErrsFull, '.k', 'LineWidth', 1);
    else
    end
end

ax = gca;
set(ax, 'XTick', 0:plotBlock);
set(ax, 'XTickLabel', {'', '+/+', '+/-', '-/-'});
ylim([0 50])

% for i = 1:nGrps
%     s(i) = subplot(2,nGrps,i);
%     for j = 1:nFiles
%     scatter(1:nPeaks, [block(i).posBends(j,:)], 3, 'r.')
%     hold on
%     scatter(1:nPeaks, [block(i).negBends(j,:)], 3, 'b.')
%     end
%     jitter
%     errorbar(block(i).indMeansPos, block(i).indErrsPos)
%     errorbar(block(i).indMeansNeg, block(i).indErrsNeg)
% end

% full cycle duration by genotype

% for i = 1:nGrps
%     s(i) = subplot(2,nGrps,nGrps+i);
%     for j = 1:nFiles
%     scatter(1:nPeaks, [block(i).full(j,:)], 3, 'k.')
%     hold on
%     end
%     jitter
%     errorbar(block(i).indMeansFull, block(i).indErrsFull)
% end

% % overlay group traces
% 
% fMeans = figure();
% set(fMeans, 'Position', [1 1200 1200 1200]);
% cmap = hsv(nGrps);
% 
% subplot(1,2,1)
% for i = 1:nGrps
%     errorbar(block(i).indMeansPos, block(i).indErrsPos, 'Color', cmap(i,:))
%     hold on
%     errorbar(block(i).indMeansNeg, block(i).indErrsNeg, 'Color', cmap(i,:))
% end
% 
% subplot(1,2,2)
% for i = 1:nGrps
%     errorbar(block(i).indMeansFull, block(i).indErrsFull, 'Color', cmap(i,:))
%     hold on
% end