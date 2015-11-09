clear all
close all

% open escape files

[fileName, pathName] = uigetfile('*.mat','MultiSelect','on');

[m,nFiles] = size(fileName);
clear m

% preallocate escapes struct

escapes(nFiles) = struct(...
    'trial', [],...
    'latencyMeth', [],...
    'trackingData', [],...
    'date', [],...
    'larva', [],...
    'rdtrack', [],...
    'tailAngle', [],...
    'fishPosition', [],...
    'headDirection', [],...
    'tailAngleFiltered', [],...
    'interpTailAngle', [],...
    'angVel', [],...
    'angVelFitEval', [],...
    'onset', [],...
    'offset', [],...
    'tailAngleFitEval', [],...
    'consPeaks', [],...
    'isEscape', [],...
    'derFrame', [],...
    'fiveFrame', [],...
    'expFrame', [],...
    'xIntFrame', [],...
    'sdFrame', [],...
    'pAscending', [],...
    'latency', []);

for i = 1:nFiles
    if iscell(fileName)
        file = [pathName fileName{i}];
    else
        file = [pathName fileName];
    end
    
    tempfile = load(file);
    tempfile = orderfields(tempfile, escapes(1));
    
    escapes(i) = tempfile; % orderfields
    
    clear tempfile
end

clear fileName
clear pathName
clear file

% load genotype index file and assign to escapes structure

[fileName, pathName] = uigetfile('*.mat');

if iscell(fileName)
    file = [pathName fileName{i}];
else
    file = [pathName fileName];
end

% since genotype indexes are reused from experiment to experiment, it will
% be necessary to generate unique larval IDs for each animal in the batch
% analysis...

breakEnd = [find(diff([escapes.larva])<0)];
breakStart = [breakEnd+1;];

breakEnd = [breakEnd, nFiles]';
breakStart = [1, breakStart]';

nExp = length(unique({escapes.date}));

modMat = zeros(1,nFiles);
expNum = zeros(1,nFiles);

nLarvaeQuery = zeros(1, nExp);
larvaShift = zeros(1, nExp);
experiments = [1:nExp];

for i = 1:nExp
    
    if i == 1
    
    inquiry = strcat('How many larvae in trial ', num2str(experiments(i)), '?');
    nLarvaeQuery(i) = input(inquiry);
    
    expNum(breakStart(i):breakEnd(i)) = expNum(breakStart(i):breakEnd(i))+(i);
    
    modMat(breakStart(i):breakEnd(i)) = 0;
    
    elseif i <= nExp
        
    inquiry = strcat('How many larvae in trial ', num2str(experiments(i)), '?');
    nLarvaeQuery(i) = input(inquiry);
    
    expNum(breakStart(i):breakEnd(i)) = expNum(breakStart(i):breakEnd(i))+(i);
    
    modMat(breakStart(i):breakEnd(i)) = modMat(breakEnd(i-1))+nLarvaeQuery(i-1);
    
    end
end

reassign = [escapes.larva] + modMat;

for i = 1:nFiles
    escapes(i).expNum = expNum(i);
    escapes(i).larvaNew = reassign(i);
end

% clear breakStart
% clear breakEnd
% clear modMat
% clear nExp
% clear reassign
% clear expNum

% assign genotype

genotypes = importdata(file);

for i = 1:nFiles
    assignIdx = find(genotypes(:,1)==escapes(i).larvaNew);
    escapes(i).genotype = genotypes(assignIdx,2);
end
        
% begin calculation of other parameters...

nFrames = 650;
trigger = 130;
fps = 650;
trialTime = 1000; % in msec
frameInt = trialTime/fps;
mmPx = 23/351;

cutoff = 20*frameInt;

% set up unified plot figure
    
for i = 1:nFiles

    % deal with NaNs in latencies
    
    if isempty(escapes(i).latency)==1
        escapes(i).latency = NaN;
    else
    end
    
    % unit conversion
    
    escapes(i).latency = escapes(i).latency.*frameInt;
    escapes(i).fishPosition = escapes(i).fishPosition.*mmPx;
    
    % ANALYZING FROM FOLLOWING EXCLUSION CRITERIA ONLY
    
    if escapes(i).isEscape==1 && escapes(i).latency < cutoff && escapes(i).latency>0; 
        
        % re-enter latency to deal with latency cutoff
        
        escapes(i).latency = escapes(i).latency;
        
        % duration (in msec)

        escapes(i).duration = (escapes(i).offset-escapes(i).onset)*frameInt;

        % number of bends

        escapes(i).nBends = length(escapes(i).consPeaks(:,1))/2;

        % c-bend amplitude

        escapes(i).cAmp = escapes(i).consPeaks(1,2);

        % distance traveled (in mm)

        tempMat = escapes(i).fishPosition(escapes(i).onset:escapes(i).offset,:);
        tempMat(any(isnan(tempMat),2),:) = nan;
        tempMat(any(isnan(tempMat),2),:) = [];
        escapes(i).distance = arclength(tempMat(:,1), tempMat(:,2), 'linear');
        clear tempMat
        
        % average speed
        
        escapes(i).speed = escapes(i).distance/escapes(i).duration;

        % average tailbeat frequency

        escapes(i).tbf = (1/(2*(nanmean(escapes(i).consPeaks(:,6).*frameInt))));
                        
        % linear fit to hemicycle
        
        tempPeaks = escapes(i).consPeaks(:,6);
        tempPeaks = tempPeaks(~isnan(tempPeaks)); % clear nans
        
        escapes(i).hemifit = polyfit([1:length(tempPeaks)]', tempPeaks, 1);
        
        clear tempPeaks
        
        % subdivide hemifit into slopes and ints
        
        escapes(i).hemiSlope = escapes(i).hemifit(1);
        escapes(i).hemiInt = escapes(i).hemifit(2);
        
        % take initial slope
        
        if escapes(i).pAscending(1) > 3
            escapes(i).ascSlope = escapes(i).pAscending(1);
        else
            escapes(i).ascSlope = NaN;
        end
        
    % excluded trials get NaNs

    else
        
        escapes(i).latency = NaN;
        escapes(i).duration = NaN;
        escapes(i).speed = NaN;
        escapes(i).nBends = NaN;
        escapes(i).cAmp = NaN;
        escapes(i).distance = NaN;
        escapes(i).tbf = NaN;
        escapes(i).slope = NaN;
        escapes(i).hemifit = [NaN, NaN];
        escapes(i).hemiSlope = NaN;
        escapes(i).hemiInt = NaN;
        escapes(i).ascSlope = NaN;
        
    end        
end        

plotmodule