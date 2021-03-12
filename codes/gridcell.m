%% Get grid cell firing rate
function G = gridcell(rx,ry,fpk,lam,psi,c,thre)
% rx, ry: rat locations (each 1xn)
% fpk: pk firing rates for each loc (1xn or scalar)
% lam in cm, is the period
% psi is the orientation in radians
% c is the center, in R^2 and cm
% G: 1xn

if nargin == 6
    thre = 0;
end
    
th = [-30 30 90]*pi/180;

g = @(x) exp(.3*(x+3/2))-1;

I = 0;
for k=1:3
    ang = th(k)+psi;
    dot = cos(ang)*(rx-c(1)) + sin(ang)*(ry-c(2));  % 1xn
    I = I + cos( 4*pi/(lam*sqrt(3)) * dot ); % 1xn
end

G = g(I).* fpk/(exp(.3*4.5)-1);  % normalize so pk rate is fpk

G(G<thre) = 0;

end
