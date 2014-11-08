import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

real alpha = -1.2, beta = pi - alpha;

point
    A = (0,0), C = (0,1),
    B = C + 0.7   * unit(A-C) * dir(degrees(alpha)),
    D = A + 1.3 * unit(C-A) * dir(degrees(beta));

point
    E = C + unit(C - B) * abs(A - D);

draw(A--B--C--D--cycle, linewidth(1));

draw(A--C);

draw(C--E--A, dashed);

markangle(B, C, A, radius=mr);

markangle(A, C, E, radius=0.7mr, n=2);
markangle(D, A, C, radius=0.7mr, n=2);

mark(A--D, 1);
mark(C--E, 1);

mark(A--E, tildeframe);
mark(C--D, tildeframe);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, NNW));
dot(Label("$C$", C, NNW));
dot(Label("$D$", D, SSW));
dot(Label("$E$", E, NNW));

