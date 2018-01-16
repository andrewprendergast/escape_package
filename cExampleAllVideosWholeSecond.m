percentageFramesTracked={};
indpft=1;
for i=1:4, %adjust according to number of sets in the experiment
    for j=1:5, %trial number
        for k=1:4, % well number
            try
            videoName=strcat(int2str(i),'-',int2str(j));
            numWell=int2str(k);
            wholeSecond=createWholeSecondParameters(videoName,numWell,'');
            wholeSecondSmoothed=createWholeSecondParameters(videoName,numWell,'Smoothed');
            save(strcat('WholeSecondData/',videoName,'_',numWell,'.mat'),'wholeSecond','wholeSecondSmoothed');
            percentageFramesTracked{indpft}={};
            percentageFramesTracked{indpft}{1}=videoName;
            percentageFramesTracked{indpft}{2}=numWell;
            percentageFramesTracked{indpft}{3}=(sum(wholeSecond(:,6))/650)*100;
            indpft=indpft+1;
            end
        end
    end
end
save(strcat('WholeSecondData/percentageFramesTracked.mat'),'percentageFramesTracked','percentageFramesTracked');