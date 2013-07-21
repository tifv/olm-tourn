import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

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

draw(A--B--C--D--cycle);
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

