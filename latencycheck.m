% set up masks

nGrps = length(groups);

for i = 1:nGrps
    mask{i} = logical([escapes.isEscape]) & [escapes.genotype]==groups(i) & [escapes.latency]<20;
end

% scatter latency by other variables

fCheck = figure();
set(fCheck, 'Position', [1 1200 1600 300]);

cmap = hsv(nGrps);

for i = 1:nAnalyses-1
%     f(i) = figure()
    for j = 1:nGrps
        s(i) = subplot(1,nAnalyses-1,i);
        scatter([escapes(mask{j}).latency], [escapes(mask{j}).(incAnalyses{i+1})], 10 , cmap(j,:))
        jitter
        title(strcat('latency x ', incAnalyses{i+1}))
        axis square
        hold on        
%         k = waitforbuttonpress        
    end
end