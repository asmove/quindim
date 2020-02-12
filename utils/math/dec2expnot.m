function [a, b] = dec2expnot(num)
    b = floor(log10(num));
    a = num*10^(-b);
end