function [aa] = Smooth( debut, fin, a, datapos )
    aa=a;
    aa(debut:fin,datapos)=EnleveAberation(aa(debut:fin,datapos));
    inter=debut:fin;
    [curve,goodness]=fit(inter',aa(debut:fin,datapos),'smoothingspline');
    s=curve(inter');
    [curve2,goodness]=fit(inter',s,'smoothingspline');
    ss=curve2(inter');   
    [curve3,goodness]=fit(inter',ss,'smoothingspline');
    sss=curve3(inter');    
    %aa(debut:fin,81)=sss; 
	aa=sss;
end