function f = state_space(sys)
    qps = [];
    for i = 1:length(sys.qp)
       qps = [qps; sys.qp{i}];
    end
    
	identity = eye(size(sys.mass_matrix));
    Minv = simplify(sys.mass_matrix\identity);
    qpps = simplify(Minv*(sys.reqdyns - sys.coriolis - sys.gravitational));
    
    f = [qps; qpps];
end