% this function processes the initial RDVision points .txt to generate a
% head/tail angle output file subject to further manipulation

clear all
close all

% define some experimentwise values

nFrames = 650;
trigger = 130;
fps = 650;
trialTime = 1000; % in msec
frameInt = trialTime/fps;
trackVers = 2;
framesVector = ([1:650].*frameInt);
mmPx = 23/351;

% open files

[fileName,pathName] = uigetfile('*.txt','MultiSelect','on');

% create new directory for output

newFolder = strcat(pathName, 'results v1/');
mkdir(newFolder);

% progress bar

h = waitbar(0,'please wait...') ;
set(h, 'Position', [1 1200 400 100]);

% begin processing

[m,nFiles] = size(fileName);
clear m

for esc = 1:nFiles
    waitbar(esc/nFiles,h)
    
    latencyMeth = 2; % 1 = 5% method, 2 = two-phase exponential method, resets every trial, 3 = simple linear intersection method, 4 = 3 x SD pretrigger threshold method
        
    % load file
    
    if iscell(fileName)
        file = [pathName fileName{esc}];
    else
        file = [pathName fileName];
    end
    
    % data.data is the struct containing all the relevant escape points
    
    data = importdata(file);
        
    if isfield(data, 'data') && isfield(data, 'colheaders')
        
        % here the program temporarily forks depending on which RDVision tracking version
        % has been used
        
        if trackVers == 3;
            vers3correct
        elseif trackVers == 2;
            vers2correct
        end
        
        % now we can start working with the actual trackingData

        [tailAngle, fishPosition, headDirection] = tailangle(trackingData);
        
        % filter noise (median filter)
        
        tailAngleFiltered = medfilt1(tailAngle, 3);

        % interpolate, first clearing any rows with NaNs

        interpMat = [trackingData(:,3), tailAngleFiltered'];
        interpMat(any(isnan(interpMat),2),:) = nan;
        interpMat(any(isnan(interpMat),2),:) = [];
        
        try
        interpTailAngle = interp1(interpMat(:,1), interpMat(:,2), 1:650);

        % detect escape interval

        [angVel, angVelFitEval, onset, offset] = escint(interpTailAngle, nFrames, trigger);

        % smooth tail angle plot, first clearing NaNs
        
        interpTailAngle(isnan(interpTailAngle)) = [];
        tailAngleFit = fit((1:length(interpTailAngle))', interpTailAngle', 'smoothingspline', 'SmoothingParam', 0.5);
        tailAngleFitEval = tailAngleFit(1:nFrames);
        
        % find peaks
        
        % first we detect peaks, then flip all plots such that the initial bend is
        % upwards

        threshold = 10;

        [tempMax tempMin] = peakdet(tailAngleFitEval, threshold); % second value is sensitivity

        if isempty(tempMax)==0
        tempMax(tempMax(:,1)<trigger,:)=[];    
        tempMax(tempMax(:,2)<threshold,:)=[];   
        else
        end
        
        if isempty(tempMin)==0
        tempMin(tempMin(:,1)<trigger,:)=[];
        tempMin(tempMin(:,2)>-threshold,:)=[];
        else
        end
        
        % note that the cfit objects tailAngleFit and angVelFit are left untouched
        % here

        if isempty(tempMin)==0 && isempty(tempMax)==0 && tempMin(1,1) < tempMax(1,1);
            tailAngle = -tailAngle;
            tailAngleFiltered = -tailAngleFiltered;
            interpTailAngle = -interpTailAngle;
            tailAngleFitEval = -tailAngleFitEval;

            angVel = -angVel;
            angVelFitEval = -angVelFitEval;
            doFlip = 1;
        else
            doFlip = 0;
        end

        clear tempMax
        clear tempMin
        clear threshold
                 
        try
        [consPeaks] = anglepeaks(tailAngleFitEval, onset, offset, trigger, 2.5);
        consPeaks(:,1) = (consPeaks(:,1)-1); % adjustment is necessary for some reason
        catch
            consPeaks = [NaN NaN NaN NaN NaN NaN];
        end
        
        % identify escapes if the first bend is > 60 deg
        
        if consPeaks(1,2) > 60
            isEscape = 1;
        else
            isEscape = 0;
        end
        
        derFrame = NaN;
        derFrame = onset; % save current onset method before recalculation
        newonset

        % PLOTTING
        
        f(esc) = figure();
        set(f(esc), 'Position', [1200 1 1200 1200]);

        % plots tailAngle and tailAngleFiltered
        
        s1 = subplot(2,7,3:7);
        plot(framesVector,tailAngle)
        hold on
        plot(framesVector, tailAngleFiltered, 'r', 'LineWidth', 2)
        
        % plots tailAngle after smoothing plus peak detection
        
        s2 = subplot(2,7,10:14);
        plot(framesVector, tailAngleFitEval, 'b');

        if isempty(onset)==0 && isempty(offset) ==0
        line(([onset offset].*frameInt), [15 15], 'LineWidth', 3, 'Color', 'r')
        else
        end
        
        ylim([-100 200]);
        
        linkaxes([s2 s1], 'xy')
        limits = ylim;
        line([trigger.*frameInt trigger.*frameInt], [limits(1) limits(2)], 'Color', 'k') 
        hold on
        
        if any(~isnan(consPeaks))==1;
        gscatter((consPeaks(:,1).*frameInt), consPeaks(:,2), consPeaks(:,5))
        else
        end
        
        if isEscape == 1
        scatter((consPeaks(1,1).*frameInt), consPeaks(1,2), 100, 'k')
        else
        end
                
        % plots skeleton at tail angle maxima
        
        s3 = subplot(2,7,1:2);
        axis equal
        skeleton(uint8(consPeaks(:,1)), trackingData)
        
        figTitle = strcat('larva', sprintf('%d', larva), 'trial', sprintf('%d', trial));
        title(figTitle);
        
        % plot c bend inset
        
        s4 = subplot(2,7,8:9);
        
        plot(framesVector(trigger:160), tailAngleFitEval(trigger:160))
        hold on
        
            if isempty(fiveFrame) == 0 && latencyMeth==1;  % 5 percent rise/Kris method
            
            line(([fiveFrame fiveFrame].*frameInt), [-50 200], 'Color', 'r')
            
            elseif isempty(expInterval)==0 && latencyMeth==2; % two-phase exponential method
                
            plot(framesVector(trigger:expInterval(end)), latFit(trigger:expInterval(end)), 'LineWidth', 2, 'Color', 'c') 
            line(([expFrame expFrame].*frameInt), [-50 200], 'Color', 'r')
                
            else
                
            end
                
        ylim([-50 200])
        
%         [ptAngle, ptAngleFitEval, curvF, ptMax, ptMin] = curvature(trackingData, onset, offset, nFrames, doFlip);
        
        % ask whether to keep file
        
        keep(esc) = input('Keep this trial (0 for no, 1 for yes)?');

        % save results structure as m-file

        newFileName = strcat(date, '_', 'larva_', sprintf('%d',larva) , '_', 'trial_', sprintf('%d',trial));
        
        if keep(esc) == 1
        save([newFolder newFileName],'date', 'rdtrack', 'larva', 'trial', 'trackingData', 'tailAngle', 'tailAngleFiltered',... 
            'tailAngleFitEval', 'fishPosition', 'headDirection', 'interpTailAngle', 'angVel', 'angVelFitEval',...
            'onset', 'offset', 'latency', 'consPeaks', 'isEscape', 'derFrame', 'fiveFrame', 'expFrame', 'xIntFrame', 'sdFrame', 'pAscending', 'latencyMeth')
        else
        end
        
        close(f(esc))
%         close(curvF)
        
        % cleanup
        
        clear tailAngle
        clear tailAngleFiltered
        clear tailAngleFitEval
        clear interpTailAngle
%         clear onset
%         clear offset

        catch
            disp(['could not interpolate' file])
        end

    % if the file contains no data
        
    else
        disp(['insufficient data in ' file])
    end          
end

close(h)