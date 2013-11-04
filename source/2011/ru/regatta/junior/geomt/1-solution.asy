import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,1), B = (1,1), C = (1,0), D = (0,0),
    P = (1, 0.7), S = A + (P - A) / I, R = P + S - A,
    K = (C.x, R.y);

draw(A--B--C--D--cycle, linewidth(1));
draw(A--P--R--S--cycle);
draw(R--K--C);

dot(Label("$A$", A, WNW));
dot(Label("$B$", B, NE));
dot(Label("$C$", C, E));
dot(Label("$D$", D, NE));
dot(Label("$P$", P, E));
dot(Label("$S$", S, WSW));
dot(Label("$R$", R, SSW));
dot(Label("$K$", K, SE));

markangle(P, A, B, radius=1.5mr);
markangle(R, P, K, radius=1.5mr);

mark(C--K, 1);
mark(R--K, 1);
mark(B--P, 1);

