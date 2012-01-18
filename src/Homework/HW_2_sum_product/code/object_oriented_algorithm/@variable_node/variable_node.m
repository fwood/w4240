% variable_node
%
% Object specifically for variable nodes.
%
% properties
%
% dimension : dimension of discrete variable represented by node
% observed  : indicator indicating if the variable is observed
% value     : value of the node if it has been observed
%
classdef variable_node < node
    
    properties(GetAccess = 'public', SetAccess = 'public')
        dimension
        observed = false;
        value
    end
    
    methods
        
        % variable_node : method to construct the this variable node
        %
        % @param unid      : unique identifier for this node
        % @param dimension : dimension of this node 
        %
        function obj = variable_node(unid, dimension)
            obj = obj@node(unid);
            if nargin == 2
                obj.dimension = dimension;
            end
        end
        
        % addNode : method to add a neighboring node to the list of
        %           neighboring nodes
        %
        % @param node : node to add as neighbor
        %
        function addNode(obj,node)
            l = length(obj.nodes);
            obj.nodes{l + 1} = node;
            obj.messages{l + 1} = ones(obj.dimension,1);
        end
        

        % getMessage : override of getMessage in node class.  THIS IS A
        %              METHOD WHICH MUST BE FILLED OUT BY THE STUDENT
        %
        % @param to_unid : node to which message is being passed.
        function message = getMessage(obj, to_unid)
            if obj.observed
                ?;
            else
                ?;
            end
            %message must be column vector
            message = message(:);
        end
        
        % passMessagesIn : method to pass messages from the edge to this
        %                  node
        %
        function passMessagesIn(obj)
            for i = 1 : length(obj.nodes)
                obj.messages{i} = obj.nodes{i}.passMessageIn(obj.unid);
            end
        end
        
        % passMessagesOut : method to pass messages out from this node to
        %                   the edges
        %
        function passMessagesOut(obj)
            for i = 1 : length(obj.nodes)
                obj.nodes{i}.passMessageOut(obj.unid);
            end
        end
        
        % getMarginalDistribution : method to get the marginal distribution
        %                           of the variable represented by this
        %                           node. THIS IS A METHOD WHICH MUST BE
        %                           FILLED OUT BY THE STUDENT.
        %
        function prob = getMarginalDistribution(obj)
            if obj.observed
               ?;
            else 
                ?;
            end
        end
        
        % setValue : method to set the vaue of this variable node.
        function setValue(obj, val)
            obj.value = val;
            obj.observed = true;
        end
        
        % display : overrides the default display behavior
        function display(obj)
            display@node(obj);
            disp(' ');
            disp('var dimension is = ');
            disp(obj.dimension);
            disp(' ');
            if obj.observed
                disp(['this var is observed as ' num2str(obj.value)]);
            else
                disp('this var is hidden');
            end
        end
    end
end