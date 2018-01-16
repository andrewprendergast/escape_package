function [ wholeSecond ] = createWholeSecondParameters( videoName,numWell,smoothed)
    
    wholeSecond=zeros(650,6);
    for i=1:650,
        wholeSecond(i,1)=i;
        %wholeSecond(i,6)=1;
    end
    
    mouvements=detectedMouvements(videoName,numWell);
    
    if ((size(mouvements,1)~=0)&&(~( (mouvements(1,1)==1)&&(mouvements(1,2)==1) )))
        for numMouv=1:size(mouvements,1),
            deb=mouvements(numMouv,1);
            fin=mouvements(numMouv,2);
            headposition=extractParams(videoName,numWell,numMouv,strcat('headposition',smoothed));
            heading=extractParams(videoName,numWell,numMouv,strcat('heading',smoothed));
            angle=extractParams(videoName,numWell,numMouv,strcat('angle',smoothed));
            wholeSecond(deb:fin,2:3)=headposition;
            wholeSecond(deb:fin,4)=heading;
            wholeSecond(deb:fin,5)=angle;
            % Points Along the Tail calculation below
            if (strcmp(smoothed,'Smoothed'))
                tailPoints=extractParams(videoName,numWell,numMouv,'tailposSmoothed',8);
            else
                tailPoints=extractParams(videoName,numWell,numMouv,'tailpos');
            end
            tp=0;
            for i=deb:fin,
                    pos=tailPoints{i-deb+1}{2};
                    x=pos(1,1);
                    y=pos(1,2);
                    angle=pos(1,3);
                    if (size(tailPoints{i-deb+1}{1},2)>1)
                        tp=tailPoints{i-deb+1}{1};
                    end
                    if (tp~=0)
                        tp=rotateTail(tp,angle);
                        tailPointsNb=size(tp,2);
                        for j=1:tailPointsNb,
                            wholeSecond(i, 5+(2*j)-1)= x+tp(1,j);
                            wholeSecond(i, 5+ 2*j   )= y+tp(2,j);
                        end
                    end
            end
            
        end
        wholeSecond(:,2)=completeZeros(wholeSecond(:,2));
        wholeSecond(:,3)=completeZeros(wholeSecond(:,3));
        wholeSecond(:,4)=completeZeros(wholeSecond(:,4));
        % Points Along the Tail calculation below
        for j=1:2*tailPointsNb,
            wholeSecond(:,5+j)=completeZeros(wholeSecond(:,5+j));
        end   
    end
    
    if (exist(strcat(videoName,'/',videoName,'_',numWell,'/','NoTrack0.txt'), 'file') == 2)
        notrack=load(strcat(videoName,'/',videoName,'_',numWell,'/','NoTrack0.txt'));
    else
        notrack=[0];
    end
    if (size(notrack,1)>1)
        for i=1:size(notrack,1),
            ind=notrack(i,1);
            wholeSecond(ind,6)=0;
        end
    end
    
end