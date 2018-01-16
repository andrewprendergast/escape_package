function [consPeaks] = anglepeaks(tailAngleFitEval, onset, offset, trigger, threshold)

% generate actual maxima/minima

[lMax, lMin] = peakdet(tailAngleFitEval(onset:offset), threshold); % adjust second value to change sensitivity

% see if this works

if isempty(lMax)==1
    lMax = [NaN NaN];
else
end

if isempty(lMin)==1
    lMin = [NaN NaN];
else
end

lMax(:,1) = lMax(:,1)+onset;
lMin(:,1) = lMin(:,1)+onset;

% delete any pre-stimulus maxima/minima

lMax(lMax(:,1)<trigger,:)=[];    
lMin(lMin(:,1)<trigger,:)=[];

% delete any early low-magnitude points (within 30 frames of onset)

lMax(lMax(:,1)<onset+30 & lMax(:,2)<10,:)=[];
lMin(lMin(:,1)<onset+15 & lMin(:,2)>-10,:)=[];

% interrogate sequentialness of peaks

lMax(:,3) = 0;
lMin(:,3) = 1;

consPeaks = [lMax; lMin];
consPeaks = sortrows(consPeaks);
consTest = diff(consPeaks(:,3));
consTest = abs(consTest); % consTest gives binary vector indicating adjacent peaks are alternating
consTest(length(consTest)+1) = 0;
consPeaks(:,4) = consTest;

[nConsPeaks, n] = size(consPeaks);

for i = 1:nConsPeaks
    if consPeaks(i,4)==1
    hemicycle(i) = consPeaks(i+1)-consPeaks(i);
    else
    hemicycle(i) = NaN;
    end
    
    % label peaks as being positive, negative, consecutive, non-consecutive
    
    if consPeaks(i,3)==0 && consPeaks(i,4)==1 % positive, consecutive
    peakLabel(i) = 1;
    elseif consPeaks(i,3)==1 && consPeaks(i,4)==1 % negative, consecutive
    peakLabel(i) = 2;
    elseif consPeaks(i,3)==0 && consPeaks(i,4)==0 % positive, non-consecutive
    peakLabel(i) = 3;
    elseif consPeaks(i,3)==1 && consPeaks(i,4)==0 % negative, non-consecutive
    peakLabel(i) = 4;
    else
    peakLabel(i) = NaN;
    end  
end

consPeaks(:,5) = peakLabel';
consPeaks(:,6) = hemicycle';


    

% by the end, consPeaks order is: frame, angle, binary up/down, binary
% consecutive, type label, hemicycle