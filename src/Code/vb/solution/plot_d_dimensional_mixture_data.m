function plot_d_dimensional_mixture_data(varargin)
%assumes the first element of the argumesnt is the data, which is a n x d 
%two dimensional matrix, the second argument is optional and is the
%groupings of the data

data = varargin{1};
w = princomp(data);
if nargin == 1
    scatter(data * w(:,1), data * w(:,2));
elseif nargin == 2
    gscatter(data * w(:,1), data * w(:,2), varargin{2});
end