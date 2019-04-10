classdef Minus < dagnn.Layer
    properties
    
    end
    
    methods
        function outputs = forward(obj, inputs, params)
        mu = 1;
        
        outputs{1} = (inputs{1}(:) - inputs{2}(:)) * 255 * mu;

        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            mu = 1;
           derParams{1} = [];
           derInputs{1} = reshape(derOutputs{1}, size(inputs{2})) * 255 * mu;
           derInputs{2} = - reshape(derOutputs{1}, size(inputs{2})) * 255 * mu;
            
        end
        
        
        
        function obj = Minus(varargin)
            obj.load(varargin) ;
        end
    end
end