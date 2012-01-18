classdef factor < handle
    
    properties(GetAccess = 'public', SetAccess = 'public')
        factor_matrix
    end
    
    methods
        
        %constructor
        function obj = factor(factor_matrix)
            if nargin == 1
                obj.factor_matrix = factor_matrix;
            end
        end
        
        %only needed method
        function product_matrix = product(obj, product_of_messages)
            product_matrix = product_of_messages .* obj.factor_matrix;
        end
       
        %function to get a value from the matrix
        function value = getValue(obj,varargin)
            
            sz = size(obj.factor_matrix);
            d = 0;
            for i = 1 : length(sz)
                if sz(i) > 1
                    d = d+1;
                end
            end

            cmnd = ['value = obj.factor_matrix(' num2str(varargin{1})];
            for i = 2 : d
                cmnd = [cmnd ', ' num2str(varargin{i})];
            end
            cmnd = [cmnd ');'];
            eval(cmnd);
        end
            
        
        %display
        function display(obj)
            disp(obj.factor_matrix);
        end

    end
end