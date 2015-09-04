import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    alpha = 1.7,
    A = (-1,0), B = (0,alpha), C = (1,0), D = (0,-alpha),
    O = (0,0),
    K = projection(A, B) * O,
    L = projection(B, C) * O,
    M = projection(C, D) * O,
    N = projection(D, A) * O,
    R = abs(O - projection(A, B) * O),
    circle = circle((point) O, R),
    X = R * dir(100), Y = R * dir(-85),
    EF = parallel(X, unit(O-X) / I),
    GH = parallel(Y, unit(O-Y) / I),
    E = intersectionpoint(EF, line(A, B)),
    F = intersectionpoint(EF, line(B, C)),
    G = intersectionpoint(GH, line(C, D)),
    H = intersectionpoint(GH, line(D, A)),
    P = extension(K, X, N, Y),
    Q = extension(X, L, Y, M);

pen gray = gray(0.7);

draw(circle, gray+1);
draw(A--B--C--D--cycle, linewidth(1));
draw(E--F ^^ G--H);
draw(P--X--Q--Y--cycle);

dot(Label("$A$", A, plain.W));
dot(Label("$B$", B, plain.N));
dot(Label("$C$", C, plain.E));
dot(Label("$D$", D, plain.S));
dot(Label("$K$", K, NW));
dot(Label("$L$", L, NE));
dot(Label("$M$", M, SE));
dot(Label("$N$", N, SW));
dot(Label("$E$", E, WNW));
dot(Label("$F$", F, ENE));
dot(Label("$G$", G, ESE));
dot(Label("$H$", H, WSW));
dot(Label("$X$", X, plain.N));
dot(Label("$Y$", Y, plain.S));
dot(Label("$P$", P, plain.W));
dot(Label("$Q$", Q, plain.E));

