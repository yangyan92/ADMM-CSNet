classdef NMSE < dagnn.Layer
    properties

    end
    
    properties (Transient)
        average = 0
        numAveraged = 0
    end
    
    methods
        function outputs = forward(obj, inputs, params)
     
            x = inputs{1};
            x_gt = inputs{2};
            
            B = sqrt(x_gt(:)' * x_gt(:));
            S = double(x(:)) - double(x_gt(:));
            outputs{1} = sqrt(S(:)'*S(:)) / B;
            
          
           
            n = obj.numAveraged ;
            m = n + size(inputs{1},3) ;
            obj.average = (n * obj.average + outputs{1}) / m ;
            obj.numAveraged = m ;
        end
        
        function [derInputs, derParams] = backward(obj, inputs  ,params, derOutputs)
             x = inputs{1};
           x_gt = inputs{2};
      
           
            
            B =sqrt( x_gt(:)' * x_gt(:));
            S = double(x(:)) - double(x_gt(:));
            RR = sqrt(S(:)'*S(:));
            derInputs{1} = derOutputs{1} * S/ (RR*B);
            derInputs{2} = [];
            derParams = [];
        end
        
        function reset(obj)
            obj.average = 0 ;
            obj.numAveraged = 0 ;
        end
        
        function obj = NMSE(varargin)
            obj.load(varargin) ;
        end
    end
end