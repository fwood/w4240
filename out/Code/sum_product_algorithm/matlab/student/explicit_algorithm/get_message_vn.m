function message = get_message_vn(to_node, this_node)
%Calculate the message in the variable node this_node to pass to the factor
%node to_node.
%
%@param     to_node     :   factor node we are passing a message to
%@param     this_node   :   variable node we are passing a message from
%@return    message     :   message we are passing, MUST BE COLUMN VECTOR

for i = 1 : length(this_node.c)
    if ~strcmp(this_node.c{i}.name,to_node.name)
        cmnd = ['get_message_' this_node.c{i}.name '(this_node)'];
        this_node.m{i} = eval(cmnd);
    end
end

%set default value
message = ones(size(this_node.m{1},1),1);

if this_node.set
    ?;
else
    ?;
end