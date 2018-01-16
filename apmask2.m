function [setMaskBin, m, name, output_dir, nGrps, merge] = apmask2

cla
clear 
close all

% Load data

[file, folder] = uigetfile('*.*');
fic = fullfile(folder, file);
img = fic;

output_dir = folder;

% note that it is looking for a very specific naming convention

rBound = strfind(file, '.');
lBound = max(strfind(file, ' '));

name = file(lBound+1:rBound-1);

clear file
clear folder

% Prompt user to specify mask files. Each mask file is a .zip

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

% Import tiff file

m = multitiff2M(img);
xDim = length(m(1,:,1));
yDim = length(m(:,1,1));
d = im2double(m);
s = size(d);

% Pull out ROI coordinates based on polygons

for i = 1:nGrps
    roiStruct{i} = [roiCell{i}{:}];
    polyCell{i} = {roiStruct{i}(:).mnCoordinates};
    
    mask = zeros(yDim, xDim);
    f1 = figure();
    imshow(mask)
    hold on
    
    % Draw polygons
    
    for j = 1:length(polyCell{i})
        x = [polyCell{i}{1,j}(:,1)];
        y = [polyCell{i}{1,j}(:,2)];
        a = fill(x, y, 'w');
        set(a, 'EdgeColor', 'none');
        clear x
        clear y
        clear a
    end
    
    % Display
    
    pause(1)
    f = getframe(get(figure(f1),'CurrentAxes'));
    setMask{i} = frame2im(f);
    setMaskBin{i} = rgb2gray(setMask{i});
    close(f1)
    
    setMaskBin{i}(s(1)+1:end,:,:)=[];
    setMaskBin{i}(:,s(2)+1:end,:)=[];
    
%     figure();
%     imshow(setMaskBin{i})
    setMaskBin{i} = setMaskBin{i} > 250;

end

% Superimpose masks

[yDim, xDim] = size(setMaskBin{1}(:,:,1));
close all

adjMat = hsv(nGrps);

for i = 1:nGrps
    rgbMask{i} = cat(3, setMaskBin{i}.*adjMat(i,1),setMaskBin{i}.*adjMat(i,2),setMaskBin{i}.*adjMat(i,3));
    temp(:,:,:,i) = cat(3, rgbMask{i});
end

merge = sum(temp,4);
figure();
imshow(merge)
pause(1)

% Clean up

delete('*.roi')

close all