classdef Nonlinear < dagnn.Layer
    properties
        depthL
        positions
        gp = 1
    end
    
    methods
        function outputs = forward(obj, inputs, params)
        
                if obj.gp
                   outputs{1} = nnlinecu_double(gpuArray(obj.positions), params{1}, inputs{1});   
                else
                   outputs{1} = nnlinemex(obj.positions, double(params{1}), double(inputs{1}));
                end        
                
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
           
                if obj.gp
                [derInputs{1}, derParams{1}] = nnlinecu_double(gpuArray(obj.positions), params{1},inputs{1}, derOutputs{1});    
                    
                else
                [derInputs{1}, derParams{1}] = nnlinemex(obj.positions, double(params{1}), double(inputs{1}), double(derOutputs{1}));
                end
            
            
        end
        
        function params = initParams(obj)
           % r = (1/20);
            params{1} = zeros(length(obj.positions), obj.depthL, 'double');
            for i=1:obj.depthL
                % params{1}(:,i) = nnsoft(obj.positions, r);
                   params{1}(:,i) = max(obj.positions, 0);
            end
        end
        
        function obj = Nonlinear(varargin)
            obj.load(varargin) ;
        end
    end
end