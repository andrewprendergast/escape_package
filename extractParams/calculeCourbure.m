function [courbure] = calculeCourbure( b, num_frame, affiche )
    a=b.data;
    x1=a(num_frame,1:40);
    x2=a(num_frame,41:80);
    j=40;
    while ( (x1(j)==x1(j-1)) && (x2(j)==x2(j-1)) && (j>2) )
        j=j-1;
    end
    length=j;
    pas=(length)/50;%/(40*10);
    %tail for frame num_frame
    if (affiche)
        figure(1)
        plot(a(num_frame,41:80),a(num_frame,1:40))
    end
    
    if ((length>3)&&(~isnan(a(num_frame,41)))&&(~isinf(a(num_frame,41))))
        [curve,goodness]=fit((1:length)',a(num_frame,41:(40+length))','smoothingspline');
        [curve2,goodness2]=fit((1:length)',a(num_frame,1:length)','smoothingspline');%'poly7');
        %tail for frame num_frame after smoothing and spline fitting
        if (affiche)
            figure(2)
            plot(curve(1:pas:length),curve2(1:pas:length),'.')
        end
        y=curve2(1:pas:length);
        x=curve(1:pas:length);
        ydiff=diff(y);%./pas;
        ydiff2=diff(ydiff);%./pas;
        xdiff=diff(x);%./pas;
        xdiff2=diff(xdiff);%./pas;
        courbure=xdiff2;
        s=size(courbure);
        l=s(1);
        long=zeros(l,1);
        av=0;
        for i=1:l
            num=xdiff(i)*ydiff2(i)-ydiff(i)*xdiff2(i);
            den=(xdiff(i)^2+ydiff(i)^2)^1.5;
            courbure(i)=num/den;
            long(i,1)=av+sqrt((x(i+1)-x(i))*(x(i+1)-x(i))+(y(i+1)-y(i))*(y(i+1)-y(i)));
            av=long(i,1);
        end
        long=long./max(long);
        %courbure for frame num_frame (calculated from the smoothed spline)
        if (affiche)
            figure(3)
            plot(1:pas:length-2*pas,courbure)
            figure(4)
            plot(long,courbure)
        end
    else
        courbure=0;
    end
    
end