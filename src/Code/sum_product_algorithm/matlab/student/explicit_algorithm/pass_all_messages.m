function pass_all_messages(node)

%must be a variable node
assert(strfind(node.name,'vn_') == 1)

for i = 1 : length(node.c)
    child = node.c{i};
    message = get_message_vn(child,node);
    pass_messages(node,message,child);
end