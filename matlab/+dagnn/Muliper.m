classdef Muliper < dagnn.Layer
    properties 
        
    end
    
    methods
        function outputs = forward(obj, inputs, params)
          if numel(inputs) == 2
               outputs{1} =  params{2} * inputs{1} - params{3} *inputs{2};
          end
                    if numel(inputs) == 3
           outputs{1} = params{1} * inputs{1} + params{2} * inputs{2} - params{3} *inputs{3};
             end        
  
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            if numel(inputs) == 2
              derParams{1} = 0;
              derParams{2} = - derOutputs{1}(:)' * inputs{1}(:);
              derParams{3} = - derOutputs{1}(:)' * inputs{2}(:);
                derInputs{1} =  params{2} * derOutputs{1};
                  derInputs{2} =  params{3} * derOutputs{1};
            end
           if numel(inputs) == 3
           derParams{1} = derOutputs{1}(:)' * inputs{1}(:);
           derParams{2} = derOutputs{1}(:)' * inputs{2}(:);
           derParams{3} = - derOutputs{1}(:)' * inputs{3}(:);
           derInputs{1} =  params{1} * derOutputs{1};
           derInputs{2} =  params{2} * derOutputs{1};
            derInputs{3} = - params{3} * derOutputs{1};
           end    
        end
        
        function params = initParams( obj )
           
            mu = 1;
            e = 0.0064;
            params{1}  = mu * e ; 
             params{2}  = mu * e ; 
              params{3}  = e ; 
        end
        
        function obj = Muliper(varargin)
            obj.load(varargin) ;
        end
    end
end