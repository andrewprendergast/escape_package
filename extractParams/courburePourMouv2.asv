function [courbure] = courburePourMouv2( z, numMouv, affiche )
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
    courbure=courbure.*(abs(courbure)<0.2);%0.08);
    courbure(isnan(courbure))=0;
    courbure = medfilt2(courbure, [7 9]);%[3 3]);
    
    m=size(courbure,2);
    n=size(courbure,1);
    courbure2=zeros(n,m);
    ab=1:n;
    ab=ab';
    ab2=1:n;
    ab2=ab2';
    for i=1:n-1,
        k=n-i+1;
        same=1;
        for j=1:m,         
            c1=courbure(k,j);
            c2=courbure(k-1,j);
            c1=floor(c1*1000000);
            c2=floor(c2*1000000);
            if (c1==c2)
                0;
            else
                same=0;
            end
        end
        if (same)
            ab(k,:)=[];
            courbure(k,:)=[];
        end
    end
    
    if (size(courbure,1)>1)
        for j=1:m,
            [curve,goodness]=fit(ab,courbure(:,j),'smoothingspline');
            courbure2(:,j)=curve(ab2);
        end
        if (affiche)
            figure(numMouv+5000);
            imagesc(courbure2)
        end
    else
        1222
        courbure=courburePourMouv( z, numMouv, affiche );
    end
    
end