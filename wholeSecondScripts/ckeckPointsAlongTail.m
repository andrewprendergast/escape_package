function [  ] = ckeckPointsAlongTail( wholeSecond,cornerNum )
    xmoy=(wholeSecond(1,2)+wholeSecond(600,2))/2;
    ymoy=(wholeSecond(1,3)+wholeSecond(600,3))/2;
    viewWindow=110;
    subplot(2,4,cornerNum);
    nT=(size(wholeSecond,2)-5)/2;
    for i=1:649,
        x=zeros(1,nT);
        y=zeros(1,nT);
        for j=1:nT,
            x(1,j)=wholeSecond(i,4+2*j);
            y(1,j)=wholeSecond(i,4+2*j+1);
        end
        plot(x,y,'.');
        axis([xmoy-viewWindow xmoy+viewWindow ymoy-viewWindow ymoy+viewWindow]);
        if ( (i<160) | (i>200) )
            title(strcat('Current Frame: ',int2str(i)));
            pause(0.01);
        else
            title(strcat('Press Any Key to go to the Next Frame; Current Frame: ',int2str(i)));
            waitforbuttonpress;
        end
    end
end