function imagesc_env(mat,x,y)
% imagesc_env(mat,x,y) returns the colormap for mat with binnings x and y
% in the desirable format.
if nargin == 1
    x = 1:size(mat,1);
    y = 1:size(mat,2);
end
imagesc(x,y,mat');
set(gca,'YDir','normal');
end