%% parameters
rad = 75-15/2; % mid-radius of track
%file2exclude = [2,3,5,7,9,12,13,15,17,19,21,23]; % exclude non-circular track data
rlist = [89,95,97]; % mid-radius in pixels for rats (first recording, first epoch)
trackclist = [[109,109];[132,132];[133,118]]; % approximate center location of the track in pixel
sclist = rad./rlist; % scaling from pixel to cm, directly inferred from figures
sd_range = 0.1; % max spatial frequency in PSD
xmin = -100;
xmax = 100;
x0 = xmin:xmax;
y0 = x0;
x1 = -(xmax-xmin+1):xmax-xmin+1;
y1 = x1;

%% set path and get directories
datapath = '../Jacob_Sargolini_Data/light_large/data/';
addpath(datapath);
figpath = './figures/Jacob_Sargolini_Data/';
load('./CellIDtrack.mat');
load('./CellIDarena.mat');
%dirnames = getfilenames(datapath,'mat','A');    % get all valid file names
%validcells = sort(CellIDtrack(:,1));     % get files for all valid cells
%for j = 1:size(dirnames,2)
%    disp([dirnames(j),': ',num2str(find(ismember(validcells,dirnames{j}))')]);
%end
%dirnames(file2exclude) = [];