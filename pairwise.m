function [pval] = pairwise(input, grp1, grp2)

    grp1subsetini = input(input(:,5)==grp1,:);
    grp2subsetini = input(input(:,5)==grp2,:);
    
    % dorsal or ventral is pulled out here
    
    pop = 2
    
    grp1subset = grp1subsetini(grp1subsetini(:,2)==pop,:);
    grp2subset = grp2subsetini(grp2subsetini(:,2)==pop,:);
    
    pval = ranksum(grp1subset(:,3), grp2subset(:,3));
end