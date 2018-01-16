videoName='1-1'; % Name of the video
numWell='2'; % Can '1', '2', '3' or '4'

% For the Well number 'numWell' of the video 'videoName':
% Each line in mouvement is a movement
% First row is the frame where the movement begins
% Second row is the frame where the movement ends
mouvements=detectedMouvements(videoName,numWell);
mouvements

% Now choose the number of a movement
% If only one movement was detected, put 1
numMouv=length(mouvements(:,1));

% For the Well number 'numWell' of the video 'videoName':
% return all global parameters (same as in the ZebraZoom paper)

globparam=extractParams(videoName,numWell,numMouv,'globparam');
globparam


% For the Well number 'numWell' of the video 'videoName':
% return the UNsmoothed tail angle of mouvement 'numMouv'
angle=extractParams(videoName,numWell,numMouv,'angle');
%figure(1);
%plot(angle);

% For the Well number 'numWell' of the video 'videoName':
% return the SMOOTHED tail angle of mouvement 'numMouv'
angle=extractParams(videoName,numWell,numMouv,'angleSmoothed');
%figure(2);
%plot(angle);

% For the Well number 'numWell' of the video 'videoName':
% return the curvature of mouvement 'numMouv'

curvature=extractParams(videoName,numWell,numMouv,'curvature');
%figure(3);
%imagesc(curvature);

% For the Well number 'numWell' of the video 'videoName':
% displays the video of the fish swimming for the movement 'numMouv'
% Very important: a red point appears in the middle of the video
% at the time points where ZebraZoom detected the movement
% (this is to check if the movements are detected at 'the right times')
%extractParams(videoName,numWell,numMouv,'video');


