import geometry;
access jeolm;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (0, 3), D = (4.5, 0), C = B + D - A,

    P = (A + B) / 2,
    Q = projection(P, D) * C;

draw(A--B--C--D--cycle, linewidth(1));
draw(D--P--C--Q--B);

markangle(A, P, D, radius=mr);
markangle(C, P, B, radius=mr);
markangle(C, Q, B, radius=mr);
markangle(C, D, P, radius=mr);
markangle(B, C, Q, radius=mr);

perpendicular(Q, unit(D-Q), NE, size=0.5mr);
perpendicular(B, unit(A-B), NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NW));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, SE));
dot(Label("$P$", P, W));
dot(Label("$Q$", Q, 2WSW));
