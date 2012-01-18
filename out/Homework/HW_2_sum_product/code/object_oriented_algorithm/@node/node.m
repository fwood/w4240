% node : this object is the basic element of a graph.  for inference on
%        factor graphs we will need both factor nodes and variable nodes.  
%        both of those types of objects will be descended from this object.
%
% properties
%
% unid      : unique string identifier for the node
% nodes     : cell array of neighboring nodes
% messages  : cell array of messages from neighbor nodes.  all messages are
%             column vectors
% updated   : indicator variable for scheduling of message passing in loopy
%             beleif propagation
%

classdef node < handle
    
    properties(GetAccess = 'public', SetAccess = 'public')
        unid = ' ';
        nodes = {};
        messages = {};
        updated = 0;
    end

    methods
        % node : constructor method to create the object
        %
        % @param unid   : unique string identifier for this object
        %
        function obj = node(unid)
            if nargin == 1
                obj.unid = unid;
            end
        end
        
        % setNotUpdated : recursive method to set this the updated field of
        %                 this node and recursively all nodes in the graph 
        %                 to 0
        %
        function setNotUpdated(obj)
            obj.updated = 0;
            for i = 1 : length(obj.nodes)
                if obj.nodes{i}.updated
                    obj.nodes{i}.setNotUpdated;
                end
            end
        end
        
        % loopy_bp : recursive method to prompt this node and recursively
        %            all nodes in the graph to update their received
        %            messages
        %
        function loopy_bp(obj)
            obj.updateMessages;
            obj.updated = 1;
            for i = 1 : length(obj.nodes)
                if ~obj.nodes{i}.updated
                    obj.nodes{i}.loopy_bp;
                end
            end
        end
            
        % updateMessages : method to ask all neighboring nodes for an
        %                  updated message
        %
        function updateMessages(obj)
            for i = 1 : length(obj.nodes)
                obj.messages{i} = obj.nodes{i}.getMessage(obj.unid);
            end
        end
        
        % passMessageIn : recursive method to pass messages in from the 
        %                 edges to the given node
        %
        % @param to_unid : node to which message is being passed
        %
        function message = passMessageIn(obj, to_unid)
            obj.unid
            for i = 1 : length(obj.nodes)
                if ~strcmp(obj.nodes{i}.unid, to_unid)
                    obj.messages{i} = obj.nodes{i}.passMessageIn(obj.unid);
                end
            end
            
            message = obj.getMessage(to_unid);
        end
        
        % passMessageOut : recursive method to pass messages out to the 
        %                  corners from a central node
        %
        % @param from_unid : node from which we were prompted to pass
        %                    messages out, i.e. node to which we do not 
        %                    need to pass a message
        %
        function passMessageOut(obj,from_unid)
            ind = -1;
            for i = 1 : length(obj.nodes)
                if strcmp(obj.nodes{i}.unid, from_unid)
                    ind = i;
                    break;
                end
            end
            
            assert(ind > -1 , 'must be connected to eachother');
            
            obj.messages{i} = obj.nodes{i}.getMessage(obj.unid);
            
            for i = 1 : length(obj.nodes)
                if i ~= ind
                    obj.nodes{i}.passMessageOut(obj.unid);
                end
            end
        end
        
        % addNode : add a node to the neighbor node cell array
        %
        function addNode(obj,node);
            error('this function is meant to be abstract and over written');
        end
        
        % getMessage : get the message to the given node
        %
        % @param to_unid : node to which the message is being passed
        %
        function message = getMessage(obj, to_unid)
            error('this function is meant to be abstract and over written');
        end
        
        % display : overide of default display behavior
        %
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