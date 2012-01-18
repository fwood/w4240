function pass_messages(from_node, message, node)

%set message just passed in
index = 0;
for i = 1 : length(node.c)
    if strcmp(from_node.name, node.c{i}.name)
        index = i;
        break;
    end
end
assert(index > 0);

node.m{index} = message;

% find out if in a fn or vn node
if strfind(node.name,'fn_') == 1
    vn = false;
else
    vn = true;
end

%pass messages to all appropriate children
for i = 1 : length(node.c)
    if i ~= index
        child = node.c{i};
        
        if vn
            message = get_message_vn(child,node);
        else
            cmnd = ['get_message_' node.name '(child)'];
            message = eval(cmnd);
        end
        
        pass_messages(node,message,child);
    end
end
