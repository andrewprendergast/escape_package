function out = extractParams(folder,numWell,numMouv,whatparam,resizeNbPoints)
    matb=load(strcat('data/',folder,'/',folder,'_',numWell,'/','b_',folder,'_',numWell,'.mat'));
    paramb=load(strcat('data/',folder,'/',folder,'_',numWell,'/','parameters_',folder,'_',numWell,'.mat'));
    intervalles=matb.intervalles;
    data=matb.data;
    param=paramb.param;
    matParam6w1=paramb.matParam6w1;
    out=0;
    if (strcmp(whatparam,'globparam'))
        out=getInfo3(paramb,matb);
        out=putScale(out);
        out=out(numMouv,[1 3 6 8 9 10 7 11 12]);
        out=out(1,[1 2 4 5 8 9]);
        %out(3)=1000*out(3);
    elseif (strcmp(whatparam,'angle'))
        deb=intervalles(numMouv,4);
        fin=intervalles(numMouv,5);
        out=data(deb:fin,81);
    elseif (strcmp(whatparam,'angleSmoothed'))
        deb=intervalles(numMouv,4);
        fin=intervalles(numMouv,5);
        out=Smooth(deb,fin,data,81);
    
    elseif (strcmp(whatparam,'headposition'))
        deb=intervalles(numMouv,4);
        fin=intervalles(numMouv,5);
        out=data(deb:fin,121:122);
    elseif (strcmp(whatparam,'heading'))
        deb=intervalles(numMouv,4);
        fin=intervalles(numMouv,5);
        data(deb:fin,123)=mod(data(deb:fin,123),2*pi);
        out=data(deb:fin,123);
    elseif (strcmp(whatparam,'headpositionSmoothed'))
        deb=intervalles(numMouv,4);
        fin=intervalles(numMouv,5);
        outx=Smooth2(deb,fin,data,121);
        outy=Smooth2(deb,fin,data,122);
        out=[outx,outy];
    elseif (strcmp(whatparam,'headingSmoothed'))
        deb=intervalles(numMouv,4);
        fin=intervalles(numMouv,5);
        data(deb:fin,123)=mod(data(deb:fin,123),2*pi);
        out=Smooth(deb,fin,data,123);
        
    elseif (strcmp(whatparam,'curvature'))
        out=courburePourMouv2(matb,numMouv,0);
    elseif (strcmp(whatparam,'tailpos'))
        out=extractTailPosOverTime(matb,numMouv,'noSmooth');
    elseif (strcmp(whatparam,'tailposSmoothed'))
        out=extractTailPosOverTime(matb,numMouv,'Smoothed',resizeNbPoints);
        
    elseif (strcmp(whatparam,'video'))
        figure(498);
        deb=intervalles(numMouv,2);
        fin=intervalles(numMouv,3);
        videoLength=648;
        marge=30;
        if (deb-30>0)
            deb2=deb-30;
        else
            deb2=1;
        end
        if (fin+marge<videoLength)
            fin2=fin+marge;
        else
            fin2=videoLength-1;
        end
        mov = VideoReader(strcat('data/',folder,'/',folder,'_',numWell,'/',folder,'_',numWell,'.avi'));
        for i=deb2:fin2
            currFrame = read(mov, i);
            if ((i>=deb)&&(i<=fin))
                currFrame=markRed(currFrame);
            end
            image(currFrame);
            pause(0.001);
        end
        close(498);
    elseif (strcmp(whatparam,'video2'))
        %figure(498);
        deb=intervalles(numMouv,2);
        fin=intervalles(numMouv,3);
        videoLength=648;
        marge=30;
        if (deb-30>0)
            deb2=deb-30;
        else
            deb2=1;
        end
        if (fin+marge<videoLength)
            fin2=fin+marge;
        else
            fin2=videoLength-1;
        end
        mov = VideoReader(strcat('data/',folder,'/',folder,'_',numWell,'/',folder,'_',numWell,'.avi'));
        for i=deb2:fin2
            currFrame = read(mov, i);
            if ((i>=deb)&&(i<=fin))
                currFrame=markRed(currFrame);
            end
            image(currFrame);
            pause(0.001);
        end
        
    elseif (strcmp(whatparam,'video3'))
        deb=intervalles(numMouv,2);
        fin=intervalles(numMouv,3);
        videoLength=648;
        mov = VideoReader(strcat('data/',folder,'/',folder,'_',numWell,'/',folder,'_',numWell,'.avi'));
        out={};
        for i=deb:fin
            currFrame = read(mov, i);
            out{i-deb+1}=currFrame;
        end    
    elseif (strcmp(whatparam,'trackingQuality'))
        deb=intervalles(numMouv,2);
        fin=intervalles(numMouv,3);
        %intervalles(numMouv,:)
        if (exist(strcat('data/',folder,'/',folder,'_',numWell,'/','NoTrack0.txt'), 'file') == 2)
            notrack=load(strcat('data/',folder,'/',folder,'_',numWell,'/','NoTrack0.txt'));
        else
            notrack=[0];
        end
        count=0;
        for i=1:size(notrack,1),
            if ( (deb<=notrack(i,1))&&(notrack(i,1)<=fin) )
                count=count+1;
            end
        end
        out=count/(fin-deb+1);
    end
end