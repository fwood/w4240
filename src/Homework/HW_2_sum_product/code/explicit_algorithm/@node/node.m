% Class : Node
%
% The node class is used to hold the properties of all individual 
% nodes in a small factor graph.  Each node has properties and methods
% associated with it which are documented below.
%
% Properties 
%
% name  : a string value which is a unique identifier of this node
% c     : a cell array of neighboring nodes in the factor graph
% m     : a cell array of column vectors which are the most recent messages
%         received from each of the neihboring nodes.  c and m should have 
%         the same length and m{i} will refer the the most recent message 
%         received from c{i}
% set   : an indicator that this node has been observed.  this should only 
%         be set for nodes which are variable nodes.
% value : if this is a variable node which has been observed, this is the 
%         observed value.

classdef node < handle
    
    properties
        name
        c = {};
        m = {};
        set = false;
        value
    end
    
    methods
        % node : constructor method called to create a node object
        %
        % args  n : name for this node
        %       c : neighboring nodes
        %       m : messages from neihboring nodes
        function obj = node(n,c,m)
            if nargin == 1
                obj.name = n;
            else
                obj.name = n;
                obj.c = c;
                obj.m = m;
            end
        end
        
        % setcm : sets the values of c and m for the node object
        %
        % args  c : value for property c (neighboring nodes)
        %       m : value for property m (messages from neighboring nodes)
        function setcm(obj,c,m)
            obj.c = c;
            obj.m = m;
        end
        
        % set_value : sets the value property of this node and switches the
        %             set indicator to true
        %
        % args  value : observed value of node
        function set_value(obj, value)
            obj.value = value;
            obj.set = true;
        end
        
        % display : customizes the result of trying to display a node
        %           object
        function display(obj)
            disp(' ');
            disp(['this node is node ' obj.name]);
            if obj.set
                disp(['node is set to ' num2str(obj.value)]);
            end
            disp(' ');
            disp('the neighboring nodes are : ');
            for i = 1 : length(obj.c)
                disp(obj.c{i}.name)
            end
            disp(' ');
            disp('the most recent messages are : ');
            for i = 1 : length(obj.m)
                disp(obj.m{i})
            end
        end
    end
end