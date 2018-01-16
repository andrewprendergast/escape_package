totgp=NaN(5000,13);
numBouts=NaN(80,2);
r=1;
for i=1:4, %adjust according to number of sets in the experiment
    for j=1:2, %trial number
        for k=1:8, % well number
            try
            videoName=strcat(int2str(i),'-',int2str(j));
            numWell=int2str(k);
            mouvements=detectedMouvements(videoName,numWell);
            numMouv=length(mouvements(:,1));
            
            numBouts((i-1)*8+k,j)=numMouv;
            
            totgp(r:r+numMouv-1,1:6) = extractParams(videoName,numWell,numMouv,'globparam');
            totgp(r:r+numMouv-1,7)= 80+(i-1)*8+k; %fishID
            totgp(r:r+numMouv-1,8)= i; %set number
            totgp(r:r+numMouv-1,9)= j; %trial number
            
            genocheck=mod( (i-1)*8+k,4);
            geno=ismember(genocheck,[0,2]);
            totgp(r:r+numMouv-1,10)= geno; %GENOTYPE
            totgp(r:r+numMouv-1,11:12)=detectedMouvements(videoName,numWell);
            for l=1:numMouv-2
            totgp(r+l,13) = (totgp(r+l,11)-totgp(r+l-1,12))/250; %interbout interval, 250 fps
            end
            r=r+numMouv;
            end
        end
    end
end
