function [opt, sr] = makePlayList(sr, gap_len, pre_filter, normalize, fileList, loop)
%MAKELONGPLAYLIST: generate a long wav file that includes all audio samples
%in a folder
% 
%   sr: sampling rate for files (Hz)
%   gap_len: the gap between audio files (s)
%   pre_filter: apply filter before playing 
%   normalize: normalization to -1,1 before playing? 
%   fileList: a file list generated from dir() (e.g., dir(kevinv3_*.wav))
%   loop: # of loop times

    % generate empty signal
    mute_sec = zeros([gap_len*sr, 1]);

    % mute 2*gap_len (s) at the beginning
    opt = [mute_sec; mute_sec];
    
    if isempty(fileList) 
        opt = 0;
        sr = 0;
        disp('ERR: list len = 0')
        return
    end
    
    for i = 1:length(fileList)
        file = fileList(i);
        [im, sr] = audioread([file.folder, '/', file.name]);

%         filenamePattern = [folder, 'kevinv3_', num2str(i), '_*.wav'];
%         files = dir([filenamePattern]);

                
        if normalize == 1
            im = audioNormalization(im, 1);
        end

        if length(pre_filter) > 1
            im_filtered = filter(pre_filter, 1, im);
            im_filtered = audioNormalization(im_filtered, 1);
            im = im_filtered;
        end
        
        for j = 1:loop
            opt = [opt; mute_sec; im];
        end
        opt = [opt; mute_sec];

    end

    % '\' for windows machine
    writeName = split(file.folder, '\');
    writeName = [file.folder, '\playall_' writeName(length(writeName)) '.wav'];
    audiowrite([writeName{:}], opt, sr)

end

