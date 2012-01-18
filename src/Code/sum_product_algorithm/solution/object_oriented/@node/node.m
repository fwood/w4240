classdef node < handle
    
    properties(GetAccess = 'public', SetAccess = 'public')
        unid = ' ';
        nodes = {};
        messages = {};
        %for loopy bp
        updated = 0;
    end

    methods
        %constructor
        function obj = node(unid)
            if nargin == 1
                obj.unid = unid;
            end
        end
        
        function setNotUpdated(obj)
            obj.updated = 0;
            for i = 1 : length(obj.nodes)
                if obj.nodes{i}.updated
                    obj.nodes{i}.setNotUpdated;
                end
            end
        end
        
        function loopy_bp(obj)
            obj.updateMessages;
            obj.updated = 1;
            for i = 1 : length(obj.nodes)
                if ~obj.nodes{i}.updated
                    obj.nodes{i}.loopy_bp;
                end
            end
        end
            
        function updateMessages(obj)
            for i = 1 : length(obj.nodes)
                obj.messages{i} = obj.nodes{i}.getMessage(obj.unid);
            end
        end
        
        function message = passMessageIn(obj, to_unid)
            obj.unid
            for i = 1 : length(obj.nodes)
                if ~strcmp(obj.nodes{i}.unid, to_unid)
                    obj.messages{i} = obj.nodes{i}.passMessageIn(obj.unid);
                end
            end
            
            message = obj.getMessage(to_unid);
        end
        
        function passMessageOut(obj,from_unid)
            ind = -1;
            for i = 1 : length(obj.nodes)
                if strcmp(obj.nodes{i}.unid, from_unid)
                    ind = i;
                    break;
                end
            end
            
            assert(ind > -1 , 'must be connect to eachother');
            
            obj.messages{i} = obj.nodes{i}.getMessage(obj.unid);
            
            for i = 1 : length(obj.nodes)
                if i ~= ind
                    obj.nodes{i}.passMessageOut(obj.unid);
                end
            end
        end
        
        function addNode(obj,node);
            error('this function is meant to be abstract and over written');
        end
        
        function message = getMessage(obj, to_unid)
            error('this function is meant to be abstract and over written');
        end
        
        function display(obj)
            disp(' ');
            disp('discription : ');
            disp(obj.unid);
            disp(' ');
            disp(['this node has ' num2str(length(obj.nodes)) ' neighboring nodes, they are']); 
            for i = 1 : length(obj.nodes)
                disp(obj.nodes{i}.unid);
            end
        end
        
    end
end