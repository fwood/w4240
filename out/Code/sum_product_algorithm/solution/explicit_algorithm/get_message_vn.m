function message = get_message_vn(to_node, this_node)

for i = 1 : length(this_node.c)
    if ~strcmp(this_node.c{i}.name,to_node.name)
        cmnd = ['get_message_' this_node.c{i}.name '(this_node)'];
        this_node.m{i} = eval(cmnd);
    end
end

if this_node.set
    message = zeros(size(this_node.m{1},1),1);
    message(this_node.value) = 1;
else
    message = ones(size(this_node.m{1},1),1);
    for i = 1:length(this_node.m)
        if ~strcmp(this_node.c{i}.name,to_node.name)
            message = message .* this_node.m{i};
        end
    end
end