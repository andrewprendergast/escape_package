% This script is going to look at all detected movements that have a 
% percentage of frames initially tracked (before smoothing) between 
% min% and max% (the two parameters just below)
min=70;
max=100;
% Try these different ranges:
% min=70 to max=100
% min=50 to max=70
% min=30 to max=50
% min=0 to max=30

figure('name',strcat('AngleAndVideo between ',int2str(min),' % and ',int2str(max),...
    ' % of good frame tracking'),...
    'units','normalized','outerposition',[0 0 1 1]);
for i=1:12,
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
                        subplot(1,2,1);
                        plot(angle);
                        axis([0 200 -2 2]);
                        text(0,-1.9,strcat('video:',videoName,' numWell:',numWell,' numMouv:',int2str(numMouv)));
                        title(strcat('good tracking: ',int2str(percentageGood),'% of frames'));
                        subplot(1,2,2);
                        extractParams(videoName,numWell,numMouv,'video2');
                        image(0);
                        pause(1);
                    end
                end
            end
        end
    end
end