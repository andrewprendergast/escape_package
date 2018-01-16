videoName='10-3'; % Name of the video
numWell='2'; % Can '1', '2', '3' or '4'
numMouv=1;% !!! : Put this to 2 for the second movement
viewWindow=110;

close all;
figure('name','Press Any Key For Next Frame','units','normalized','outerposition',[0 0 1 1]);

tailpos=extractParams(videoName,numWell,numMouv,'tailpos');
tailposS=extractParams(videoName,numWell,numMouv,'tailposSmoothed',8);
video=extractParams(videoName,numWell,numMouv,'video3');

n=size(tailpos,2);
cdeb=tailpos{1}{2};
cfin=tailpos{n}{2};
xmoy=(cdeb(1,1)+cfin(1,1))/2;
ymoy=(cdeb(1,2)+cfin(1,2))/2;

tp=0;
tpS=0;
for i=1:n,
    pos=tailpos{i}{2};
    x=pos(1,1);
    y=pos(1,2);
    angle=pos(1,3);
    
    if ( (size(tailpos{i}{1},2)>1) && (size(tailposS{i}{1},2)>1) )
        tp=tailpos{i}{1};
        tpS=tailposS{i}{1};
    end
    if ( tp~=0 )
        if (tpS~=0)
            tp=rotateTail(tp,angle);
            tpS=rotateTail(tpS,angle);

            subplot(1,2,1);
            plot(x+tpS(1,:),y+tpS(2,:),'r');
            hold on;
            plot(x+tp(1,:),y+tp(2,:),'.');
            hold off;
            axis([xmoy-viewWindow xmoy+viewWindow ymoy-viewWindow ymoy+viewWindow]);
            title(strcat('Press Any Key For Next Frame'));
            text(xmoy-viewWindow+3,ymoy-viewWindow+7,'Blue Point: UNsmoothed; Red Line: Smoothed Points');

            subplot(1,2,2);
            image(video{i});
            title(strcat('Press Any Key For Next Frame'));

            waitforbuttonpress;
        end
    end
end

