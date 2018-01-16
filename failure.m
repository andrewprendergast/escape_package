genCount = zeros(nExp, nGrps);
attemptCount = zeros(nExp, nGrps);

endBlock = unique(modMat);
startBlock = endBlock+1;
for i=1:length(nLarvaeQuery)
endBlock(i+1) = sum(nLarvaeQuery(1:i));
end
endBlock=endBlock(2:end);

incVect = ~isnan([escapes.latency]'); % inclusion criteria definitions

for i = 1:nExp
    
    % this block gives the number of possible tracked trials per genotype per experiment
    
    for j = min(unique([escapes.genotype])):max(unique([escapes.genotype])) 
        attemptCount(i,j+1) = nLarvaeQuery(i)*5/2;
        clear tempGen
    end
        
    % this block gives the number of successfully tracked trials per genotype per experiment
    % trials are lost here due to escape failures, poor tracking, or other user exclusion
    
    for j = min(unique([escapes.genotype])):max(unique([escapes.genotype]))
        tempGen = [escapes([escapes.expNum]==i).genotype];
        genCount(i,j+1) = sum(tempGen==j);
        clear tempGen
    end
    
    % this block gives the number of escapes that pass inclusion criteria
    % trials are lost here due to escape failures as defined by user
    
    for j = min(unique([escapes.genotype])):max(unique([escapes.genotype]))
        
        tempGen = [escapes([escapes.expNum]==i).genotype];
        tempInc = [incVect([escapes.expNum]==i)];
        
        incCount(i,j+1) = sum(tempInc(tempGen==j));
        
        clear tempGen
    end
    
end

trackRatio = genCount./attemptCount
trackMeans = nanmean(trackRatio,1)

incRatio = incCount./genCount
incMeans = nanmean(incRatio,1)

% this block finds the number of larvae

tempArray = [incVect, [escapes.larvaNew]' [escapes.genotype]'];
idx = find(tempArray(:,1)==1);
incArray = tempArray(idx,:);

for j = min(unique([escapes.genotype])):max(unique([escapes.genotype]))
    incLarvae(j+1) = length(find(grpstats(incArray(:,3), incArray(:,2))==j));
end

incLarvae