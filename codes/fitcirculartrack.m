function p = fitcirculartrack(trackpos,p_guess,toplot)
% p = fitcirculartrack(trackpos,p_guess,toplot) fits the 2-dim trackpos
% with a circle with initial guess p_guess, and returns the center of the 
% circle (p(1),p(2)) and radius p(3).
% toplot determines whether to plot trackpos and the fitted circle.

if nargin == 1
   p_guess = [350,250,140];    % x,y of center and radius 
end

fun = @(p) 0.5*sum((sqrt((trackpos(:,1)-p(1)).^2+(trackpos(:,2)-p(2)).^2)-p(3)).^2);
p = fminsearch(fun, p_guess);

if nargin == 3
    if toplot
        t = 0:0.05:2*pi+0.05;
        %figure; hold on; axis image;
        plot(trackpos(:,1),trackpos(:,2),'c.','MarkerSize',1);
        plot(p(3)*cos(t)+p(1),p(3)*sin(t)+p(2),'b-');
        title(['c=[',num2str(round(p(1))),',',num2str(round(p(2))),']; r=',num2str(round(p(3)))]);
    end
end
end