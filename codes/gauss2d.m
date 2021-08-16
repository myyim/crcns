function gau = gauss2d(Nx,Ny,sig,X,Y)
% gau = gauss2d(Nx,Ny,sig,X,Y) returns a 2D gaussian profile (Nx-by-Ny)
% with standard deviation sig and its peak at (X,Y). It peaks at the center
% with sig = 5 if not specified.

if nargin <= 2
    sig = 5;
end
if nargin == 3
    X = ceil(Nx/2); Y = ceil(Ny/2);
end
[x,y] = meshgrid(1:Nx,1:Ny);
gau = exp(-(x-X).^2/(2*sig^2)-(y-Y).^2/(2*sig^2))/(2*pi*sig^2);
end
