function [a] = completeZeros(a)
    n=size(a,1);
    cur=1;
    while ((cur<n)&&(a(cur,1)==0))
        cur=cur+1;
    end
    firstval=a(cur,1);
    for i=1:cur
        a(i,1)=firstval;
    end
    if (cur<n)
        cur=max(cur,2);
        for i=cur:n,
            if ((a(i,1)==0)&&(i>1))
                a(i,1)=a(i-1,1);
            end
        end
    end
end