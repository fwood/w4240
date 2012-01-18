function dist = get_marginal_distribution(node);
%This function returns the marginal distribution of the variable node
%argument.
%
%@param     node :  variable node
%@return    dist :  marginal distribution of variable node argument


%must be a variable node
assert(strfind(node.name,'vn_') == 1)
