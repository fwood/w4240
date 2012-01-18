classdef factor_node < node

    properties(GetAccess = 'public', SetAccess = 'private')
        factor;
    end
    
    methods
        
        %constructor
        function obj = factor_node(unid, factor)
            obj = obj@node(unid);
            if nargin == 2;
                obj.factor = factor;
            end
        end
        
        %implement addNode
        function addNode(obj,node)
            l = length(obj.nodes);
            obj.nodes{l + 1} = node;
            obj.messages{l + 1} = ones(node.dimension,1);
        end
        
        %implement getMessage
        function message = getMessage(obj, to_unid)
            
            %message must be column vector
            message = message(:);
        end

        %display
        function display(obj)
            display@node(obj);
            disp(' ');
            disp('factor is = ');
            disp(obj.factor);
        end     
    end
    
end