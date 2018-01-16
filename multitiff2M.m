function M = multitiff2M(tiff)

tiffinfo = imfinfo(tiff);
% infos sur image, struct dont la taille est le nb de frames

numframes = 1:length(tiffinfo);
%nb de frames

M = zeros(tiffinfo(1).Height,tiffinfo(1).Width,['uint' num2str(tiffinfo(1).BitDepth)]);

for frame=numframes,
    curframe = im2uint8(imread(tiff,frame));
    M(:,:,frame-numframes(1)+1) = curframe;
end
