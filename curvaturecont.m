% function [xcoord ycoord] = curvaturecont(trackingData, onset, offset, nFrames, doFlip)

% pull out all x coords and y coords

xcoord = [[1:650]' trackingData(:,10) trackingData(:,12) trackingData(:,14) trackingData(:,16) trackingData(:,18) trackingData(:,20) trackingData(:,22) trackingData(:,24)];
ycoord = [[1:650]', trackingData(:,11) trackingData(:,13) trackingData(:,15) trackingData(:,17) trackingData(:,19) trackingData(:,21) trackingData(:,23) trackingData(:,25)];

xcoord(any(isnan(xcoord),2),:) = nan;
xcoord(any(isnan(xcoord),2),:) = [];

ycoord(any(isnan(ycoord),2),:) = nan;
ycoord(any(isnan(ycoord),2),:) = [];

% fit spline to points at each frame in time
% need to find a way to do fits so that continuous x variation isn't
% necessary (i.e. head-to-tail)

iter = length(xcoord);

% for i = 1:iter;
%     bodyFit{i} = fit((xcoord(i,2:end))', (ycoord(i,2:end))', 'smoothingspline', 'SmoothingParam', 0.25);
% end

cmap = jet(iter);

for i = 140:iter
    plot(xcoord(i,2:end), ycoord(i,2:end), 'Color', cmap(i,:))
    hold on    
    axis square
    k = waitforbuttonpress();
end