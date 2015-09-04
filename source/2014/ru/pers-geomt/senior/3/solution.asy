import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0, 0), C = (3, 0), B = (1, 3);

triangle ABC = triangle(A, B, C);

point
    L = bisectorpoint(ABC.AC),
    D = (B + L) / 2;

line
    AD = line(A, D, extendA=false, extendB=false),
    CD = line(C, D, extendA=false, extendB=false);

point
    E = intersectionpoints(AD, circle(B, C))[0],
    F = intersectionpoints(CD, circle(B, A))[0];

point
    K = intersectionpoint(line(A, B), parallel(C, line(B, L))),
    M = (K + C) / 2;

pen gray = gray(0.7);

draw(C--D ^^ B--F--A, gray);
perpendicularmark(F, unit(A-F), dir=SE, size=0.5mr, p=gray);
dot(F, gray);

draw(ABC, linewidth(1));

draw(B--L ^^ A--D ^^ B--E--C);
draw(B--K--C ^^ D--M);

markangle(A, B, L, radius=1.3mr);
markangle(L, B, C, radius=mr);
markangle(K, C, B, radius=mr);
markangle(B, K, C, radius=mr);

perpendicularmark(E, unit(C-E), dir=NE, size=0.5mr);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, WNW));
dot(Label("$C$", C, SSE));
dot(Label("$L$", L, plain.S));
dot(Label("$D$", D, WNW));
dot(Label("$E$", E, SSE));
dot(Label("$K$", K, ENE));
dot(Label("$M$", M, ENE));

