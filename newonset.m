% function [latency, fiveFrame, expFrame, xIntFrame, sdFrame, pAscending, expInterval, latFit] = newonset(tailAngleFitEval, onset, consPeaks, trigger, latencyMeth)

% determine new onset--
% 1: 5% of c-bend max method
% 2: two-phase exponential method
% 3: linear fit to c-bend rising phase intercept with zero method
% 4: 3 x pretrigger SD (noise) method
% 5: if all else fails, defaults to threshold of angular velocity

cMin = tailAngleFitEval(onset);
cMax = tailAngleFitEval(consPeaks(1,1));
cDiff = cMax-cMin;

% predefine everything as NaNs

fiveFrame = NaN;
expFrame = NaN;
xIntFrame = NaN;
sdFrame = NaN;

% for 5% peak detection method

fiveThreshold = (0.05*cDiff)+cMin; % change percentage here to change threshold
fiveFrame = find(diff(fiveThreshold>tailAngleFitEval(onset:consPeaks(1,1)))~=0)+onset;
fiveFrame = min(fiveFrame); % this is the detected frame by 5% method

% fit line to c-bend rising phase

c25 = (0.25 * cDiff) + cMin;
c75 = (0.75 * cDiff) + cMin;
expInterval = intersect(find(tailAngleFitEval>c25), find(tailAngleFitEval<c75));
expInterval = expInterval(expInterval < consPeaks(1,1));
pAscending = polyfit(expInterval, tailAngleFitEval(expInterval), 1);

% find intercept

xInt = ((-pAscending(2))/(pAscending(1))); % real x-intercept here
xIntFrame = round(xInt); % this is the detected frame by linear fit method

% fit exponential to two linear phases

if isnan(xInt)==0;

phase1 = zeros(1, xIntFrame-trigger);
phase2 = polyval(pAscending, xIntFrame:expInterval(end));

else

latencyMeth = 1; % switch methods if we fail to find an intercept

end

% use 3 standard deviations of tailAngleFitEval during pretrigger as threshold

noiseThresh = abs(nanstd(tailAngleFitEval(1:trigger))*3);
temp = find(tailAngleFitEval>noiseThresh)-trigger;
temp = temp(temp>0);
sdFrame = min(temp+trigger);

% two-phase exponential method

if isempty(phase1) == 0 && isempty(phase2) == 0

    latFit = fit([trigger:expInterval(end)]', [phase1, phase2]', 'exp1');
    expFrame = min(find(latFit(trigger:expInterval(end))>2)+trigger); % change > value to change threshold
    
else
    
    latencyMeth = 1;
    
end

% start conditional block, current approach is to try to do exponential fit, then fall back on 5% method

if isnan(consPeaks(1,1))==0 && latencyMeth==1;  % use 5% peak difference method

    onset = fiveFrame; % shifts new start detection method into onset variable!
    latency = onset - trigger;

elseif isnan(consPeaks(1,1))==0 && isempty(phase1)==0 && isempty(phase2)==0 && latencyMeth==2;  % use two-phase exponential method

    onset = expFrame; % shifts new start detection method into onset variable!
    latency = onset-trigger;

else % keeps threshold of angular velocity as latency

    latencyMeth = 5;
    onset = onset;
    latency = onset - trigger;

end