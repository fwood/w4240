function plotMVNIsosurfaces(mean, covariance) 

x = linspace(0,10,100);
y = linspace(0,10,100);
[X,Y] = meshgrid(x,y);

Z = [X(:) Y(:)];
p = mvnpdf(Z,mean',covariance);
contour3(X,Y,reshape(p,length(x),length(y)),'g');

