fAmp = figure();
set(fAmp, 'Position', [1 1 1200 1200]);

subplot(2,1,1)
for i=1:nFiles
scatter([block(1).hemi(i,1:2:end)],[block(1).posBends(i,:)],'r')
hold on
end
jitter
for i=1:nFiles
scatter([block(2).hemi(i,1:2:end)],[block(2).posBends(i,:)],'b')
hold on
end
jitter

subplot(2,1,2)
for i=1:nFiles
scatter([block(1).hemi(i,2:2:end)],[block(1).negBends(i,:)],'r')
hold on
end
jitter
for i=1:nFiles
scatter([block(2).hemi(i,2:2:end)],[block(2).negBends(i,:)],'b')
hold on
end
jitter

h = gcf;
axesObjs = get(h, 'Children');
dataObjs = get(axesObjs, 'Children');
xdata = get(dataObjs, 'XData');
ydata = get(dataObjs, 'YData');

