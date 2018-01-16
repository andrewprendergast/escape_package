% function [] = multiline(data)

nCells = max(unique(data(:,2)));

dorsalSet = data(data(:,3)==1,:);
ventralSet = data(data(:,3)==2,:);

dNames = unique(dorsalSet(:,2));
vNames = unique(ventralSet(:,2));
dCells = length(dNames);
vCells = length(vNames);

dIntMed = grpstats(dorsalSet(:,4), dorsalSet(:,1), {'mean'});
dErr = grpstats(dorsalSet(:,4), dorsalSet(:,1), {'sem'});
vIntMed = grpstats(ventralSet(:,4), ventralSet(:,1), {'mean'});
vErr = grpstats(ventralSet(:,4), ventralSet(:,1), {'sem'});

dCmap = hsv(dCells);
vCmap = hsv(vCells);

% dorsal cells

h1 = figure();
for i = 1:dCells 
    index = find(data(:,2)==dNames(i));
    scatter(data(index,1), data(index,4), 20, dCmap(i,:))
    hold on
    plot(data(index,1), data(index,4), 'Color', dCmap(i,:))
    clear index
end

% plot(unique(data(:,1)), dIntMed, 'Color', 'k', 'LineWidth', 2)
e1 = errorbar(unique(data(:,1)), dIntMed, dErr);
set(e1, 'Color', 'k', 'LineWidth', 2)
ylim([min(dIntMed)*.9, max(dIntMed)*1.1]);

% ventral cells

h2 = figure();
for i = 1:vCells
    index = find(data(:,2)==vNames(i));
    scatter(data(index,1), data(index,4), 20, vCmap(i,:))
    hold on
    plot(data(index,1), data(index,4), 'Color', vCmap(i,:))
    clear index
end

% plot(unique(data(:,1)), vIntMed, 'Color', 'k', 'LineWidth', 2)
e2 = errorbar(unique(data(:,1)), vIntMed, vErr);
set(e2, 'Color', 'k', 'LineWidth', 2)
ylim([min(vIntMed)*.9, max(vIntMed)*1.1]);