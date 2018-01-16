function [ tailpos ] = rotateTail( tailpos ,angle)
    ny=size(tailpos,2);
    for i=1:ny,
        curang=atan(tailpos(2,i)/tailpos(1,i));
        curlength=sqrt(tailpos(2,i)^2+tailpos(1,i)^2);
        curang=curang+angle;
        newx=curlength*cos(curang);
        newy=curlength*sin(curang);
        tailpos(1,i)=newy;
        tailpos(2,i)=newx;
    end
end

