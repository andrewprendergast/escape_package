function [ p ] = putScale( p )

	freq=250; %665.6; %337;
	mmperpixel=0.0629;%0.066;
	
    i=1;
    t=p(:,i);
    t=t./2;
    p(:,i)=t;

    i=3;
    t=p(:,i);
    t=freq./(2*t);
    p(:,i)=t;
    
    i=6;
    t=p(:,i);
    t=freq./(2*t);
    p(:,i)=t;
    
    i=8;
    t=p(:,i);
    t=t./freq;
    p(:,i)=t;    
    
    i=11; 
    t=p(:,i);
    t=t.*mmperpixel;
    p(:,i)=t;
    
    i=12;
    t=p(:,i);
    t=t.*(mmperpixel*freq);
    p(:,i)=t;
    
    i=7;
    t=p(:,i);
    t=t*(360/(2*pi));
    p(:,i)=t;
    
    i=9;
    t=p(:,i);
    t=t*(360/(2*pi));
    p(:,i)=t;    
    
end