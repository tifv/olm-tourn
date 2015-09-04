import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = dir(90),
    B = dir(0),
    C = dir(-100),
    ABC = triangle(A, B, C),
    circumABC = circumcircle(ABC),
    E = bisectorpoint(ABC.BC),
    M = unit(-B-C),
    AE = line(A=A, B=E, extendA=false),
    ME = line(M, E),
    D = ME.v^2 / M,
    X = AE.v^2 / A;

pen gray = gray(0.7);
draw(circumABC, gray+1);

draw(ABC, linewidth(1));

draw(AE);
draw(ME);

markangle(C, A, E, radius=mr);
markangle(E, A, B, radius=1.2mr);

// plain.E

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));

dot(Label("$E$", E, 1.6 plain.E));
dot(Label("$M$", M, (pair) 1.4 (unit(M)+ME.v)));
dot(Label("$D$", D, (pair) (unit(D)+ME.v)));

dot(Label("$X$", X, (pair) (-unit(X)-AE.v)));
