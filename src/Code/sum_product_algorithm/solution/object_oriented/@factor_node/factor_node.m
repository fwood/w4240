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
            cmnd = 'prod_matrix = multilinear_product(';
            for i = 1 : length(obj.messages)
                if i > 1
                    cmnd = [cmnd ', '];
                end
                
                if strcmp(obj.nodes{i}.unid, to_unid)
                    cmnd = [cmnd 'ones(size(obj.messages{' num2str(i) '},1),1)'];
                else
                    cmnd = [cmnd 'obj.messages{' num2str(i) '}'];
                end
            end
            
            cmnd = [cmnd ');'];
            eval(cmnd);
            
            prod_message = obj.factor.product(prod_matrix); %#ok<NASGU>
            
            cmnd = [];
            for i = 1 : (length(obj.messages) - 1)
                cmnd = [cmnd 'sum('];
            end
            
            cmnd = [cmnd 'prod_message'];
            
            for i = 1 : (length(obj.messages))                
                if ~strcmp(obj.nodes{i}.unid, to_unid)
                    cmnd = [cmnd ',' num2str(i) ')'];
                end
            end
           
            message = eval(cmnd);
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