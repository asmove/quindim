function theta = my_atan2(a, b)
    theta = atan2(a, b);
    theta = pi - theta;
end