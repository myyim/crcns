# Codes and files for CRCNS

### Generating grid activity (codes)
Call gridcell.m
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

### Cell IDs in Sargolini data (sargolini_cellID)
CellIDarena.mat: file name, tetrode ID and cell ID of 71 cells recorded in arenas  
CellIDtrack.mat: file name, tetrode ID and cell ID of 71 cells recorded on tracks

Load the data to workspace
```
datapath = '../Jacob_Sargolini_Data/light_large/data/'; % enter your data path here!
addpath(datapath);
load(['CellIDtrack.mat']);
```

### Plotting grid activity in Sargolini data (codes)
Call getdata_sargolini.m which works for both arena and track data. Plot trajectory and spikes. Generate ratemap.
```
[trackpos,trackf,ts] = getdata_sargolini('MEC201410Al1t0.mat',0,1,1); % data 2d
% file name, tetrode ID, cell ID, load all data using the parameter file 

% plot trajectory and spikes
figure; hold on; axis image; plot(trackpos(:,1),trackpos(:,2),'k'); plot(trackf(:,1),trackf(:,2),'r.');

% plot ratemap
x0 = -100:100;  % enter the length here!
tb = histcounts2(trackpos(:,1),trackpos(:,2),x0,x0);    % time spent on each bin in 2D
tb = tb*0.04;     % amount of time on each bin
spkb = histcounts2(trackf(:,1),trackf(:,2),x0,x0);  % spike count on each bin in 2D
ratemap = spkb./tb;     % ratemap
ratemap(isnan(ratemap)) = 0;    % remove nan for unexplored bins   
figure; imagesc_env(x0,x0,ratemap); axis image; colorbar; colormap(jet(256)); caxis([0 max(max(ratemap))]);
```
<img src="/figures_readme/traj.png" width="300"> <img src="/figures_readme/ratemap.png" width="300">

### Extracting circular track activity from grid activity in Sargolini data (codes)
Call getdata_sargolini.m. Plot trajectory and spikes. Generate ratemap.
```
tractw_extract = 15;  % track width
rad_extract = 60;   % radius
[trackpos,trackf,ts] = getdata_sargolini('MEC201410Al1t0.mat',0,1,4,tractw_extract,rad_extract); % data 2d
% file name, tetrode ID, cell ID, 4=extract circular track from given data, 15=track width, 60=radius of extraction

% plot trajectory and spikes
figure; hold on; axis image; plot(trackpos(:,1),trackpos(:,2),'k'); plot(trackf(:,1),trackf(:,2),'r.');
t = 0:0.01:2*pi+0.01; 
plot((rad_extract-15/2)*cos(t),(rad_extract-15/2)*sin(t),'g');  % inner circle
plot((rad_extract+15/2)*cos(t),(rad_extract+15/2)*sin(t),'g');  % outer circle

% plot ratemap
x0 = -100:100;  % enter the length here!
tb = histcounts2(trackpos(:,1),trackpos(:,2),x0,x0);    % time spent on each bin in 2D
tb = tb*0.04;     % amount of time on each bin
spkb = histcounts2(trackf(:,1),trackf(:,2),x0,x0);  % spike count on each bin in 2D
ratemap = spkb./tb;     % ratemap
ratemap(isnan(ratemap)) = 0;    % remove nan for unexplored bins   
figure; hold on; imagesc_env(x0,x0,ratemap); axis image; colorbar; colormap(jet(256)); caxis([0 max(max(ratemap))]);
plot((rad_extract-15/2)*cos(t),(rad_extract-15/2)*sin(t),'g');  % inner circle
plot((rad_extract+15/2)*cos(t),(rad_extract+15/2)*sin(t),'g');  % outer circle
```
<img src="/figures_readme/traj_extract.png" width="300"> <img src="/figures_readme/ratemap_extract.png" width="300">

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
gsbp = shuffledbumps(gdata)
```


