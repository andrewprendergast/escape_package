min=50;
max=70;

allPercentageGood=0;
ind=1;

figure(345);
for i=1:8,
    for j=1:5,
        for k=1:4,
            videoName=strcat(int2str(i),'-',int2str(j));
            numWell=int2str(k);
            mouvements=detectedMouvements(videoName,numWell);
            if ((size(mouvements,1)~=0)&&(~( (mouvements(1,1)==1)&&(mouvements(1,2)==1) )))
                n=size(mouvements,1);
                for numMouv=1:n,
                    notrack=extractParams(videoName,numWell,numMouv,'trackingQuality');
                    percentageGood=100-notrack*100;
                    allPercentageGood(ind,1)=percentageGood;
                    ind=ind+1;
                end
            end
        end
    end
end

hist(allPercentageGood);
b=allPercentageGood(:,1)>50;
good=sum(b);
tot=size(allPercentageGood,1);
(good/tot)*100

mean(allPercentageGood)
size(allPercentageGood,1)