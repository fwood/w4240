function message = get_message_fn_e(to_node)
% Calculates a message to be sent to the argument node from the factor node 
% only connected to the variable node e.
%
% @param     to_node :   variable node to which a message is being passed
%
% @return    message :   message to pass to to_node, MUST BE COLUMN VECTOR