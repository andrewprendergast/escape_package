wt_vect = reshape(block(1).hemi, 1, numel(block(1).hemi));
mut_vect = reshape(block(3).hemi, 1, numel(block(3).hemi));

binWidth = [1:50]

figure()

% s1 = subplot(2,1,1)
% histf(wt_vect,binWidth, 'FaceColor', 'b', 'FaceAlpha', 0.5)
% s2 = subplot(2,1,2)
% histf(mut_vect,binWidth, 'FaceColor', 'r', 'FaceAlpha', 0.5)

h1 = hist(wt_vect,binWidth);
h2 = hist(mut_vect,binWidth);

h1 = h1/sum(h1);
h2 = h2/sum(h2);

subplot(2,1,1)
bar(h1)
subplot(2,1,2)
bar(h2)

% histf(wt_vect,binWidth, 'FaceColor', 'b', 'FaceAlpha', 0.5)
% hold on
% histf(mut_vect,binWidth, 'FaceColor', 'r', 'FaceAlpha', 0.5)

% linkaxes([s1 s2], 'xy')