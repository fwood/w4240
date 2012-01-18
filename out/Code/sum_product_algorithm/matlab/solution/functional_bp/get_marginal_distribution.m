function dist = get_marginal_distribution(node);

%must be a variable node
assert(strfind(node.name,'vn_') == 1)

dist = node.m{1};
for i = 2 : length(node.m)
    dist = dist .* node.m{i};
end

dist = dist / sum(dist);