# Codes and files for CRCNS

### Codes for generating grid activity
```
r = 40;
fpk = 1;    % peak rate
lam = 40; % period
psi = 0.31;    % orientation
c = [0,0];  % center related to phase
[xm,ym] = meshgrid(-r:r,-r:r);
g2d = gridcell(xm,ym,fpk,lam,psi,c);
```


### Codes for control (codes_control)
shuffledfields.m: shuffles grid bumps in perfect simulated grid activity pattern assuming identical and circular bumps

### Cell IDs in Sargolini data (sargolini_cellID)
CellIDarena.mat: file name, tetrode ID and cell ID of 71 cells recorded in arenas
CellIDtrack.mat: file name, tetrode ID and cell ID of 71 cells recorded on tracks

