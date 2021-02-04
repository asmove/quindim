function [T] = T2d(theta, d)
    T = [rot2d(theta), d; zeros(1, 2), 1];
end