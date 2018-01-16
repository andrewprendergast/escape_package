numBouts=NaN(80,2);
r=1;
for i=1:10, %adjust according to number of sets in the experiment
    for j=1:2, %trial number
        for k=1:8, % well number
            try
            videoName=strcat(int2str(i),'-',int2str(j));
            numWell=int2str(k);
            mouvements=detectedMouvements(videoName,numWell);
            totMouv=length(mouvements(:,1));
            
            for m=1:totMouv
            numMouv=m;
            sswimdata(r+m-1).fishID = (i-1)*8+k;%fishID
            sswimdata(r+m-1).set = i;
            sswimdata(r+m-1).trial = j;
            sswimdata(r+m-1).movement = m;
            globparam=extractParams(videoName,numWell,numMouv,'globparam');
            sswimdata(r+m-1).deb=mouvements(numMouv,1);
            sswimdata(r+m-1).fin=mouvements(numMouv,2);
            sswimdata(r+m-1).nBends=globparam(1,1);
            sswimdata(r+m-1).TBF=globparam(1,2);
            sswimdata(r+m-1).duration=globparam(1,3)*1000; %in ms
            sswimdata(r+m-1).hDirect=globparam(1,4);
            sswimdata(r+m-1).distance=globparam(1,5);
            sswimdata(r+m-1).speed=globparam(1,6);
            
            %sswimdata(r+m-1).globparam=extractParams(videoName,numWell,numMouv,'globparam');
            %sswimdata(r+m-1).angle=extractParams(videoName,numWell,numMouv,'angle');
            sswimdata(r+m-1).angle=extractParams(videoName,numWell,numMouv,'angleSmoothed');
            
            sswimdata(r+m-1).headposition=extractParams(videoName,numWell,numMouv,'headposition');
                flyfish=diff(sswimdata(r+m-1).headposition); %find fish that jump positions unnaturally and fish that actually not moving
                for f=1:length(flyfish(:,1))                 %sometimes ZebraZoom combines 2 movements into 1, we need to throw these away
                    flyfish(f,3)=sqrt((flyfish(f,1)^2)+(flyfish(f,2)^2));
                end
                stillfish=find(flyfish(:,3)==0);
                still = [0 cumsum(diff(stillfish')~=1)];
                [M F]=mode(still);                                         %the fish's location should not jump over a full body length (4.2 mm)
            sswimdata(r+m-1).error=~isempty(find((flyfish(:,3))>5.5|F>=5)); % F decides how many consecutive frames with speed=0 defines 'still'
            
            %sswimdata(r+m-1).headposition=extractParams(videoName,numWell,numMouv,'headpositionSmoothed');
            sswimdata(r+m-1).heading=extractParams(videoName,numWell,numMouv,'headingSmoothed');
            %sswimdata(r+m-1).curvature=extractParams(videoName,numWell,numMouv,'curvature');
            genocheck=mod( (i-1)*8+k,4);
            geno=ismember(genocheck,[0,2]);
            sswimdata(r+m-1).geno = geno; %GENOTYPE
            sswimdata(r+m-1).mouvements=detectedMouvements(videoName,numWell);
            if m>1
            sswimdata(r+m-1).IBI = (sswimdata(r+m-1).mouvements(m,1)-sswimdata(r+m-1).mouvements(m-1,2))*4; %interbout interval, 250 fps in ms
            else
            sswimdata(r+m-1).IBI =NaN;
            end
            if rad2deg(max(sswimdata(r+m-1).angle))<50
                sswimdata(r+m-1).cat=1; %slow forward swim
            else
                sswimdata(r+m-1).cat=2; %routine turn
            end
            
            sswimdata(r+m-1).expNum=1; %manually change this
            end
            
            numBouts((i-1)*8+k,j)=numMouv;
            r=r+totMouv;
            
            end
        end
    end
end
