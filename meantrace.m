[m,n]=size([block(1).posBends]);
for i=1:nGrps   
    for j=1:n
    indMeansHemi=nanmean(block(i).hemi);
    xscale=cumsum(indMeansHemi);
    yscale(i,j*2)=block(i).indMeansNeg(:,j);
    yscale(i,j*2-1)=block(i).indMeansPos(:,j);
    WTcurve=fit(xscale',[yscale(1,:)]','smoothingspline');
    BTcurve=fit(xscale',[yscale(2,:)]','smoothingspline');
    end
end

plot(WTcurve,'r')
hold on
plot(BTcurve,'b')