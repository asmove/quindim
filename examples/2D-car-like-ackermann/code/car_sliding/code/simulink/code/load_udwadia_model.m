hol_constraints = sys.descrip.hol_constraints{1};
dhol_constraints = dvecdt(hol_constraints, sys.kin.q, sys.kin.qp);
A_hol = equationsToMatrix(dhol_constraints, sys.kin.qp);

unhol_constraints = sys.descrip.unhol_constraints{1};
A_unhol = equationsToMatrix(unhol_constraints, sys.kin.qp);

A = sys.kin.A;

A_1delta = [A_hol; A_unhol];
C_1delta = null(A_1delta);

C_delta = null(A_1delta) - null(A);