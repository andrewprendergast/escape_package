function [h1] = plot_multi_solo(combined)

nCond = length(unique(combined(:,2)));
nTimes = length(unique(combined(:,3)));
nGrps = nCond * nTimes;

StatMat = zeros(nTimes, 2, nCond);

for i = 1:nCond;
    temp = combined(combined(:,2)==i,:);
    [x, y] = grpstats(temp(:,1), temp(:,3), {'mean', 'sem'});
    StatMat(:,1,i) = x;
    StatMat(:,2,i) = y;
    clear x
    clear y
    clear temp
end

offset = 0.5/(nCond-1);
offsetMat = [-0.25:offset:0.25];

colorMat = hsv(nCond);
mColorMat = colorMat./2;

h1 = figure();
set(h1, 'Position', [1 1200 1200 600]);

for i = 1:nCond;

temp = combined(combined(:,2)==i,:);

scatter(temp(:,3)+offsetMat(i), temp(:,1), 100, colorMat(i,:), '.')
hold on
xlim([min(combined(:,3))-1,max(combined(:,3))+1]);
set(gca, 'Xtick', (unique(combined(:,3))'));
jitter
errorbar(unique(temp(:,3)+offsetMat(i)), StatMat(:,1,i)', StatMat(:,2,i)', 'Color', mColorMat(i,:));
clear temp
end