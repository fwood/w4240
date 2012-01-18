function message = get_message_fn_bea(to_node)

global fn_bea

node = fn_bea;

%get messages from children
for i = 1 : length(node.c)
    if ~strcmp(node.c{i}.name,to_node.name)
        node.m{i} = get_message_vn(node,node.c{i});
    end
end

%f is indexed by a,b,e
f = zeros(2,2,2);
f(:,1,1) = [.95 .05];
f(:,1,2) = [.94 .06];
f(:,2,1) = [.29 .71];
f(:,2,2) = [.001 .999];

message = zeros(2,2,2);

for a = 1:2
    for b = 1:2
        for e = 1:2
            if strcmp(to_node.name,'vn_b')
                message(a,b,e) = node.m{1}(a) * node.m{2}(e);
            elseif strcmp(to_node.name,'vn_a');
                message(a,b,e) = node.m{2}(e) * node.m{3}(b);
            elseif strcmp(to_node.name,'vn_e');
                message(a,b,e) = node.m{1}(a) * node.m{3}(b);
            end
        end
    end
end

message = message .* f;

if strcmp(to_node.name,'vn_b')
    message = sum(sum(message,1),3);
elseif strcmp(to_node.name,'vn_a');
    message = sum(sum(message,2),3);
elseif strcmp(to_node.name,'vn_e');
    message = sum(sum(message,1),2);
end

message = message(:);