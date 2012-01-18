function mp = multilinear_product(varargin)
% multilinear_product
%
% Returns the outer product, as a tensor, of all the elements passed in.
% The assumption is that you pass in column vectors
% If, for example you pass in two vectors, W and V then mp(i,j) = W(i) *
% V(j);

if nargin == 1
    mp = varargin{1};
else
    %initialize mp
    init_mp = ['mp = ones(' num2str(size(varargin{1},1))];

    for dim = 2 : nargin
        init_mp  = [init_mp ', ' num2str(size(varargin{dim},1))]; %#ok<AGROW>
    end

    init_mp = [init_mp ');'];
    eval(init_mp)

    %now create and execute command to actually fill in the array
    cmnd = '';
    for dim = 1 : nargin
        cmnd = [cmnd 'for dim_' num2str(dim) ' = 1 : ' num2str(size(varargin{dim},1)) ';']; %#ok<AGROW>
    end

    cmnd = [cmnd 'mp(dim_1'];
    for dim = 2 : nargin
        cmnd = [cmnd ', dim_' num2str(dim)]; %#ok<AGROW>
    end

    cmnd = [cmnd ') = varargin{1}(dim_1)'];

    for dim = 2 : nargin
        cmnd = [cmnd '* varargin{' num2str(dim) '}(dim_' num2str(dim) ')'];  %#ok<AGROW>
    end
    cmnd = [cmnd ';'];

    for dim = 1 : nargin
        cmnd = [cmnd 'end;']; %#ok<AGROW>
    end
    
    eval(cmnd)
end