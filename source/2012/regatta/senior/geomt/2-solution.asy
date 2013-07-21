import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;


var
    A = (0,0), B = (1,0), C = (1,1), D = (0,1),
    x = 0.5, X = (x, (1 - x) / (1 + x)),
    F = (X.x, 0), P = (0, X.y), E = (X.x, 1), Q = (1, X.y);

// plain.E !

fill(A--F--X--P--cycle, gray(0.7));
fill(X--Q--C--E--cycle, gray(0.7));

draw(A--B--C--D--cycle);
draw(F--E--A--Q--P);

markangle(Q, A, E, radius=mr, L="$?$");

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, NW));
dot(Label("$E$", E, N));
dot(Label("$F$", F, S));
dot(Label("$P$", P, W));
dot(Label("$Q$", Q, plain.E));
dot(Label("$X$", X, NE));

label("$S$", (A+F+X+P)/4);
label("$2S$", (X+Q+C+E)/4);

