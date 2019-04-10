classdef ADD < dagnn.Layer
    properties
        ImageSize  
    end
    
    methods
        function outputs = forward(obj, inputs, params)
        config;
        Size = nnconfig.ImageSize;
         a = 0;
         if numel(inputs) == 2
         a = inputs{2};
         end
        O = (inputs{1} + a )/255;
%         outputs{1} = reshape(O, obj.ImageSize);
%          outputs{1} = reshape(O, 321,481);
        outputs{1} = reshape(O, Size);
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            
            
            
           derParams{1} = [];
           derInputs{1} = derOutputs{1}(:)/255;
           if numel(inputs) == 2
           derInputs{2} = derInputs{1};
           end
           
        end
        
        
        
        function obj = ADD(varargin)
            obj.load(varargin) ;
        end
    end
end