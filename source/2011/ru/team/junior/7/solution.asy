import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    A = (0,0), B = (5,0), C = (4,3), D = (1,2),
    P = (1,0), Q = B - (P - A),

    circumAPD = circumcircle(A, P, D),
    circumAPC = circumcircle(A, P, C),
    circumBQD = circumcircle(B, Q, D),
    circumBQC = circumcircle(B, Q, C),

    X = reflect(circumAPD.C, circumBQD.C) * D,
    Y = reflect(circumAPC.C, circumBQC.C) * C,

    K = (A + B) / 2;

pen circlepen = gray(0.7)+1;
draw(circumAPD, p=circlepen);
clipdraw(circumAPC, p=circlepen);
clipdraw(circumBQD, p=circlepen);
draw(circumBQC, p=circlepen);

draw(A--B--C--D--cycle, linewidth(1));
draw(D--K--C, dashed);

mark(A--P, 1);
mark(B--Q, 1);
mark(P--K, 2);
mark(Q--K, 2);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NW));
dot(Label("$D$", D, 1.2NNE));
dot(Label("$P$", P, SSE));
dot(Label("$Q$", Q, SSW));

dot(Label("$X$", X, SW));
dot(Label("$Y$", Y, ESE));
dot(Label("$K$", K, S));

