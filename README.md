# Mathlab codes and files for CRCNS
Matlab version: R2020b
Contact: manyi (dot) yim (a) gmail (dot) com

### Generating grid activity (codes)
Call gridcell.m
```
rx = 80;  ry = 70;    % the size is 2rx X 2ry
fpk = 1;    % peak rate
lam = 37;   % grid period
psi = 0.31; % grid orientation
c = [0,0];  % center related to phase
[ym,xm] = meshgrid(-ry:ry,-rx:rx);    
g2d = gridcell(ym,xm,fpk,lam,psi,c);  % from left to right in a matrix is in the direction of increasing the second coordinate, thus (y,x)
figure; hold on; imagesc_env(g2d,-rx:rx,-ry:ry); axis image; colorbar; colormap(jet(256)); % plot
```
<img src="/figures_readme/g2d.png" width="250">

### Cell IDs in Sargolini data (sargolini_cellID)
CellIDarena.mat: file name, tetrode ID and cell ID of 71 cells recorded in arenas  
CellIDtrack.mat: file name, tetrode ID and cell ID of 71 cells recorded on tracks

Load the data to workspace
```
datapath = '../Jacob_Sargolini_Data/light_large/data/'; % enter your data path here!
addpath(datapath);
load(['CellIDarena.mat']); load(['CellIDtrack.mat']);
```

### Plotting grid activity in Sargolini data (codes)
Call getdata_sargolini.m which works for both arena and track data. Plot trajectory and spikes. Generate ratemap. Convolve the ratemap with a Gaussian.
```
[trackpos,trackf,ts] = getdata_sargolini('MEC201410Al1t0.mat',0,1,1); % data 2d
% file name, tetrode ID, cell ID, load all data using the parameter file 

% plot trajectory and spikes
figure; hold on; axis image; plot(trackpos(:,1),trackpos(:,2),'k'); plot(trackf(:,1),trackf(:,2),'r.');

% plot ratemap
x0 = -100:100;  % enter the length here!
y0 = -90:90;
x0_edge = [x0-0.5,x0(end)+0.5]; % for histcounts2 (edges)
y0_edge = [y0-0.5,y0(end)+0.5];
tb = histcounts2(trackpos(:,1),trackpos(:,2),x0_edge,y0_edge);    % time spent on each bin in 2D
tb = tb*0.04;     % amount of time on each bin
spkb = histcounts2(trackf(:,1),trackf(:,2),x0_edge,y0_edge);  % spike count on each bin in 2D
ratemap = spkb./tb;     % ratemap
ratemap(isnan(ratemap)) = 0;    % remove nan for unexplored bins   
figure; imagesc_env(ratemap,x0,y0); axis image; colorbar; colormap(jet(256)); caxis([0 max(ratemap,[],'all')]);

% plot ratemap convolved with a Gaussian
ratemap_conv = conv2(ratemap,gauss2d(21,21,5),'same');
figure; imagesc_env(ratemap_conv,x0,y0); axis image; colorbar; colormap(jet(256)); caxis([0 max(ratemap_conv,[],'all')]);
```
<img src="/figures_readme/traj.png" width="250"> <img src="/figures_readme/ratemap.png" width="250"> <img src="/figures_readme/ratemap_conv.png" width="250">

