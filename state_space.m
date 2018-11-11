function sys = state_space(sys)
    qps = [];
    for i = 1:length(sys.qp)
       qps = [qps; sys.qp{i}];
    end
    
    Minv = simplify(sys.mass_matrix\eye(size(sys.mass_matrix)));
    qpps = simplify(Minv*(-sys.coriolis - sys.gravitational + sys.reqdyns));
    
    sys.f = [qps; qpps];
end