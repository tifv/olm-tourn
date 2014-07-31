import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (1,4), D = (2 B.x, 0),
    C = intersectionpoint(line(A, D), parallel(B, (D-B)^2 / (A-B))),
    ABC = triangle(A, B, C),
    AE = parallel(A, line(ABC.AC).u * (C - B) / (D - B)),
    E = intersectionpoint(AE, ABC.BC),
    F = extension(A, E, B, D);

// plain.E

draw(ABC, linewidth(1));
draw(A--E--D--B);

mark(A--F, 1);
mark(D--E, 1);

markangle(A, B, D, n=1, radius=1.4mr);
markangle(D, B, C, n=1, radius=mr);
markangle(C, A, E, n=1, radius=1.4mr);

markangle(B, C, A, n=2, radius=mr);
markangle(E, A, B, n=2, radius=mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NNW));
dot(Label("$C$", C, SE));
dot(Label("$D$", D, S));
dot(Label("$E$", E, NE));
dot(Label("$F$", F, 1.2WNW));

