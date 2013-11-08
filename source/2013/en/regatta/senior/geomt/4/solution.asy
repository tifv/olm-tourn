import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    the_circle = circle((point)(0,0), 1),
    A = dir(90), B = dir(0), C = dir(-100),
    ABC = triangle(A, B, C),
    E = bisectorpoint(ABC.BC),
    M = unit(-B-C),
    AE = line(A=A, B=E, extendA=false), ME = line(M, E),
    D = ME.v^2 / M, X = AE.v^2 / A;

draw(the_circle, gray(0.5)+1);

draw(A--B--C--cycle, linewidth(1));
draw(AE);
draw(ME);

markangle(C, A, E, radius=mr);
markangle(E, A, B, radius=1.2mr);
// plain.N !

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));

dot(Label("$E$", E, 1.6 plain.E));
dot(Label("$M$", M, (pair) 1.4 (unit(M)+ME.v)));
dot(Label("$D$", D, (pair) (unit(D)+ME.v)));

dot(Label("$X$", X, (pair) (-unit(X)-AE.v)));
