function parsePlayList(path_to_file, find_head_threshold, sr, gap_len, post_filter, normalize, fileList, loop, needPlotToFindHead)
% Parse recorded file. 

%   path_to_file: path to the recorded file
%   find_head_threshold: the amplitude threshold to find the start point in
%   the long recoreded file.
%   folder: a folder with clips to be played
%   sr: sampling rate for played files (Hz)
%   gap_len: the gap between audio files (s)
%   post_filter: apply filter before saving
%   normalize: normalization to -1,1 before playing? 
%   fileList: a file list generated from dir() (e.g., dir(kevinv3_*.wav))
%   loop: # of loop times

    [rec, rec_sr] = audioread(path_to_file);
    rec = downsample(rec, rec_sr/sr);
    
    if needPlotToFindHead == 1
        plot(rec(1:rec_sr*10))
        prompt = 'What is the find_head_threshold value? ';
        find_head_threshold = input(prompt);

    end
    
    filename = split(path_to_file, '/');
    filename = char(filename(length(filename)));
    
    writeFolder = ['./parse/', filename(1:end-4), '/'];
    if ~isfolder(writeFolder)
        mkdir(writeFolder)
    end

    % find header, when the rec start
    for i = 1:length(rec)
        if rec(i) > find_head_threshold
            rec = rec(i-sr:end);
            break
        end
    end            

    st = 1;
    for i = 1:length(fileList)
        file = fileList(i);
        [im, sr] = audioread([file.folder, '/', file.name]);
 
        clip_size = length(im)+2*sr;
        
        for j = 1:loop
            ed = st+clip_size;
            clip = rec(st:ed);

            % normalization
            if normalize == 1
                clip = audioNormalization(clip, 1);
            end
            
            % Post filter
            if length(post_filter) > 1
                im_filtered = filter(pre_filter, 1, im);
                im_filtered = audioNormalization(im_filtered, 1);
                im = im_filtered;
            end

            audiowrite([writeFolder, file.name(1:end-4), '_repeat_', num2str(j), '.wav'], clip, sr)
            rec = rec(ed:end);
        end
        rec = rec(gap_len*sr:end);

    end
    
    disp(['Done, parsed files are saved to ', writeFolder])
end

