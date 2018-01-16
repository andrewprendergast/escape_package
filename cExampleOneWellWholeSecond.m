clear all;
close all;

%videoName='1-2'; % Name of the video
%numWell='3'; % Can '1', '2', '3' or '4'

videoName='1-4'; % Name of the video
numWell='2'; % Can '1', '2', '3' or '4'

% First Line in graph: Whole Second UNsmoothed
wholeSecond=createWholeSecondParameters(videoName,numWell,'');
figure('name','Check Of Whole Second Parameters Calculation','units','normalized','outerposition',[0 0 1 1]);
subplot(2,4,1);
plot(wholeSecond(:,2),wholeSecond(:,3));
subplot(2,4,2);
plot(wholeSecond(:,4));
subplot(2,4,3);
plot(wholeSecond(:,5));

% Second Line in graph: Whole Second SMOOTHED
wholeSecond2=createWholeSecondParameters(videoName,numWell,'Smoothed');
subplot(2,4,5);
plot(wholeSecond2(:,2),wholeSecond2(:,3));
subplot(2,4,6);
plot(wholeSecond2(:,4));
subplot(2,4,7);
plot(wholeSecond2(:,5));

%Points along the tail UNsmoothed
ckeckPointsAlongTail( wholeSecond,4);

%Points along the tail Smoothed
ckeckPointsAlongTail( wholeSecond2,8);
