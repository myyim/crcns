# Mathlab codes and files for CRCNS
Matlab version: R2021a

Toolboxes: Image Processing Toolbox, Statistics and Machine Learning Toolbox, Signal Processing Toolbox

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
shuffled_identical_circular_fields.m: shuffles grid bumps in perfect simulated grid activity pattern assuming identical and circular bumps
(Note that shuffledfields(g2d) thresholds the data g2d by default before shuffling.)
```
% shuffles grid bumps in perfect simulated grid activity pattern assuming identical and circular bumps
gs = shuffled_identical_circular_fields(g2d);
```
<img src="/figures_readme/g2d.png" width="250"> --> <img src="/figures_readme/gs.png" width="250">

shuffledbins.m: shuffles bins randomly
```
% shuffles bins randomly
gsb = shuffledbins(g2d);
```
<img src="/figures_readme/g2d.png" width="250"> --> <img src="/figures_readme/gsb.png" width="250">

shuffledbumps.m: shuffles bumps randomly
```
% shuffles bumps randomly
gsbp = shuffledfields(ratemap_conv);

% Check the statistics by plotting the histogram of the firing rate
nbins = 20; % number of bins
figure;
h = histogram(ratemap_conv,nbins);
figure;
h = histogram(gsbp,nbins);
```
<img src="/figures_readme/ratemap_conv.png" width="250"> --> <img src="/figures_readme/ratemap_shuffled.png" width="250">

<img src="/figures_readme/hist_ratemap_conv.png" width="250"> --> <img src="/figures_readme/hist_ratemap_shuffled.png" width="250">

For simulated dense grid cell activity, shuffled_identical_circular_fields.m is usually preferred.
```
gsbp = shuffledfields(g2d);
```
<img src="/figures_readme/g2d.png" width="250"> --> <img src="/figures_readme/g2d_shuffled.png" width="250">

shuffledfields.m: shuffles bumps randomly inside a restricted region defined in mask
```
% shuffles bumps randomly inside a restricted region defined in mask
[y0m,x0m] = meshgrid(y0,x0);
mask = (x0m.^2+y0m.^2<(rad_extract-tractw_extract/2)^2)+(x0m.^2+y0m.^2>(rad_extract+tractw_extract/2)^2)==0;
gsbp = shuffledfields(ratemap_track_conv,0.2,1,mask);

% Check the statistics by plotting the histogram of the firing rate
nbins = 20; % number of bins
figure;
h = histogram(ratemap_track_conv(mask==1),nbins);
figure;
h = histogram(gsbp(mask==1),nbins);
```
<img src="/figures_readme/ratemap_extract_conv.png" width="250"> --> <img src="/figures_readme/ratemap_extract_conv_shuffled.png" width="250">

<img src="/figures_readme/hist_ratemap_extract_conv.png" width="250"> --> <img src="/figures_readme/hist_ratemap_extract_conv_shuffled.png" width="250">

### Clustering
DBSCAN
```
% cluster using DBSCAN
[idx_d,C_d] = clusterdbscan(trackf);
```
<img src="/figures_readme/clusterdbscan.png" width="750">

K-means after DBSCAN
```
% cluster using k-means
[idx_k,C_k] = clusterkmeans(trackf,idx_d);
```
<img src="/figures_readme/clusterdkmeans.png" width="750">

K-means
```
seed = 0;
rng(seed);
idx_k = kmeans(trackf,7);
C_k = zeros(max(idx_k),2);
figure; hold on; axis image;
for j = unique(idx_k(idx_k~=-1))'
    C_k(j,:) = mean(trackf(idx_k==j,:));
    plot(trackf(idx_k==j,1),trackf(idx_k==j,2),'.');
    plot(C_k(j,1),C_k(j,2),'kx','LineWidth',2);
end
```

Shuffling
```
% shuffle clusters
trackfs = shuffledclusters(trackf,idx_k);
```
<img src="/figures_readme/kmeans.png" width="250"> --> <img src="/figures_readme/shuffledkmeans.png" width="250">
```
% shuffle cluster inside a restricted region defined in mask
dmax = ceil(max(abs(trackf),[],'all'));
mask = zeros(2*dmax+1,2*dmax+1);
[ycoor,xcoor] = meshgrid(-dmax:dmax,-dmax:dmax);
mask(xcoor.^2+ycoor.^2<dmax^2) = 1;
trackfs = shuffledclusters(trackf,idx_k,1,mask);
```
<img src="/figures_readme/kmeans.png" width="250"> --> <img src="/figures_readme/shuffledkmeansmask.png" width="250">

### Gridness score
Generate a smoothed spatial rate map

Calculate the autocorrelation of the rate map

Compute the mean activity along the radial coordinates of the autocorrelation

Pick the first local minimum r and maximum R, which are approximately the radius of the field and the grid spacing, respectively

Extract the ring centered at R with width 2r

Compute the rotational autocorrelation and extract the same ring based on coordinates

The gridness score is the minimum of the (Pearson) correlations obtained at rotational offset 60° and 120° minus the maximum obtained at 30°, 90°, and 150°

### Temporary figures
<img src="/figures_readme/testdbscan.png" width="250">

### Fitting (codes)
Jacob_Sargolini_traj_overlaid_all.m: prints out all locations in both arena and track in a session as dots and uses the track locations to fit a circle using the method of least squares.

<img src="/figures_readme/overlaid.png" width="250">
