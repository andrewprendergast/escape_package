min=0;
max=100;

curGraph=1;
fignum=1;
for i=1:3, %12,
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
                    if ((percentageGood>=min)&&(percentageGood<=max))
                        angle=extractParams(videoName,numWell,numMouv,'angleSmoothed');
                        subplot(3,5,curGraph);
                        plot(angle);
                        title(strcat(int2str(percentageGood),'%'));
                        curGraph=curGraph+1;
                        if (curGraph>15)
                            curGraph=1;
                            fignum=fignum+1;
                            figure(fignum);
                        end
                    end
                end
            end
        end
    end
end