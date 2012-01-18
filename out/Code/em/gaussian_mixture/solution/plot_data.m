function plot_data(X,labels)

pc = princomp(X);

if nargin > 1
    gscatter(X*pc(:,1),X*pc(:,2),labels);
else
    gscatter(X*pc(:,1),X*pc(:,2));
end