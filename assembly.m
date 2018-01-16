cla
clear 
close all

[file, folder] = uigetfile('*.*','MultiSelect','on');
dir = folder;
nTrials = length(file);

for i = 1:nTrials
    fileData = load(fullfile(folder, file{i}));
    limit = strfind(file{i}, '_');
    fileIndex = file{i}(1:limit-1);
    newName{i} = strcat(fileIndex, '_data');
    allData(i) = fileData.data;
    nCells(i) = length(allData(i).name);
end

for i = 1:nTrials
    [testX, testY] = size(allData(i).int);
    if testY > testX
        allData(i).int = allData(i).int';
    else
    end
    clear testX
    clear testY
    [testX, testY] = size(allData(i).nPeaks);
    if testY > testX
        allData(i).nPeaks = allData(i).nPeaks';
    else
    end
    clear testX
    clear testY
end

bigArray = [vertcat(allData.name), vertcat(allData.group), vertcat(allData.int), vertcat(allData.nPeaks), vertcat(allData.dff)];

dCells = bigArray(bigArray(:,2)==1,:);
vCells = bigArray(bigArray(:,2)==2,:);
dCells = sortrows(dCells, 3);
vCells = sortrows(vCells, 3);

[x, y] = size(dCells);
nDorsal = x;
[x, y] = size(vCells);
nVentral = x;

dMed = round(nDorsal/2);
vMed = round(nVentral/2);

% plotting

h1 = figure();
set(h1, 'Position', [1 1200 1200 600]);

nTraces = 7; % sets the number of flanking traces to plot

s1 = subplot(1,2,1);
for i = dMed-nTraces:dMed+nTraces
    plot(dCells(i,5:end)-(100*(i-dMed-nTraces)), 'k')
    hold on
end
axis square

s2 = subplot(1,2,2);
for i = vMed-nTraces:vMed+nTraces
    plot(vCells(i,5:end)-(100*(i-vMed-nTraces)), 'k')
    hold on
end
axis square

linkaxes([s2, s1], 'y')