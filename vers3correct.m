try

% first preallocate array with NaNs

trackingData = nan(nFrames, size(data.colheaders,2));

% look for missing data

% in tracking v 2.0, missed frames are not registered with a
% corresponding frame number, this corrects for that. also,
% tracking frame starts at 0 for some dumb reason in v 3.0, so this
% fixes that as well

data.data(:,3) = data.data(:,3)+1;
trackingFrames = data.data(:,3);
trackingData(trackingFrames, :) = data.data;

% additionally, sometimes v 3.0 drops the tail altogether to (0,0) we
% can replace these with NaNs

% collect general information

date = fileName{esc}(1:(strfind(fileName{esc}, '_e')-1)); % delivers experiment date
larva = str2num(fileName{esc}((strfind(fileName{esc}, '_e')+2):(strfind(fileName{esc}, '_t')-1)))+1; % delivers larva number, remove final +1 for tracking v 2.0
trial = str2num(fileName{esc}(((strfind(fileName{esc}, '_t'))+2):(strfind(fileName{esc}, '.txt')-1))); % delivers trial number
rdtrack = 3;

catch
    disp(['vers3correct failed ' file])
end