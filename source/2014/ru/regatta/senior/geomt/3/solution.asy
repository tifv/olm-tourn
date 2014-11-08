import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (-1, 0), B = (1, 0), C = (0, 2.5);
real alpha = 0.3;

triangle ABC = triangle(A, B, C);
circle circumABC = circumcircle(ABC);
line
    AN = rotate(degrees(alpha), A) * line(A, B),
    BN = rotate(degrees(alpha), B) * line(B, C);
point N = intersectionpoint(AN, BN);
line CD = parallel(C, AN);
point D = intersectionpoint(CD, BN);
point P = intersectionpoint(bisector(line(A, N), line(A, C)), bisector(line(B, N), line(B, A)));
point E = reflect(perpendicular(circumABC.C, line(D, P))) * D;

draw(circumABC, gray(0.7) + 1);

draw(ABC, linewidth(1));

draw(A--N ^^ B--D ^^ C--D ^^ A--D ^^ D--E ^^ A--P--B);

markangle(C, B, D, n=1, radius=1.5mr);
markangle(B, A, N, n=1, radius=1.5mr);
markangle(C, A, D, n=1, radius=1.5mr);

markangle(D, B, A, n=2, radius=0.7mr);
markangle(N, A, C, n=2, radius=0.7mr);
markangle(D, C, A, n=2, radius=0.7mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, plain.N));
dot(Label("$D$", D, NW));
dot(Label("$E$", E, SSE));
dot(Label("$P$", P, NE));
dot(Label("$N$", N, S+0.5SW));
