import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0, 0), B = (5, 0), C = (4, 2), D = (2, 2),
    E = projection(line(A, D),
        rotate(degrees(angle(line(C, D), line(C, B)))) * line(D, A)
    ) * B;

draw(A--B--C--D--cycle, linewidth(1));

draw(B--E);
draw(line(B, (2B-C), extendA=false));

markangle(D, C, B, radius=mr);
markangle(A, E, B, radius=mr);
markangle(A, B, 2B-C, radius=mr);

dot(Label("$A$", A, plain.W));
dot(Label("$B$", B, plain.E));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, NW));
dot(Label("$E$", E, NW));

dot(1.3B-0.3C, (pen)invisible);

