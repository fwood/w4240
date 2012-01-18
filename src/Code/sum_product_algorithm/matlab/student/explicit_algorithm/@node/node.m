classdef node < handle
    
    properties
        name
        c = {};
        m = {};
        set = false;
        value
    end
    
    methods
        function obj = node(n,c,m)
            if nargin == 1
                obj.name = n;
            else
                obj.name = n;
                obj.c = c;
                obj.m = m;
            end
        end
        
        function setcm(obj,c,m)
            obj.c = c;
            obj.m = m;
        end
        
        function set_value(obj, value)
            obj.value = value;
            obj.set = true;
        end
        
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