function [ img ] = markRed( img )
    for i=190:210
        for j=190:210
            img(i,j,1)=255;
            img(i,j,2)=0;
            img(i,j,3)=0;
        end
    end
end

