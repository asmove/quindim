function [nst, x0, u0] = sszeros(sys)

	% Zustandsraumdarstellung
	A = sys.a;
	B = sys.b;
	C = sys.c;
	D = sys.d;

	% Größe der Matrizen
	[n,p] = size(B);
	[q,n] = size(C);

	Ee = [eye(n) zeros(n,p); zeros(q,n) zeros(q,p)];
	Ae = [A B; -C zeros(q,p)];

	[V,nullstelle] = eig(Ae,Ee);

	anzahl_nullstelle = 0;

	nst = [];
	u0 = [];
	x0 = [];

	for i = 1:n
	    if(~isinf(nullstelle(i,i)))
		anzahl_nullstelle = anzahl_nullstelle+1;
		nst(anzahl_nullstelle) = nullstelle(i,i);
		x0(:,anzahl_nullstelle) = V(1:n,i);
		u0(:,anzahl_nullstelle) = V(n+1:end,i);
	    end
	end

end
