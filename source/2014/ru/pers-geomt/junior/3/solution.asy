import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

real alpha = -60, a = -0.5;

point
    O = (0, 0), B = dir(alpha), F = dir(180 - alpha),
    A = B * a + F * (1-a),
    E = dir(120 - alpha),
    D = intersectionpoint(line(B, E), parallel(A, line(F, E))),
    C = intersectionpoint(line(F, E), parallel(D, line(A, B)));

draw(circumcircle(B, E, F), gray(0.7)+1);

draw(O--E ^^ O--F ^^ O--B, gray(0.5));
mark(O--E, tildeframe(gray(0.5)));
mark(O--F, tildeframe(gray(0.5)));
mark(O--B, tildeframe(gray(0.5)));

draw(A--B--C--D--cycle, linewidth(1));
draw(C--F ^^ B--D);
draw(A--C--O);
draw(A--O, dashed);

markangle(A, D, B, radius=mr);
markangle(B, D, C, radius=0.7mr);
markangle(D, B, A, radius=mr);
markangle(F, E, B, radius=0.7mr);
markangle(C, E, D, radius=0.7mr);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, SSE));
dot(Label("$C$", C, NNE));
dot(Label("$D$", D, NNW));
dot(Label("$E$", E, SW));
dot(Label("$F$", F, SSW));
dot(Label("$O$", O, NNW));

