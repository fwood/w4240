function message = get_message_fn_am(to_node);

global fn_am

node = fn_am;

%get messages from children
for i = 1 : length(node.c)
    if ~strcmp(node.c{i}.name,to_node.name)
        node.m{i} = get_message_vn(node,node.c{i});
    end
end

%factor matrix indexed by a,m
f = [.7 .3 ; .01 .99];

message = zeros(2,2);
for a = 1:2
    for m = 1:2
        if strcmp(to_node.name,'vn_a')
            message(a,m) = node.m{1}(m);
        elseif strcmp(to_node.name,'vn_m')
            message(a,m) = node.m{2}(a);
        end
    end
end

message = message .* f;

if strcmp(to_node.name,'vn_a')
    message = sum(message,2);
elseif strcmp(to_node.name,'vn_m')
    message = sum(message,1);
end

message = message(:);