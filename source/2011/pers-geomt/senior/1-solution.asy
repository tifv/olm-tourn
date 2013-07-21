import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;

var
    A = (0,0), B = (0, 3), D = (4.5, 0), C = B + D - A,

    P = (A + B) / 2,
    Q = projection(P, D) * C;

draw(A--B--C--D--cycle);
draw(D--P--C--Q--B);

markangle(A, P, D, radius=mr);
markangle(C, P, B, radius=mr);
markangle(C, Q, B, radius=mr);
markangle(C, D, P, radius=mr);
markangle(B, C, Q, radius=mr);

perpendicular(Q, unit(D-Q), NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NW));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, SE));
dot(Label("$P$", P, W));
dot(Label("$Q$", Q, 2WSW));
