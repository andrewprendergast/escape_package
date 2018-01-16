%% plots skeletonized escape at points corresponding to inputVector

function [] = skeleton(inputVector, trackingData)

axis equal
hold on

% remove zeros from inputVector

inputVector(find(inputVector==0))=[];

for i = inputVector'
    
% head

x = sin(trackingData(i,4)-(pi/2))*5;
y = cos(trackingData(i,4)-(pi/2))*5;

line([trackingData(i,24) trackingData(i,24)+x], [trackingData(i,25), trackingData(i,25)+y], 'Color', 'r', 'LineWidth', 3)

% tail

line([trackingData(i,6) trackingData(i,8)], [trackingData(i,7) trackingData(i,9)], 'Color', 'g')
line([trackingData(i,8) trackingData(i,10)], [trackingData(i,9) trackingData(i,11)], 'Color', 'g')
line([trackingData(i,10) trackingData(i,12)], [trackingData(i,11) trackingData(i,13)], 'Color', 'g')
line([trackingData(i,12) trackingData(i,14)], [trackingData(i,13) trackingData(i,15)], 'Color', 'g')
line([trackingData(i,14) trackingData(i,16)], [trackingData(i,15) trackingData(i,17)], 'Color', 'g')
line([trackingData(i,16) trackingData(i,18)], [trackingData(i,17) trackingData(i,19)], 'Color', 'g')
line([trackingData(i,18) trackingData(i,20)], [trackingData(i,19) trackingData(i,21)], 'Color', 'g')
line([trackingData(i,20) trackingData(i,22)], [trackingData(i,21) trackingData(i,23)], 'Color', 'g')
line([trackingData(i,22) trackingData(i,24)], [trackingData(i,23) trackingData(i,25)], 'Color', 'g')

end