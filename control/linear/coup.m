function [R, F] = coup(sys,Cvk, ew, P)

	% Zustandsraumdarstellung
	A = sys.a;
	B = sys.b;
	C = sys.c;
	D = sys.d;

	% Größe der Matrizen
	[n,p] = size(B);
	[q,n] = size(C);

end
