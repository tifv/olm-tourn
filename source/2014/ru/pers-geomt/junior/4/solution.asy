import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point A = (-1, 0), B = (1, 0), C = dir(70);
triangle ABC = triangle(A, B, C);

real m = 0.45, n = 0.8;

point
    M = (1-m) * A + (m) * B, N = (1-n) * A + (n) * B;

line
    MP = perpendicular(M, line(C, N)),
    NQ = perpendicular(N, line(C, M));

point
    P = intersectionpoint(line(A, C), MP),
    Q = intersectionpoint(line(B, C), NQ),
    HP = intersectionpoint(MP, line(C, N)),
    HQ = intersectionpoint(NQ, line(C, M));

circle
    circumACN = circumcircle(A, C, N),
    circumBCM = circumcircle(B, C, M);

pen circlepen = gray(0.7) + 1;
pen shortdashed = linetype(new real[] {3,3});

draw(circumACN, circlepen + shortdashed);
draw(circumBCM, circlepen + shortdashed);

point D = reflect(circumACN.C, circumBCM.C) * C;

draw(ABC, linewidth(1));
draw(line(A, P, extendA=false));
draw(line(B, Q, extendA=false));

draw(C--M ^^ C--N);

draw(P--HP ^^ Q--HQ);

draw(M--D ^^ N--D ^^ P--Q, dashed);

perpendicularmark(HP, unit(P-HP), dir=SE, size=0.5mr);
perpendicularmark(HQ, unit(Q-HQ), dir=NE, size=0.5mr);

dot(Label("$A$", A, WNW));
dot(Label("$B$", B, ENE));
dot(Label("$C$", C, plain.N));
dot(Label("$M$", M, NW));
dot(Label("$N$", N, NE));
dot(Label("$P$", P, NW));
dot(Label("$Q$", Q, NE));
dot(Label("$D$", D, unit(unit(D - circumACN.C) + unit(D - circumBCM.C))));

