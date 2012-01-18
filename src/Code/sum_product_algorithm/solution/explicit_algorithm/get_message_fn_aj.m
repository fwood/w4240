function message = get_message_fn_aj(to_node);

global fn_aj

node = fn_aj;

%get messages from children
for i = 1 : length(node.c)
    if ~strcmp(node.c{i}.name,to_node.name)
        node.m{i} = get_message_vn(node,node.c{i});
    end
end

%factor matrix indexed by a,j
f = [.9 .1; .05 .95];

message = zeros(2,2);
for a = 1:2
    for j = 1:2
        if strcmp(to_node.name,'vn_a')
            message(a,j) = node.m{1}(j);
        elseif strcmp(to_node.name,'vn_j')
            message(a,j) = node.m{2}(a);
        end
    end
end

message = message .* f;

if strcmp(to_node.name,'vn_a')
    message = sum(message,2);
elseif strcmp(to_node.name,'vn_j')
    message = sum(message,1);
end

message = message(:);