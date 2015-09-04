import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    alpha = 25,
    A = (0,0), D = (1,0), B = D - dir(-alpha), C = B + D - A,
    M = (2 A + C) / 3,
    T = extension(A, C, B, D);

draw(A--B--C--D--cycle, linewidth(1));
draw(B--D);
draw(A--C, dashed);

mark(B--(1.2C-0.2B), tildeframe(1));
mark(B--(1.2D-0.2B), tildeframe(1));

mark((1.2B-0.2C)--C, tildeframe(1));
mark((1.2B-0.2D)--D, tildeframe(1));

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NW));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, SE));

dot(Label("$M$", M, SSE));
dot(Label("$T$", T, 1.2N));

