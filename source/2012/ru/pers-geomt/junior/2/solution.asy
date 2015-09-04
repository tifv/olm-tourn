import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var 
    A = (0, 0), D = (2, 0),
    O = (1, 0) + dir(85),
    theta = 0.5,
    C = O + (O - A) * theta,
    B = O + (O - D) * theta,
    K = (theta * A + B) / (theta + 1),
    L = (theta * D + C) / (theta + 1),
    T = (A + B) / 2,
    M = 2 * T - K;

draw(A--B--C--D--cycle, linewidth(1));
draw(A--C);
draw(B--D);
draw(K--L);
draw(T--O);
draw(M--L);

mark(A--M, 1);
mark(K--B, 1);

perpendicularmark(O, unit(D-O), NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NW));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, SE));
dot(Label("$K$", K, NW));
dot(Label("$L$", L, NE));
dot(Label("$M$", M, NW));
dot(Label("$O$", O, 2N));
dot(Label("$T$", T, NW));

