import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    B = (0, 0), A = (4, 0), C = (3, 2);

triangle ABC = triangle(A, B, C);

point
    IB = excenter(ABC.AC), IC = excenter(ABC.AB),
    C1 = projection(ABC.AB) * IC,
    A2 = projection(ABC.BC) * IB,
    C2 = projection(ABC.BA) * IB,
    M = (B + IB) / 2,
    Ap = projection(ABC.BC) * M,
    Cp = projection(ABC.BA) * M;

point ICr = 0.4 IC + 0.6 C1;
point ICr1 = 0.3 ICr + 0.7 C1;
point ICr2 = 0.7 ICr + 0.3 C1;

draw(ABC, linewidth(1));

draw(line(B, IB, extendA=false));
draw(line(A, C2, extendA=false));
draw(line(C, A2, extendA=false));
draw(IB--A2 ^^ IB--C2);

draw(M--Ap ^^ M--C ^^ M--Cp ^^ M--C1);

draw(C1--ICr1);
draw(ICr1--ICr2, dotted);
draw(ICr2--ICr);

markangle(A, B, IB, n=2, radius=mr);
markangle(IB, B, C, n=2, radius=mr);

markangle(Cp, C1, M, radius=mr);
markangle(Ap, C, M, radius=mr);

perpendicularmark(A2, unit(IB-A2), dir=NE, size=0.5mr);
perpendicularmark(C2, unit(IB-C2), dir=SE, size=0.5mr);

perpendicularmark(C1, unit(IC-C1), dir=NE, size=0.5mr);

perpendicularmark(Ap, unit(M-Ap), dir=NE, size=0.5mr);
perpendicularmark(Cp, unit(M-Cp), dir=SE, size=0.5mr);

dot(Label("$A$",   A, S));
dot(Label("$B$",   B, NW));
dot(Label("$C$",   C, NW));
dot(Label("$I_b$", IB, NNE));
dot(Label("$A_2$", A2, NW));
dot(Label("$C_2$", C2, SSE));
dot(Label("$M$",   M, SE));
dot(Label("$A'$",  Ap, NW));
dot(Label("$C'$",  Cp, S));
//dot(Label("$I_c$", IC, NW));
dot(Label("$I_c$", 0.4IC+0.6C1, SE));
dot(Label("$C_1$", C1, S+W));

