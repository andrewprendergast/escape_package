close all

freq = 4; % this is the imaging frequency in Hz

nFrames = length(m(1,1,:));
tFrame = (1/freq);
time = [0:tFrame:(nFrames-1)*tFrame];

% Develop label mask set. Each set is defined an individual .zip of ROIs from ImageJ/Fiji

cmap = hsv(nGrps);

for i = 1:nGrps
    
    temp = bwconncomp(setMaskBin{i}, 4);
    labelMask{i} = labelmatrix(temp);
    clear temp
    
    % Find centroids
    
    coordMat{i} = regionprops(setMaskBin{i}, 'Centroid');
    coordMat{i} = cell2mat(struct2cell(coordMat{i}));
    coordX{i} = coordMat{i}(1:2:length(coordMat{i}));
    coordY{i} = coordMat{i}(2:2:length(coordMat{i}));
    clear coordMat
    nROIs{i} = length(coordX{i});
    
    % Find mean brightness for each ROI at each time point
    
    mBright{i} = zeros(nROIs{i}, nFrames);
    
    for j = 1:nFrames
        
        bright = regionprops(labelMask{i}, m(:,:,j), 'MeanIntensity');
        bright = cell2mat(struct2cell(bright));
        mBright{i}(:,j) = bright';
    
    end
    
    % Correct for photobleaching here!
    
    for j = 1:nROIs{i}
        
        % Fit poly to fluorescence minima method
        
        [maxBright, minBright] = peakdet(mBright{i}(j,:), 0.05); % adjust delta here if fit fails
        
        if isempty(minBright) == 0;
        
            idx = minBright(:,1);
            val = minBright(:,2);
            
            [fitBright, gofBright, outBright] = fit(idx, val, 'exp1', 'Normalize', 'on'); % consider changing type to 'exp1'

            base{i}(j,:) = feval(fitBright, [1:nFrames])';
            
            % adapted from CW code--
            
%             base{i}(j,:) = base{i}(j,:)./base{i}(j,1) % ? 
            mBrightAdj{i}(j,:) = mBright{i}(j,:)./base{i}(j,:); % switched from subtraction
        
        else
            mBrightAdj{i}(j,:) = mBright{i}(j,:);
        end
                
        % This module is a plotting verification of the above, comment it
        % out if necessary
        
%         plot(mBright{i}(j,:))
%         hold on
%         scatter(idx, val, 'k')
%         plot(base{i}(j,:), 'r')
%         k = waitforbuttonpress;
%         close
        
    end        
    
    % Display initial plotting, develop dF/F measure
    
    fx = figure();
    set(fx, 'Position', [100 500 1200 400])
    
    for j = 1:nROIs{i}
        
        % Request user input
        
        plot(mBrightAdj{i}(j,:), 'Color', cmap(i,:))
        f0Points = ginput;
        x1f0{i}(j) = round(f0Points(1,1));
        x2f0{i}(j) = round(f0Points(2,1));
        clear f0Points
        clf
        
        % Calculate dF/F
        
        f0{i}(j) = mean(mBrightAdj{i}(j, x1f0{i}(j):x2f0{i}(j)));
%         dFF{i}(j,:) = mBrightAdj{i}(j,:)/(f0{i}(j)); % AP initial method
        dFF{i}(j,:) = ((mBrightAdj{i}(j,:)/(f0{i}(j)))-1)*100; % CW method
        
        dFF{i}(j,:) = dFF{i}(j,:)-min(dFF{i}(j,:)); % shift minimum
        
    end
        
end

close all

% Build dFF structure

clear data
clear temp

for i = 1:nGrps
    temp(i) = nROIs{i};
end

totalROIs = sum(temp);

clear temp

data.dff = vertcat(dFF{:});
data.name = [1:totalROIs]';

% This is a terrible way to do this probably

for i = 1:nGrps
    for j = 1:nROIs{i};
        temp(i,j) = i;
    end
end

temp = sort(temp(:));
temp(temp(:)==0) = [];

data.group = temp;

clear temp

% Plotting

dffplot