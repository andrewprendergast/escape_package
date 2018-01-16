clear all

[file, folder] = uigetfile('*.*','MultiSelect','on');

if ischar(file)==1
    file = {file};
else
end

nGrps = numel(file); % This is the number of cell types in the analysis

for i = 1:nGrps
    maskStr{i} = strcat(folder, file(i));
    maskROIs{i} = unzip(cell2mat(maskStr{i}));
    roiCell{i} = ReadImageJROI(maskROIs{i});
end

roiArea = [];

for i = 1:nGrps
    roiStruct{i} = [roiCell{i}{:}];
    polyCell{i} = {roiStruct{i}(:).mnCoordinates};
    
    for j = 1:length(polyCell{i})
        x = [polyCell{i}{1,j}(:,1)];
        y = [polyCell{i}{1,j}(:,2)];
        a = polyarea(x,y);
        
        roiArea = [roiArea, a];
        
        clear x
        clear y
        clear a
    end
    
end

delete('*.roi')