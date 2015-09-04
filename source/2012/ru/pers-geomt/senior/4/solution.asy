import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (0,-1), C = 2dir(30),
    ABC = triangle(A, B, C),
    IA = excenter(ABC.BC),
    IB = excenter(ABC.CA),
    IC = excenter(ABC.AB),
    exABC = triangle(IA, IB, IC),
    LA = extension(B, C, IB, IC),
    LB = extension(A, C, IA, IC),
    LC = extension(A, B, IA, IB),
    A1 = projection(line(B, C)) * IA,

    ell = line(LA, LB),
    circ = circumcircle(A, A1, IA);

pen gray = gray(0.7);

draw(ell, gray+1);
clipdraw(circ, gray+1);

draw(ABC, linewidth(1));
draw(exABC);
draw(IA--A1);

draw(B--LA ^^ IC--LA ^^ IC--LB ^^ A--LB ^^ A--LC ^^ IB--LC);

perpendicularmark(A1, unit(IA-A1), dir=NE, size=0.5mr);

dot(Label( "$A$", A, 1.2unit(unit(LC-A) + unit(LB-A)) ));
dot(Label( "$B$", B, 1.2unit(unit(IA-B) + unit(LA-B)) ));
dot(Label("$C$", C, unit(LC-IA)/I));

dot(Label( "$L_A$", LA, unit(unit(ell.v) + unit(LA-circ.C)) ));
dot(Label("$L_B$", LB, ell.v));
dot(Label("$L_C$", LC, ell.v));

dot(Label("$I_A$", IA, unit(IA-circ.C)));
dot(Label("$I_B$", IB, unit(LC-IA)/I));
dot(Label(
    scale(0.6) * "$I_C$", IC,
    unit(unit(LB-IC) + unit(LA-IC))
));
dot(Label("$A_1$", A1, 1.7 unit(IA-A1) / NE));

