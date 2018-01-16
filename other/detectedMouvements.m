function out = detectedMouvements(folder,numWell)
    matb=load(strcat('data/',folder,'/',folder,'_',numWell,'/','b_',folder,'_',numWell,'.mat'));
    intervalles=matb.intervalles;
    out=intervalles(:,2:3);
end