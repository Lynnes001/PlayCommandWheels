


%% MAIN

sr=22050;
gap_len=2;
pre_filter=[];
normalize=1;
loop = 2;
folder = './samples_allcommands';
fileList = dir([folder, '/kevinv3_*.wav']);

makePlayList(sr, gap_len, pre_filter, normalize, fileList, loop);

%%
post_filter = [];
needPlotToFindHead = 1;
parsePlayList('./samples_allcommands/playall_samples_allcommands.wav', 0.2, sr, gap_len, post_filter, normalize, fileList, loop, needPlotToFindHead)



