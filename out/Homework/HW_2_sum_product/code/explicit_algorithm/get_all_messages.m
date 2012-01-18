function get_all_messages(node)
% get_all_messages
%
% This function initiates a string of function calls which pass messages in
% from the edges to a given node.
%
% @param node : node to which messages are being passed in to


for i = 1 : length(node.c)
    cmnd = ['get_message_' node.c{i}.name '(node);'];
    node.m{i} = eval(cmnd);
end

