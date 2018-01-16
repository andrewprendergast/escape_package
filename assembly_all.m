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

[x, y] = size(bigArray);
nAll = x;

% plotting

h1 = figure();
set(h1, 'Position', [1 1200 1200 1200]);

for i = 1:nAll
    plot(bigArray(i,5:end)-(100*i), 'k')
    hold on
end
axis square