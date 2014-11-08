import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0,0), D = (3, 0), B = (0.5, 1.5), E = B + D - A;

point
    P = bisectorpoint(triangle(A, B, D).BC),
    Q = bisectorpoint(triangle(E, D, B).BC);

point
    C = 0.3 Q + 0.7 E;

draw(A--B--C--D--cycle, linewidth(1));

draw(A--P ^^ B--D ^^ C--Q);
draw(B--E--D ^^ E--C, dashed);

mark(B--P, tildeframe);
mark(Q--D, tildeframe);

markangle(B, C, Q, radius=mr);
markangle(Q, C, D, radius=0.75mr);

markangle(D, A, P, n=2, radius=mr);
markangle(P, A, B, n=2, radius=0.75mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NW));
dot(Label("$C$", C, NNW));
dot(Label("$D$", D, SE));
dot(Label("$E$", E, NE));
dot(Label("$Q$", Q, SSW));
dot(Label("$P$", P, NNE));

