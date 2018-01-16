function [courbure] = courburePourMouv( z, numMouv, affiche )
    inter=z.intervalles;
    deb=inter(numMouv,4);
    fin=inter(numMouv,5);
    courbure=zeros(fin-deb+1,44);
    for i=deb:fin,
        c=calculeCourbure(z,i,0);
        l=length(c);
        for j=1:l,
            courbure(i-deb+1,j)=c(j,1);
        end
    end
    courbure=courbure.*(abs(courbure)<0.08);
    if (affiche)
        figure(numMouv);
        imagesc(courbure)
    end
end