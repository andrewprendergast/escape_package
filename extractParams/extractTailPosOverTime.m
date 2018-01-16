function [tailposovertime] = extractTailPosOverTime( z, numMouv,smooth,resizeNbPoints )
    inter=z.intervalles;
    data=z.data;
    deb=inter(numMouv,4);
    fin=inter(numMouv,5);
    tailposovertime={};

    for i=deb:fin,
        if  (strcmp(smooth,'Smoothed'))
            c=extractTailPos(z,i,smooth,resizeNbPoints);
        else
            c=extractTailPos(z,i,smooth);
        end
        tailposovertime{i-deb+1}{1}=c;
        data(i,123)=data(i,123)+pi/2;
        tailposovertime{i-deb+1}{2}=data(i,121:123);
    end
    
end