function pass_all_messages(node)
% pass_all_messages
%
% This function passes messages from the given node to all its neighboring
% nodes.  The argument node must be a variable node.
%
% @param node : node from which to pass messages


% check that the argument is a variable node
assert(strfind(node.name,'vn_') == 1)

% pass messages
for i = 1 : length(node.c)
    child = node.c{i};
    message = get_message_vn(child,node);
    pass_messages(node, message, child);
end