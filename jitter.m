c=get(gca,'Children'); %The second handle is that for the first plotted data
adjFactor = 0.4;

for jitterant = 1:length(c)

    x=get(c(jitterant),'XData'); %Retrieve the X data for the black points
    
    %Add uniformly distributed random numbers to the data and re-plot
    
    r=rand(size(x));
    r=r-mean(r);
    set(c(jitterant),'XData',x+r.*(adjFactor))
    
end