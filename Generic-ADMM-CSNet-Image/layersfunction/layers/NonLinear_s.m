function layer = NonLinear_s(obj, varargin)

layer = Layer(@dy_nonlinear, obj, varargin{:});

end