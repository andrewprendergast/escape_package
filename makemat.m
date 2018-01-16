clear all
close all

folderName = uigetdir('*.*');
repList= str2num(ls(folderName));

[x, nReps] = size(repList);

if x > 1
    tempMat = reshape(repList, [1, x*nReps]);
    [xx, nReps] = size(tempMat);
    repList = tempMat;
else
end

clear x
repList = sort(repList);

allData = ones (1, 5);
condition = input('What group is this?');

for i = 1:nReps
    clear tempData
    
    target = strcat(num2str(repList(i)), '_data.mat');
    file = strcat(folderName, '/', num2str(repList(i)), '/', target);
    load(file);
    
    [nCells, x] = size(data.name);
    clear x
    
    tempData = zeros(nCells, 5);
    tempData(:,1) = data.name;
    tempData(:,2) = data.group;
    tempData(:,3) = data.int;
    tempData(:,4) = data.nPeaks;
    tempData(:,5) = condition;
    
    allData = vertcat(allData, tempData);
    clear tempData
end
    
allData(1,:) = [];