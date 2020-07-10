


%% MAIN 1: make audio samples in './samples_allcommands' in one file gap len 2 senconds, each sample loop twice

sr=22050;
gap_len=2;
pre_filter=[];
normalize=1;
loop = 2;
folder = './samples_allcommands';
fileList = dir([folder, '/kevinv3_*.wav']);

makePlayList(sr, gap_len, pre_filter, normalize, fileList, loop);

%% MAIN 2: parse the recorded files to recorded clips and save to './parse/'

post_filter = [];
needPlotToFindHead = 1;
parsePlayList('./samples_allcommands/playall_samples_allcommands.wav', 0.2, sr, gap_len, post_filter, normalize, fileList, loop, needPlotToFindHead)