### Extracting circular track activity from grid activity in Sargolini data (codes)
Call getdata_sargolini.m. Plot trajectory and spikes. Generate ratemap.
```
% define the circular extraction
rad_extract = 75-15/2;   % mid-radius of the track
tractw_extract = 20;  % track width of the extraction; can be larger than actual width because animals' head can be outside
t = 0:0.01:2*pi+0.01; % for plotting circles

% plot region of extraction
figure; hold on; axis image; plot(trackpos(:,1),trackpos(:,2),'k'); plot(trackf(:,1),trackf(:,2),'r.');
plot((rad_extract-tractw_extract/2)*cos(t),(rad_extract-tractw_extract/2)*sin(t),'g');  % inner circle
plot((rad_extract+tractw_extract/2)*cos(t),(rad_extract+tractw_extract/2)*sin(t),'g');  % outer circle

% load extracted data
[trackpos_extract,trackf_extract,ts] = getdata_sargolini('MEC201410Al1t0.mat',0,1,4,tractw_extract,rad_extract); % data 2d
% file name, tetrode ID, cell ID, 4=extract circular track from given data

% plot trajectory and spikes
figure; hold on; axis image; plot(trackpos_extract(:,1),trackpos_extract(:,2),'k'); plot(trackf_extract(:,1),trackf_extract(:,2),'r.');
plot((rad_extract-tractw_extract/2)*cos(t),(rad_extract-tractw_extract/2)*sin(t),'g');  % inner circle
plot((rad_extract+tractw_extract/2)*cos(t),(rad_extract+tractw_extract/2)*sin(t),'g');  % outer circle

```
<img src="/figures_readme/traj_circle.png" width="250"> <img src="/figures_readme/traj_extract.png" width="250">

```
% plot ratemap
tb = histcounts2(trackpos_extract(:,1),trackpos_extract(:,2),x0_edge,y0_edge);    % time spent on each bin in 2D
tb = tb*0.04;     % amount of time on each bin
spkb = histcounts2(trackf_extract(:,1),trackf_extract(:,2),x0_edge,y0_edge);  % spike count on each bin in 2D
ratemap_track = spkb./tb;     % ratemap
ratemap_track(isnan(ratemap_track)) = 0;    % remove nan for unexplored bins   
figure; hold on; imagesc_env(ratemap_track,x0,y0); axis image; colorbar; colormap(jet(256)); caxis([0 max(ratemap_track,[],'all')]);
plot((rad_extract-tractw_extract/2)*cos(t),(rad_extract-tractw_extract/2)*sin(t),'g');  % inner circle
plot((rad_extract+tractw_extract/2)*cos(t),(rad_extract+tractw_extract/2)*sin(t),'g');  % outer circle

% plot ratemap convolved with a Gaussian
ratemap_track_conv = conv2(ratemap_track,gauss2d(21,21,5),'same');
[y0m,x0m] = meshgrid(y0,x0);
ratemap_track_conv((x0m.^2+y0m.^2<(rad_extract-tractw_extract/2)^2)+(x0m.^2+y0m.^2>(rad_extract+tractw_extract/2)^2)~=0) = 0;
figure; imagesc_env(ratemap_track_conv,x0,y0); axis image; colorbar; colormap(jet(256)); caxis([0 max(ratemap_track_conv,[],'all')]);
```
<img src="/figures_readme/ratemap_extract.png" width="250"><img src="/figures_readme/ratemap_extract_conv.png" width="250">

### Control (codes_control)
shuffledfields.m: shuffles grid bumps in perfect simulated grid activity pattern assuming identical and circular bumps
(Note that shuffledfields(g2d) thresholds the data g2d by default before shuffling.)
```
gs = shuffled_identical_circular_fields(g2d);
```
<img src="/figures_readme/g2d.png" width="250"> --> <img src="/figures_readme/gs.png" width="250">

shuffledbins.m: shuffles bins randomly
```
gsb = shuffledbins(g2d);
```
<img src="/figures_readme/g2d.png" width="250"> --> <img src="/figures_readme/gsb.png" width="250">

shuffledbumps.m: shuffles bumps randomly
```
gsbp = shuffledfields(ratemap_conv);
```
<img src="/figures_readme/ratemap_conv.png" width="250"> --> <img src="/figures_readme/ratemap_shuffled.png" width="250">

```
gsbp = shuffledfields(g2d);
```
<img src="/figures_readme/g2d.png" width="250"> --> <img src="/figures_readme/g2d_shuffled.png" width="250">

### Fitting (codes)
Jacob_Sargolini_traj_overlaid_all.m: prints out all locations in both arena and track in a session as dots and uses the track locations to fit a circle using the method of least squares.

<img src="/figures_readme/overlaid.png" width="250">
