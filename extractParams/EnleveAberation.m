function [ output ] = EnleveAberation( input )
    s=size(input);
    r=s(1);
    for i=2:r
        if (abs(input(i)-input(i-1))>1.6)
            input(i)=input(i-1);
        end
    end
    output=input;
end

