function gau = gauss2d(Nx,Ny,sig,X,Y)
if nargin <= 2
    sig = 5;
end
if nargin == 3
    X = ceil(Nx/2); Y = ceil(Ny/2);
end
[x,y] = meshgrid(1:Nx,1:Ny);
gau = exp(-(x-X).^2/(2*sig^2)-(y-Y).^2/(2*sig^2))/(2*pi*sig^2);
end