
invH = inv(sys.dyn.H);

q = sys.kin.q;
p = sys.kin.p{end};

h = sys.dyn.h;
Z = sys.dyn.Z;
u = sys.descrip.u;
C = sys.kin.C;

plant = [C*p ; invH*(-h + Z*u)];

G = equationsToMatrix(plant, u);
f = simplify_(plant - G*u);
y = [th1; th2; th3];
x = [q; p];

[n, m] = size(G);

lie_f_h = jacobian(y, x)*f;
lie_G_h = jacobian(y, x)*G;

lie2_f_h = jacobian(lie_f_h, x)*f;
lie_G_lie_f_h = jacobian(lie_f_h, x)*G;
