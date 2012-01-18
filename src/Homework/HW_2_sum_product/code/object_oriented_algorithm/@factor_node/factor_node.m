% factor_node : object used for factor nodes in a factor graph
% representation of a graphical model.
%
% properties
%
% factor : factor object associated with this factor node
%
classdef factor_node < node

    properties(GetAccess = 'public', SetAccess = 'private')
        factor;
    end
    
    methods
        
        % factor_node : constructor method to create this factor node
        %
        % @param factor : factor associated with this factor node
        %
        function obj = factor_node(unid, factor)
            obj = obj@node(unid);
            if nargin == 2;
                obj.factor = factor;
            end
        end
        
        % addNode : adds a node to the cell array of neighboring nodes
        %
        function addNode(obj,node)
            l = length(obj.nodes);
            obj.nodes{l + 1} = node;
            obj.messages{l + 1} = ones(node.dimension,1);
        end
        
        % getMessage : gets the message to be sent to the given node. THIS
        %              METHOD IS ONE WITH STUDENT NEEDS TO FILL OUT.
        %
        % @param to_unid : node to which message will be sent
        %
        function message = getMessage(obj, to_unid)
            ?
            ?
            %message must be column vector
            message = message(:);
        end

        % display : overides the default display behavior
        %
        function display(obj)
            display@node(obj);
            disp(' ');
            disp('factor is = ');
            disp(obj.factor);
        end     
    end
    
end