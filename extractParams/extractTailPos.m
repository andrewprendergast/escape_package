function [tail] = extractTailPos( b, num_frame, smooth, resizeNbPoints )
   resizeNbPoints=8;

    a=b.data;
    x2=a(num_frame,1:40);
    x1=a(num_frame,41:80);
    j=40;
    while ( (x1(j)==x1(j-1)) && (x2(j)==x2(j-1)) && (j>2) )
        j=j-1;
    end
    length=j;
    
    if ((length>3)&&(~isnan(a(num_frame,41)))&&(~isinf(a(num_frame,41))))        
        if  (strcmp(smooth,'Smoothed'))
            tail=zeros(2,resizeNbPoints);
            [curveX,goodness]=fit((1:length)',a(num_frame,41:(40+length))','smoothingspline');
            [curveY,goodness2]=fit((1:length)',a(num_frame,1:length)','smoothingspline');
            pas=(length)/resizeNbPoints;
            tail(1,:)=curveX(1:pas:length);
            tail(2,:)=curveY(1:pas:length);
        else
            tail=zeros(2,length);
            tail(1,:)=a(num_frame,41:(40+length))';
            tail(2,:)=a(num_frame,1:length)';
        end
    else
        tail=0;
    end
    
end