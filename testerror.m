for i=1:4323    
                flyfish=diff(sswimdata(i).headposition); %find fish that jump positions unnaturally and fish that actually not moving
                for f=1:length(flyfish(:,1))                 %sometimes ZebraZoom combines 2 movements into 1, we need to throw these away
                    flyfish(f,3)=sqrt((flyfish(f,1)^2)+(flyfish(f,2)^2));
                end
                stillfish=find(flyfish(:,3)==0);
                still = [0 cumsum(diff(stillfish')~=1)];
                [M F]=mode(still);                                      % the fish's location should not jump over a full body length (4.2 mm)
            sswimdata(i).error=~isempty(find((flyfish(:,3))>5.5|F>=5)); % F decides how many consecutive frames with speed=0 defines 'still'
end