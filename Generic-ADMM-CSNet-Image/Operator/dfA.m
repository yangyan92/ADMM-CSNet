function y = dfA(x,picks,perm,mode)
switch mode
    case 1
        y = A_fWH(x,picks,perm);
    case 2
        y = At_fWH(x,picks,perm);
    otherwise
        error('Unknown mode passed to f_handleA!');
end
