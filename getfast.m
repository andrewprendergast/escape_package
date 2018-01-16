escapesfast=escapes;
escapesslow=escapes;

for i=1:length(escapes)
for j=1:length(escapes(i).consPeaks(:,1))
   fastcrit=find(escapes(i).consPeaks(:,6)<650/60);
   slowcrit=find(escapes(i).consPeaks(:,6)>650/60);
   if isempty(slowcrit)==0
   fastcrit=find(fastcrit<slowcrit(1));
   end
end
  escapesfast(i).consPeaks=escapesfast(i).consPeaks(fastcrit,:);
  escapesslow(i).consPeaks=escapesslow(i).consPeaks(slowcrit,:);

if isempty(escapesfast(i).consPeaks)==0
        escapesfast(i).onset=escapesfast(i).consPeaks(1,1);
        escapesfast(i).offset=escapesfast(i).consPeaks(length(escapesfast(i).consPeaks(:,1)),1);
        escapesfast(i).duration = (sum(escapesfast(i).consPeaks(:,6))+escapesfast(i).consPeaks(1,6))*frameInt;
        
        tempMatf = escapesfast(i).fishPosition(escapesfast(i).onset:escapesfast(i).offset,:);
        if length(escapesfast(i).consPeaks(:,1))>1
        tempMatf(any(isnan(tempMatf),2),:) = nan;
        tempMatf(any(isnan(tempMatf),2),:) = [];
        escapesfast(i).distance = arclength(tempMatf(:,1), tempMatf(:,2), 'linear');
        else
             escapesfast(i).distance =nan;
        end
else
            escapesfast(i).onset=nan;
            escapesfast(i).offset=nan;
            escapesfast(i).duration=nan;
            escapesfast(i).distance =nan;
        
end
if isempty(escapesslow(i).consPeaks)==0 %there has to be at least one bout within regime
    %change onset and offset to within regime
        escapesslow(i).onset=escapesslow(i).consPeaks(1,1);
        escapesslow(i).offset=escapesslow(i).consPeaks(length(escapesslow(i).consPeaks(:,1)),1);
        escapesslow(i).duration = (sum(escapesslow(i).consPeaks(:,6))+escapesslow(i).consPeaks(1,6))*frameInt;
        if length(escapesslow(i).consPeaks(:,1))>1 %at least two bouts within regime or else no distance
        tempMats = escapesslow(i).fishPosition(escapesslow(i).onset:escapesslow(i).offset,:);
        tempMats(any(isnan(tempMats),2),:) = nan;
        tempMats(any(isnan(tempMats),2),:) = [];
        escapesslow(i).distance = arclength(tempMats(:,1), tempMats(:,2), 'linear');
        else
             escapesslow(i).distance =nan;
        end
 else
            escapesslow(i).onset=nan;
            escapesslow(i).offset=nan;
            escapesslow(i).duration=nan;
            escapesslow(i).distance =nan;
end

        %speed
        escapesfast(i).speed = escapesfast(i).distance/escapesfast(i).duration;
        escapesslow(i).speed = escapesslow(i).distance/escapesslow(i).duration;
        %nBends
        escapesfast(i).nBends = length(escapesfast(i).consPeaks(:,1))/2;
        if escapesfast(i).nBends==0
           escapesfast(i).nBends=nan;
        end
        escapesslow(i).nBends = length(escapesslow(i).consPeaks(:,1))/2;
        if escapesslow(i).nBends==0
           escapesslow(i).nBends=nan;
        end
        % average tailbeat frequency
        escapesfast(i).tbf = (1/(2*(nanmean(escapesfast(i).consPeaks(:,6).*frameInt))));
        escapesslow(i).tbf = (1/(2*(nanmean(escapesslow(i).consPeaks(:,6).*frameInt))));
    
end

escapesfast=escapesfast(find([escapesfast.latency]>0 & [escapesfast.isEscape]==1 & [escapesfast.latency] < cutoff));
escapesslow=escapesslow(find([escapesslow.latency]>0 & [escapesslow.isEscape]==1 & [escapesslow.latency] < cutoff));

