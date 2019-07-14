function ctb = beobachtbarKalman(sys)

A = sys.a;
C = sys.c;

n = length(A);

Ms = C;

for i = 2:n
    Ms = [Ms;C*A^(i-1)];
end

if(rank(Ms) == n)
    ctb = 1;
    disp('Das System ist vollst‰ndig beobachtbar gem‰ﬂ Kalman!');
else
    ctb = 0;
    disp('Das System ist nicht beobachtbar gem‰ﬂ Kalman!');
end

end