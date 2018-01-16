function [aa] = Smooth2( debut, fin, a, datapos )

    aa=a;
    %%aa(debut:fin,datapos)=EnleveAberation(aa(debut:fin,datapos));
    %angle2=mod(angle2,2*pi);
    aa=medfilt2(aa(debut:fin,datapos),[7 1]);%,[7 1]);

end