%% Defines escape interval based on interpolated tail angle

function [angVel, angVelFitEval, onset, offset] = escint(interpTailAngle, nFrames, trigger)

angVel = diff(interpTailAngle)';

% clear any NaNs from angVel (these seem to occur at the end, the input is interpolated so there should be no internal gaps)

angVel(any(isnan(angVel),2),:) = [];

% smooth angVel

angVelFit = fit([1:length(angVel)]', angVel, 'smoothingspline', 'SmoothingParam', 0.25);
angVelFitEval = abs(angVelFit([1:nFrames]));

velBinIndex = find(angVelFitEval>1);
velBin = zeros(1,nFrames);
velBin(velBinIndex) = 1;
velBin(1:trigger) = 0; % excludes pre-stimulus data

% join gaps using strel

movingFill = imclose(velBin, strel(ones(10)));

t = diff([false;movingFill'==1;false]);
p = find(t==1);
q = find(t==-1);

% weights interval detection by distance from stimulus

intDif = q-p;
weighted = (intDif .* (1./p));
[maxVal, difInd] = max(weighted);

% take onset and offset

onset = p(difInd);
offset = q(difInd)-1;