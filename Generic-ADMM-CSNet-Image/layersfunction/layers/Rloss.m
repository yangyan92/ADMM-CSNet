function layer = Rloss(obj, varargin)

layer = Layer(@rnnloss, obj, varargin{:});

end