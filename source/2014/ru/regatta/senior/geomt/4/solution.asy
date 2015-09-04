import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0,0), B = (4, 0), C = (2, 3);
triangle ABC = triangle(A, B, C);

point P = (2, 1);
real alpha = 0.2;

point
    A1 = projection(ABC.BC, rotate(degrees(alpha)) * altitude(ABC.BC)) * P,
    B1 = projection(ABC.CA, rotate(degrees(alpha)) * altitude(ABC.CA)) * P,
    C1 = projection(ABC.AB, rotate(degrees(alpha)) * altitude(ABC.AB)) * P;

circle
    circA = circumcircle(A, B1, C1),
    circB = circumcircle(B, C1, A1),
    circC = circumcircle(C, A1, B1);

point O1 = circA.C, O2 = circB.C, O3 = circC.C;

point M = projection(ABC.AB) * O1, N = projection(ABC.AB) * O2;

pen circlepen = gray(0.7) + 1;

clipdraw(circA, p=circlepen);
draw(circB, p=circlepen);
draw(circC, p=circlepen);

draw(ABC, linewidth(1));

draw(O1--O2--O3--cycle);

draw(O1--M ^^ O2--N, dashed);

markangle(B, A, C, n=1, radius=mr);
markangle(O2, O1, O3, n=1, radius=0.7mr);

markangle(C, B, A, n=2, radius=mr);
markangle(O3, O2, O1, n=2, radius=0.7mr);

markangle(A, C, B, n=3, radius=mr);
markangle(O1, O3, O2, n=3, radius=0.7mr);

perpendicularmark(M, unit(B-M), dir=NW, size=0.4mr);
perpendicularmark(N, unit(B-N), dir=NW, size=0.4mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, plain.N));
dot(Label("$P$", P, SW));
dot(Label("$A_1$", A1, NE));
dot(Label("$B_1$", B1, NW));
dot(Label("$C_1$", C1, S));
dot(Label("$O_1$", O1, WNW));
dot(Label("$O_2$", O2, SE));
dot(Label("$O_3$", O3, ENE));
dot(Label("$M$", M, S));
dot(Label("$N$", N, S));

