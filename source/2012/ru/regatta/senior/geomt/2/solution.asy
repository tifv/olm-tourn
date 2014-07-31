import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (1,0), C = (1,1), D = (0,1),
    x = 0.5, X = (x, (1 - x) / (1 + x)),
    F = (X.x, 0), P = (0, X.y), E = (X.x, 1), Q = (1, X.y);

// plain.E

pen grayfill = gray(0.85);

fill(A--F--X--P--cycle, grayfill);
fill(X--Q--C--E--cycle, grayfill);

draw(A--B--C--D--cycle, linewidth(1));
draw(E--F ^^ P--Q);
draw(Q--A--E);

markangle(Q, A, E, radius=mr, L="$?$");

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, NW));
dot(Label("$E$", E, N));
dot(Label("$F$", F, S));
dot(Label("$P$", P, W));
dot(Label("$Q$", Q, plain.E));
dot(Label("$X$", X, NW));

label("$S$", (A+F+X+P)/4);
label("$2S$", (X+Q+C+E)/4);

