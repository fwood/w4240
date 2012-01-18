function message = get_message_fn_bea(to_node)
%Calculates a message to be send to the argument node.
%
%@param     to_node :   variable node to which a message is being passed
%@return    message :   message to pass to to_node, MUST BE COLUMN VECTOR
global fn_bea

node = fn_bea;

%get messages from children
for i = 1 : length(node.c)
    if ~strcmp(node.c{i}.name,to_node.name)
        node.m{i} = get_message_vn(node,node.c{i});
    end
end

%now all the child messages are up to date, calculate the message to be
%sent to to_node