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

allData = [];
condition = input('What group is this?');

for i = 1:nReps
    clear tempData
    
    target = strcat(num2str(repList(i)), '_data.mat');
    file = strcat(folderName, '/', num2str(repList(i)), '/', target);
    load(file);
    
    [m, n] = size(data.corrMatThresh);
    corrVect = [];
    connVect = [];
    cell1Vect = [];
    cell2Vect = [];
    
    % specify connection matrix
    
    tempMat1 = repmat(data.threshGroup-1,1,m);
    tempMat2 = repmat((data.threshGroup-1)',m,1);
    typeMat = (tempMat1 + tempMat2)+1;
    
    % specify name matrices
    
    cell2 = repmat(data.threshNames,1,m);
    cell1 = repmat((data.threshNames)',m,1);
    
    % organize into vertical matrix
    
    for j = 2:m
        
        temporary = cell1(j:end,j-1);
        cell1Vect = vertcat(cell1Vect, temporary);
        clear temporary
        
        temporary = data.corrMatThresh(j:end,j-1);
        corrVect = vertcat(corrVect, temporary);
        clear temporary
        
        temporary = typeMat(j:end, j-1);
        connVect = vertcat(connVect, temporary);
        clear temporary
        
        temporary = cell2(j:end, j-1);
        cell2Vect = vertcat(cell2Vect, temporary);
        clear temporary
        
    end
    
    if isempty(corrVect)==0;
        
        tempData(:,1) = cell1Vect; % this is the first cell of the connection pair
        tempData(:,2) = connVect; % this is the connection index
        tempData(:,3) = corrVect; % this is the correlation data
        tempData(:,4) = cell2Vect; % this is the second cell of the connection pair
        tempData(:,5) = condition; % this is the experimental condition
    
        allData = vertcat(allData, tempData);
        clear tempData
    else
    end
end
    
% allData(1,:) = [];