%% Function detecting tail angle from RDVision tracking, returns several useful parameters

function [tailAngle, fishPosition, headDirection] = tailangle(trackingData)

% head direction vector is the swim bladder minus the middle between the eyes the vector is not pointing in the direction of the fish but in the opposite direction so both vector, head and tail direction, point in the same direction, otherwise the "large" angle is calculated, i.e. a fish that doesn't move has a 180 deg tail angle

pointBetweenEyes = [(trackingData(:,4)+trackingData(:,6))./2, (trackingData(:,5)+trackingData(:,7))./2];
headDirection = [trackingData(:,8)-pointBetweenEyes(:,1),  trackingData(:,9) - pointBetweenEyes(:,2)];

% tail direction vector is the last point on the tail minus the swimm bladder

lastTailCoordinate = [trackingData(:,size(trackingData,2)-1), trackingData(:,size(trackingData,2))];
tailDirection = [lastTailCoordinate(:,1) - trackingData(:,8), lastTailCoordinate(:,2) - trackingData(:,9)];

 % loop over every timepoint and calculate the angle
    for i = 1:size(trackingData,1)
        tailVectorLength = sqrt(tailDirection(i,1).^2 + tailDirection(i,2).^2);
        headVectorLength = sqrt(headDirection(i,1).^2 + headDirection(i,2).^2);
        tailAngle(i) = acosd(dot(tailDirection(i,:), headDirection(i,:))./(headVectorLength.*tailVectorLength));
        
        % use the cross product to decide whether the angle goes in the positive or the negative direction
        
        c = cross([tailDirection(i,:) 0], [headDirection(i,:) 0]);
        tailAngle(i) = tailAngle(i).*sign(c(3));
    end
    
% fish position is the absolute position of the swim bladder

fishPosition = [trackingData(:,8),  trackingData(:,9)];

% head direction to output is the same as calculated above but the vector showing in the opposite direction(i.e. the direction of the fish)

headDirection = headDirection.*-1;
