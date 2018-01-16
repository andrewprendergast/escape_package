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
clear xx

repList = sort(repList);
allData = zeros(1,900);

for i = 1:nReps
    clear tempData
    
    target = strcat(num2str(repList(i)), '_data.mat');
    file = strcat(folderName, '/', num2str(repList(i)), '/', target);
    load(file);
    
    [nCells, x] = size(data.name);
    clear x
    
    tempData = data.dff(:,1:900);
    
    allData = vertcat(allData, tempData);
    clear tempData
end
    
allData(1,:) = [];