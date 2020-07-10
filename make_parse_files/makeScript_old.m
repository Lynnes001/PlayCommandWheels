% clc;clear;

% old example of play and rec

%% Huge loop for all commands
%% play all script
clc;clear;

folder = ['./samples_allcommands/'];
sr = 22050;
mute2s = zeros([2*sr, 1]);


opt = [mute2s; mute2s];
compensate = 0;
for i = 1:20
    filenamePattern = [folder, 'kevinv3_', num2str(i), '_*.wav'];
    files = dir([filenamePattern]);
    if length(files) > 0
        disp(['Command ', num2str(i)])
        for index = 1:5        
            [im, sr] = audioread([files(index).folder, '/', files(index).name]);
            im = audioNormalization(im, 1);

            im_c = im;

            if compensate == 1
                % Go through compensation before OTA
                filterName = 'filter_chirp_rir_office_100cm_10000';
                S = load(['compensated_filter/', filterName, '.mat'], 'g_inv', 'SNR');
                SNR = S.SNR; g_inv = S.g_inv;
                tx_recovered = filter(g_inv, 1, im);
                tx_recovered = audioNormalization(tx_recovered, 1);
                im = tx_recovered;
            end


            loop = 10;
            for j = 1:loop
                opt = [opt; mute2s; im];
            end
            opt = [opt; mute2s; mute2s];

        end
    end
end

writeName = split(folder, '/');
writeName = ['play_' writeName(2) '.wav'];

if compensate == 1
    writeName = [folder, '../compensated_', filterName, '_' string(writeName)];
else
    writeName = [folder, '../', string(writeName)];
end
audiowrite([writeName{:}], opt, sr)



%% Parse recorded file. 

filename = 'kevinv3_lab_2m_all_2.wav';
[rec,rec_sr] = audioread(filename);
sr = 22050;
rec = downsample(rec,rec_sr/sr);

mute2s = zeros([2*sr, 1]);
folder = ['./samples_allcommands/'];
writeFolder = ['./rec/', filename(1:end-4), '/'];
% writeFolder = './compensation_with_commands_rec_100cm_1/command_compensated_booth_100cm/rec_150cm_compensated_booth_100cm_filter_20000_space/';

if ~isfolder(writeFolder)
    mkdir(writeFolder)
end

% find header
for i = 1:length(rec)
    if rec(i)>0.1
%         st = i-sr*0.5;
        rec = rec(i-sr:end);
        break
    end
end            
                
st = 1;
for i = 1:20
    filenamePattern = [folder, 'kevinv3_', num2str(i), '_*.wav'];
    files = dir([filenamePattern]);
    if length(files) > 0
        disp(['Command ', num2str(i)])
        for index = 1:5        
            [im, ~] = audioread([files(index).folder, '/', files(index).name]);
           
            clip_size = length(im)+2*sr;
            loop = 10;
            for j = 1:loop
                ed = st+clip_size;
                clip = rec(st:ed);
                clip = audioNormalization(clip, 1);
                audiowrite([writeFolder, files(index).name(1:end-4), '_repeat_', num2str(j), '.wav'], clip, sr)
                rec = rec(ed:end);
            end
            rec = rec(4*sr:end);
        end
    end
end