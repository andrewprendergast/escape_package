clear all
close all
[fileName,pathName] = uigetfile('*.mat','MultiSelect','on');
[m,nFiles] = size(fileName);
clear m

newFolder = strcat(pathName, 'edit/');
mkdir(newFolder);

for i = 1:nFiles
    if iscell(fileName)
        file = [pathName fileName{i}];
    else
        file = [pathName fileName];
    end
    
    load(file);
    
    % here's where changes can be made
date = '2016_01_20';
    % end change block
    
    % save
    
    save([newFolder fileName{i}],'date', 'rdtrack', 'larva', 'trial', 'trackingData', 'tailAngle', 'tailAngleFiltered',... 
            'tailAngleFitEval', 'fishPosition', 'headDirection', 'interpTailAngle', 'angVel', 'angVelFitEval',...
            'onset', 'offset', 'latency', 'consPeaks', 'isEscape');
        
    clear latency
    clear onset
    clear offset
    clear consPeaks
    clear fishPosition
    
end