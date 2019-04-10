classdef Conv2D < dagnn.Layer
    properties
        size = [5 5 1 128] 
    end
    
    methods
        function outputs = forward(obj, inputs, params)
          
            pad1 = (obj.size(1) -1) / 2;
            outputs{1} = vl_nnconv(inputs{1}, params{1}, params{2}, 'pad', pad1);
          
        end
        
        
        
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
              pad1 = (obj.size(1) -1) / 2;
             [derInputs{1}, derParams{1}, derParams{2}] = vl_nnconv(inputs{1}, params{1}, params{2},derOutputs{1}, 'pad', pad1) ;
     
        end
            
            function params = initParams(obj)

             sc = sqrt(2 / (obj.size(1) * obj.size(2) * obj.size(3) * obj.size(4) )) ;
             params{1} = randn(obj.size,'double') * sc ;
             params{2} = zeros(1, obj.size(4) ,'double');
             end

        
           
            
            function obj = Conv2D(varargin)
                obj.load(varargin) ;
               
            end
       
    end
end



