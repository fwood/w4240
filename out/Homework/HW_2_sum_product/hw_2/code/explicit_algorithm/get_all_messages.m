function get_all_messages(node)

for i = 1 : length(node.c)
    cmnd = ['get_message_' node.c{i}.name '(node);'];
    node.m{i} = eval(cmnd);
end

