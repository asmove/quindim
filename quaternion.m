function q = quaternion(angle, vec)
    q = [cos(angle/2); sin(angle/2)*vec];
end