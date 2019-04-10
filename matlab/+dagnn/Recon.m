classdef Recon < dagnn.Layer
    properties 
        gp = 1
      
    end
    
    methods
        function outputs = forward(obj, inputs, params)
            A = inputs{1}.A;
            At = inputs{1}.At;
          
            if numel(inputs) == 2
                
                 outputs{1} =  params{1} * inputs{2};
                   
          
            elseif numel(inputs) == 4    
                Z = inputs{3};
                M = inputs{4};
               if obj.gp
                 inputs{2} = gather(inputs{2});
                 params{1} = gather(params{1}); 
                Z = gather(Z); 
                M = gather(M);   
               end
               B = params{1} * At( A( Z - M ) );
               O =  params{1} * inputs{2} + Z - M - B;
               outputs{1} = real(O);
                if obj.gp
                    outputs{1} = gpuArray(outputs{1});   
                   end            
            end    
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
          A = inputs{1}.A;
          At = inputs{1}.At;
            
            if numel(inputs) == 2

                derParams{1} = derOutputs{1}(:)' * inputs{2}(:);
                derInputs{1} = [];
                derInputs{2} = [];
                
            elseif numel(inputs) == 4 
                 
                Z = inputs{3};
                M = inputs{4};
               if obj.gp
                 inputs{2} = gather(inputs{2});
                 params{1} = gather(params{1});
                Z = gather(Z); 
                M = gather(M);
                derOutputs{1} = gather(derOutputs{1});
               end
               B = inputs{2}(:) - At( A( Z - M ) );
               derParams{1} = derOutputs{1}(:)' * real(B);
               derInputs{1} = [];
               derInputs{2} = [];
               Dx = params{1} * At( A(  derOutputs{1}(:)  ) );
               derInputs{3} = derOutputs{1}(:) -  real(Dx);
               derInputs{4} = - derInputs{3};
                if obj.gp
                  derInputs{4} = gpuArray( derInputs{4});
                  derInputs{3} = gpuArray( derInputs{3});
                end
                
            else
                error('invalid inputs!\n');
            end
            
        end
        
        function params = initParams( obj )
           
            %mu = 4.4727;
            mu=1;
            
            Rho = 1e-5;
            params{1}  = mu /(  1 + Rho ); 
            
        end
        
        function obj = Recon(varargin)
            obj.load(varargin) ;
        end
    end
end