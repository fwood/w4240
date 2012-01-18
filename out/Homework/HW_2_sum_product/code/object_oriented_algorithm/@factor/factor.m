% factor : this class is a container class for the factor matrix
%
% properties
%
% factor_matrix : a tensor which given the factor value for any
%                 configuration of the neighboring variable nodes
%
classdef factor < handle
    
    properties(GetAccess = 'public', SetAccess = 'public')
        factor_matrix
    end
    
    methods
        
        % factor : constructor method for object
        %
        % @param factor_matrix : factor matrix
        %
        function obj = factor(factor_matrix)
            if nargin == 1
                obj.factor_matrix = factor_matrix;
            end
        end
        
        % product_matrix : method to get the result of an element wise
        %                  product of an input tensor and the factor matrix
        %
        % @param product_of_messages : tensor to product with factor matrix
        %
        function product_matrix = product(obj, product_of_messages)
            product_matrix = product_of_messages .* obj.factor_matrix;
        end
       
        % getValue : method to get the value of a given element of the
        %            factor matrix
        %
        % @param varargin : variable length input array of indices into
        %                   factor matrix.  varargin should have the same
        %                   number of values as the factor matrix has
        %                   dimensions.
        %
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
            
        
        % display : overides the default display behavior
        %
        function display(obj)
            disp(obj.factor_matrix);
        end

    end
end