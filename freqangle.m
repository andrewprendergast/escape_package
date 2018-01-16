fAmp = figure();
set(fAmp, 'Position', [1 1 1200 1200]);

[m,n]=size([block(1).posBends]);
for i=1:nGrps
    for j = 1:nFiles
    freqAngle(:,i)=reshape(block(i).posBends(:,:)',[m*n 1]);
    freqAngle(:,i+nGrps)=reshape(block(i).hemi(:,1:2:end)',[m*n 1]);     %because hemicycle
    freqAngle(:,i+2*nGrps)=reshape(block(i).negBends(:,:)',[m*n 1]);     %500ms/hemicycle = freq
    freqAngle(:,i+3*nGrps)=reshape(block(i).hemi(:,2:2:end)',[m*n 1]);
    freqAngle(:,i+4*nGrps)=reshape([block(i).posBendsframe(:,:)'],[m*n 1]);
    freqAngle(:,i+5*nGrps)=reshape([block(i).negBendsframe(:,:)'],[m*n 1]);
    
    %subplot(2,nGrps,i)
    %ax=gca;
    %xlim([0 40])
    %ylim([0 140])
    %gscatter(freqAngle(:,i+nGrps),freqAngle(:,i),freqAngle(:,i+4*nGrps))

    %subplot(2,nGrps,i+nGrps)
    %ax=gca;
    %xlim([0 40])
    %ylim([-120 0])
    %gscatter(freqAngle(:,i+3*nGrps),freqAngle(:,i+2*nGrps),freqAngle(:,i+5*nGrps))

    end
end

    subplot(2,2,1)
    gscatter(freqAngle(:,3),freqAngle(:,1),freqAngle(:,9))
    ax=gca;
        xlim([0 40])
        ylim([0 140])
    hold on
    jitter
   
    subplot(2,2,3)    
    gscatter(freqAngle(:,7),freqAngle(:,5),freqAngle(:,11))
    ax=gca;
        xlim([0 40])
        ylim([-120 0])
        hold on
        jitter
        
    subplot(2,2,2)
    gscatter(freqAngle(:,4),freqAngle(:,2),freqAngle(:,10))
    ax=gca;
        xlim([0 40])
        ylim([0 140])
    hold on
    jitter
    
    subplot(2,2,4)
    gscatter(freqAngle(:,8),freqAngle(:,6),freqAngle(:,12))
    ax=gca;
        xlim([0 40])
        ylim([-120 0])
    hold on
    jitter