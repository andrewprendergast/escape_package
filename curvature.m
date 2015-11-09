%% Function detecting curvature related parameters from RDVision tracking

function [ptAngle, ptAngleFitEval, curvF, ptMax, ptMin] = curvature(trackingData, onset, offset, nFrames, doFlip)

% head direction vector is the swim bladder minus the middle between the eyes the vector is not pointing in the direction of the fish but in the opposite direction so both vector, head and tail direction, point in the same direction, otherwise the "large" angle is calculated, i.e. a fish that doesn't move has a 180 deg tail angle

pointBetweenEyes = [(trackingData(:,4)+trackingData(:,6))./2, (trackingData(:,5)+trackingData(:,7))./2];
headDirection = [trackingData(:,8)-pointBetweenEyes(:,1),  trackingData(:,9) - pointBetweenEyes(:,2)];

% simple case: run tail angle for all 8 points

for i = 1:2:16
    ptCoord{(i+1)/2} = [trackingData(:,9+i), trackingData(:,9+i+1)]; % cell array, each column contains coordinates for each point
end

for i = 1:8
    ptDir{i} = [ptCoord{i}(:,1) - trackingData(:,8), ptCoord{i}(:,2) - trackingData(:,9)];
end

for i = 1:size(trackingData,1)
    
    headVectorLength = sqrt(headDirection(i,1).^2 + headDirection(i,2).^2);
    
    for j = 1:8
        ptVectorLength(j) = sqrt(ptDir{j}(i,1).^2 + ptDir{j}(i,2).^2);
        ptAngle{j,i} = acosd(dot(ptDir{j}(i,:), headDirection(i,:))./(headVectorLength.*ptVectorLength(j)));
        
        c{j} = cross([ptDir{j}(i,:) 0], [headDirection(i,:) 0]);
        ptAngle{j,i} = ptAngle{j,i}.*sign(c{j}(3));
    end
end

ptAngle = ptAngle';
ptAngle = cell2mat(ptAngle);
ptAngle = ptAngle(:,2:8);

if doFlip == 1
    ptAngle = -ptAngle;
else
end

% smooth all elements of ptAngle

for i = 1:7
    temp = medfilt1(ptAngle(:,i), 3);
    
    interpPt = [trackingData(:,3), temp];
    interpPt(any(isnan(interpPt),2),:) = nan;
    interpPt(any(isnan(interpPt),2),:) = [];
    interpPtAngle = interp1(interpPt(:,1), interpPt(:,2), 1:650);
	interpPtAngle(isnan(interpPtAngle)) = [];
    
    ptAngleFit = fit((1:length(interpPtAngle))', interpPtAngle', 'smoothingspline', 'SmoothingParam', 0.5);
	ptAngleFitEval(:,i) = ptAngleFit(1:nFrames);
    
    % detect peaks for each ptAngle
    
    [tempMax, tempMin] = peakdet(ptAngleFitEval(onset:offset,i),4);
    
    if tempMax(1,2) < 10
        tempMax(1,:) = [];
    else
    end
    
    if tempMin(1,2) >-10
        tempMin(1,:) = [];
    else
    end
    
    ptMax{i,:} = tempMax;
    ptMin{i,:} = tempMin;
end

% plotting

curvF = figure();
set(curvF, 'Position', [1200 1 1200 400]);

for i = 1:7
    subplot(1,3,1)
    plot([ptAngle(onset:offset,i)]-((i-1)*50));
    hold on
    subplot(1,3,2)
    plot([ptAngleFitEval(onset:offset,i)], 'k');
    hold on
    scatter(ptMax{i}(:,1), ptMax{i}(:,2), 'b')
    scatter(ptMin{i}(:,1), ptMin{i}(:,2), 'r')
end

subplot(1,3,3)
surf(ptAngleFitEval(onset:offset,:), 'EdgeColor', 'none')
hold on
plot3((7.*ones(1, offset-onset+1))', 1:(offset-onset+1), ptAngleFitEval(onset:offset,7) , 'Color', 'k', 'LineWidth', 2)
view(45,45)