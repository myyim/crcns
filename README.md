# Codes and files for CRCNS

### Generating grid activity (codes)
gridcell.m
```
r = 75;     % the side length is 2r
fpk = 1;    % peak rate
lam = 37;   % grid period
psi = 0.31; % grid orientation
c = [0,0];  % center related to phase
[xm,ym] = meshgrid(-r:r,-r:r);
g2d = gridcell(xm,ym,fpk,lam,psi,c);
figure; hold on; axis image; colorbar; colormap(jet(256));imagesc(g2d); % plot
```

### Extracting grid activity in open fields in Sargolini data (codes)
getdata_sargolini.m
```
[trackpos,trackf,ts] = getdata_sargolini('MEC201410Al1t0.mat',0,1,1); % data 2d
% plot trajectory and spikes
% heatmap
```

### Control (codes_control)
shuffledfields.m: shuffles grid bumps in perfect simulated grid activity pattern assuming identical and circular bumps
(Note that shuffledfields(g2d) thresholds the data g2d by default before shuffling.)
```
gs = shuffledfields(g2d)
```
<img src="/figures_readme/g2d.png" width="300"> --> <img src="/figures_readme/gs.png" width="300">

shuffledbins.m: shuffles bins randomly
```
gsb = shuffledbins(g2d)
```
<img src="/figures_readme/g2d.png" width="300"> --> <img src="/figures_readme/gsb.png" width="300">

shuffledbumps.m: shuffles bumps randomly
```
gsbp = shuffledbins(gdata)
```

### Cell IDs in Sargolini data (sargolini_cellID)
CellIDarena.mat: file name, tetrode ID and cell ID of 71 cells recorded in arenas  
CellIDtrack.mat: file name, tetrode ID and cell ID of 71 cells recorded on tracks

Load the data
```
datapath = './';  % enter your data path here!
addpath(datapath);
load([datapath,'CellIDtrack.mat']);
```

