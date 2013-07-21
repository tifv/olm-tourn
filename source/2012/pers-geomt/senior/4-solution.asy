import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;

var
    A = (0,0), B = (0,-1), C = 2dir(30),
    ABC = triangle(A, B, C),
    IA = excenter(ABC.BC),
    IB = excenter(ABC.CA),
    IC = excenter(ABC.AB),
    LA = extension(B, C, IB, IC),
    LB = extension(A, C, IA, IC),
    LC = extension(A, B, IA, IB),
    A1 = projection(line(B, C)) * IA,

    ell = line(LA, LB),
    circ = circumcircle(A, A1, IA);

// Gray
draw(ell, p=gray(0.5));
clipdraw(circ, p=gray(0.5));

draw(B--LA);
draw(IC--LA);
draw(IC--LB);
draw(A--LB);
draw(A--LC);
draw(IB--LC);

draw(A--B--C--cycle, p=black+1.5);
draw(IA--IB--IC--cycle, p=black+1);
draw(IA--A1);

perpendicularmark(A1, unit(B-A1), dir=NE, size=0.5mr);

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
dot(A1);

