% dF/F

fAll = figure();
set(fAll, 'Position', [100 500 1200 800])
subplot(2,1,1)

for i = 1:totalROIs
    plot(time, data.dff(i,:), 'Color', cmap(data.group(i),:))
    hold on
end

xlim([0 max(time)]);
xlabel('Time (sec)')
ylabel('dF/F (percent change)')

% Raster plot

for i = 1:totalROIs
    
    [maxtab, mintab] = peakdet(data.dff(i,:), 5); % adjust delta for sensitivity
    
    peaksTime{i} = maxtab(:,1);
    peaksAmp{i} = maxtab(:,2); 
    
    data.nPeaks(i) = length(maxtab(:,1));
    
    clear maxtab
    clear mintab
end

data.nPeaks = data.nPeaks';
data.peaksTime = peaksTime';
data.peaksAmp = peaksAmp';

temp = cellfun(@transpose, data.peaksTime, 'UniformOutput', false);
timeMat = cellfun(@(x) x/freq, temp, 'UniformOutput', false);

clear temp
clear peaksTime
clear peaksAmp

subplot(2,1,2)
plotSpikeRaster(timeMat, 'PlotType', 'vertline', 'VertSpikeHeight', 0.5);

box on
xlabel('Time (sec)')
ylabel('ROI')

% Integrate

for i = 1:totalROIs

    data.int(i) = trapz(data.dff(i,:));

end

data.int = data.int';

% Joy Division plot

fJD = figure();
set(fJD, 'Position', [800 1 1600 1000]);

subplot(2,2,[1 3])

for i = 1:totalROIs
    plot(time, data.dff(i,:)-(100*i), 'Color', cmap(data.group(i),:))
    text(0.05*max(time), (-i*100+8), [num2str(i)], 'FontWeight', 'bold', 'FontSize', 14)
    hold on
end

set(gca, 'YTickLabel',[])
set(gca, 'YTick', [])
axis tight
box on
xlabel('Time (sec)')
ylabel('dF/F')

subplot(2,2,2)

nMins = (nFrames/freq)/60;

threshold = 3500*nMins;  % this value sets threshold for "activity" it's semiarbitrary

gscatter(data.name, data.int, data.group)
line([0, totalROIs], [threshold, threshold], 'Color', 'k')

xlabel('Cell ID')
ylabel('Integrated dF/F')

% gscatter(data.nPeaks, data.int, data.group)
% text(data.nPeaks+2, data.int-100, num2str(data.name))
% xlabel('Number of Peaks')
% ylabel('Integrated Signal')
% 
% b = gca;
% legend(b, 'off')
% clear b

% correlation of active cells

subplot(2,2,4)

% all correlations

clear temp
[x, frames] = size(data.dff);
clear x

for i=1:totalROIs; 
    for j=1:totalROIs; 
        temp=corrcoef(data.dff(i,1:frames),data.dff(j,1:frames));
        B(i,j)=temp(1,2);
    end;
end;

% thresholding off active set

clear temp

activeIndex = find(data.int>threshold);
activeSet = data.dff(activeIndex,:);
activeNames = data.name(activeIndex);

[height,width] = size(activeSet);
[tempCells, tempFrames] = size(data.dff)

for i=1:height; 
    for j=1:height; 
        temp=corrcoef(activeSet(i,1:tempFrames),activeSet(j,1:tempFrames));
        C(i,j)=temp(1,2);
    end;
end;

clear tempCells
clear tempFrames

if isempty(activeIndex)==0

    imagesc(C, [-0.25, 1]);
    axis square
    set(gca,'XTick', 1:height);
    set(gca,'YTick', 1:height);
    set(gca,'XTickLabel', activeNames);
    set(gca,'YTickLabel', activeNames);
    hold off

else
    C = [];
end

% generate some additional data fields

data.corrMat = B;

data.corrMatThresh = C;
data.threshNames = activeNames;
data.threshGroup = data.group(activeIndex);

data.coordX = horzcat(coordX{:})';
data.coordY = horzcat(coordY{:})';

% Display ROI map

d = im2double(m);

% dev = std(d,0,3); % std deviation projection
dev = sum(d,3); % max projection

alpha = sum(cat(3, setMaskBin{:}),3)/3;

f1 = figure();
imshow(dev.*0.003); % This scalar depends on whether base image is 8- or 16-bit (3 works well for 16, 0.003 for 8-bit)
hold on
f1 = imshow(merge);
hold off
set(f1, 'AlphaData', alpha)

for i = 1:nGrps
    for j = 1:nROIs{i}
        text(coordX{i}(j)+10, coordY{i}(j), num2str(j), 'Color', cmap(i,:))
    end
end

% saving

mkdir('Analysis', name);

saveas(f1, fullfile('Analysis',name,strcat(name, '_map')), 'fig');
saveas(fJD, fullfile('Analysis',name,strcat(name, '_indplot')), 'fig');
saveas(fAll, fullfile('Analysis',name,strcat(name, '_allplot')), 'fig');
save(fullfile('Analysis',name,strcat(name, '_data')), 'data');

close all
clear all