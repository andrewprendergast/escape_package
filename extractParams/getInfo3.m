function [output] = getInfo3( parameters, b )
    matParam=parameters.matParam6w1;
    inter=b.intervalles;
    n=size(inter,1);
    data=b.data;
    
    for i=1:n
        
        min_per_a=matParam(6,i);%MCD
        max_angle=matParam(5,i);
        duration=matParam(4,i)-matParam(3,i);
        max_ampA1=matParam(7,i);
        max_ampA2=matParam(8,i);
        max_ampA3=matParam(9,i);
        max_ampA4=matParam(10,i);
        max_ampA5=matParam(11,i);
        max_ampA6=matParam(12,i);
        quot_amp2=matParam(13,i);
        
        output(i,1)=matParam(7,i);%nb_oscillation;
        output(i,2)=0;%per_min_c;
        output(i,3)=matParam(8,i);%per_mean_signif;
        output(i,4)=0;%per_min_signif;
        output(i,5)=0;%max_curv_fin;
        output(i,6)=min_per_a;
        output(i,7)=max_angle;
        output(i,8)=duration;
                
        deb=inter(i,4);
        fin=inter(i,5);
        
        angle=data(deb:fin,123);
        angle2=angle;
        
        m=min(angle2);
        count=0;
        while ((m<0.5)&&(count<80))
            angle2=angle2+0.1;
            angle2=mod(angle2,2*pi);
            m=min(angle2);
            count=count+1;
        end

        ind=find(angle2>2*pi);
        angle2(ind)=[];
        angle2=mod(angle2,2*pi);
        angle2=medfilt2(angle2,[7 1]);

        M=max(angle2);
        m=min(angle2);

        balaye_angle=M-m;

        output(i,9) =balaye_angle;
        
        
        ang=data(deb:fin,81);
        m=min(ang);
        M=max(ang);
        if ((m>=0)&&(M>=0))
            tourne=0;
        elseif ((m<=0)&&(M<=0))
            tourne=0;
        else
            a=min(-m,M);
            A=max(-m,M);
            tourne=1-(a/A);
        end      
        output(i,10)=tourne;       
        
        %distance=0;
        
        pos=data(deb:fin,121:122);
        distance=arclength(pos(:,1), pos(:,2), 'linear');
        %r=size(pos,1);
        %for j=1:r-1
        %    distance=distance+sqrt( (pos(j+1,1)-pos(j,1))^2 +...
        %        (pos(j+1,2)-pos(j,2))^2);
        %end
        
        output(i,11)=distance;
        
        output(i,12)=distance/duration;
        
    end
    
end