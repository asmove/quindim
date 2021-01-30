function p = point(T, d)
    p_ = T*[d; 1];
    p = p_(1:3);
end