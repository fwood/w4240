function plotMVNIsosurfaces(mean, covariance, linspec, axis) 
%%
% plotMVNIsosurfaces(mean, covariance, linspec, axis) 
% @param mean column vector
% @param covariance matrix
% @param line spec
% @param axis (for max and min values of plotting

if nargin < 3  || isempty(linspec)
    linspec = 'g';
end

if nargin < 4
    xmin = 0;
    xmax = 10;
    ymin = 0;
    ymax = 10;
else
    b = get(axis,'XLim');
    xmin = b(1);
    xmax = b(2);
    b = get(axis,'YLim');
    ymin = b(1);
    ymax = b(2);
end

x = linspace(xmin,xmax,100);
y = linspace(ymin,ymax,100);
[X,Y] = meshgrid(x,y);

Z = [X(:) Y(:)];
p = mvnpdf(Z,mean',covariance);
contour3(X,Y,reshape(p,length(x),length(y)),linspec);

