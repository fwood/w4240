function message = get_message_fn_aj(to_node);
% Calculates a message to be sent to the argument node from the factor node
% between variable nodes a and j.
%
% @param     to_node :   variable node to which a message is being passed
% @return    message :   message to pass to to_node, MUST BE COLUMN VECTOR

global fn_aj

node = fn_aj;

% this for loop updates all the messages needed to send the requested
% message
for i = 1 : length(node.c)
    if ~strcmp(node.c{i}.name,to_node.name)
        node.m{i} = get_message_vn(node,node.c{i});
    end
end

% now all the incoming messages are up to date, calculate the message to be
% sent to to_node