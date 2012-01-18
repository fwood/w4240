classdef variable_node < node

    properties(GetAccess = 'public', SetAccess = 'public')
        dimension
        observed = false;
        value
    end
    
    methods
        
        %constructor
        function obj = variable_node(unid, dimension)
            obj = obj@node(unid);
            if nargin == 2
                obj.dimension = dimension;
            end
        end
        
        %add a neighboring node
        function addNode(obj,node)
            l = length(obj.nodes);
            obj.nodes{l + 1} = node;
            obj.messages{l + 1} = ones(obj.dimension,1);
        end
        

        %implement getMessage
        function message = getMessage(obj, to_unid)
            if obj.observed
                ?;
            else
                ?;
            end
            %message must be column vector
            message = message(:);
        end
        
        %pass all the messages in to this root
        function passMessagesIn(obj)
            for i = 1 : length(obj.nodes)
                obj.messages{i} = obj.nodes{i}.passMessageIn(obj.unid);
            end
        end
        
        %pass all the messages out to the edges
        function passMessagesOut(obj)
            for i = 1 : length(obj.nodes)
                obj.nodes{i}.passMessageOut(obj.unid);
            end
        end
        
        %get marginal distribution
        function prob = getMarginalDistribution(obj)
            if obj.observed
               ?;
            else 
                ?;
            end
        end
        
        %set value
        function setValue(obj, val)
            obj.value = val;
            obj.observed = true;
        end
        
        %display
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