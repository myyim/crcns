# Codes and files for CRCNS

### Code for generating grid activity (codes)
gridcell.m
```
r = 75;     % the side length is 2r
fpk = 1;    % peak rate
lam = 37;   % grid period
psi = 0.31; % grid orientation
c = [0,0];  % center related to phase
[xm,ym] = meshgrid(-r:r,-r:r);
g2d = gridcell(xm,ym,fpk,lam,psi,c);
```

### Code for control (codes_control)
shuffledfields.m: shuffles grid bumps in perfect simulated grid activity pattern assuming identical and circular bumps
```
gs = shuffledfields(g2d)
```
<img src="/figures_readme/g2d.png" width="300"> --> <img src="/figures_readme/gs.png" width="300">

shuffledbins.m: shuffles bins randomly
```
gs = shuffledbins(gdata)
```
<img src="/figures_readme/g2d.png" width="300"> --> <img src="/figures_readme/gsb.png" width="300">

### Cell IDs in Sargolini data (sargolini_cellID)
CellIDarena.mat: file name, tetrode ID and cell ID of 71 cells recorded in arenas
CellIDtrack.mat: file name, tetrode ID and cell ID of 71 cells recorded on tracks

