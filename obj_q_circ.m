function obj = obj_q_circ(q_circ, error)
    obj = 0.5*error(q_circ).'*error(q_circ);
    gradObj = error(q_circ);
end