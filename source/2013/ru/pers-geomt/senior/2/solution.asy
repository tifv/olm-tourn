import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    OO = (point) (0,0),
    omega = circle(OO, 1), gamma = circle(OO, 0.6),
    O = (point) dir(0),
    d = sqrt(omega.r^2 - gamma.r^2),
    A = (point) (O / (1, -d/gamma.r)),
    B = (point) (O / (1, d/gamma.r)),
    a_circle = circle(O, abs(A-O)),
    CD_points = intersectionpoints(a_circle, omega),
    C = CD_points[0],
    D = CD_points[1],
    F = - O * unit(A-O)^2 / O^2,
    M = (O+A)/2;

clipdraw(a_circle);
draw(omega, linewidth(1));
draw(gamma, linewidth(1));

draw(O--B ^^ O--A ^^ A--F);

mark(A--M, 1);
mark(M--O, 1);

dot(Label("$A$", A, unit(A) + unit(A-a_circle.C)));
dot(Label("$B$", B, unit(B) + unit(B-a_circle.C)));
dot(Label("$C$", C, unit(C) + unit(C-a_circle.C)));
dot(Label("$D$", D, unit(D) + unit(D-a_circle.C)));
dot(Label("$O$", O, unit(O)));

dot(Label("$M$", M, unit(A-O)/I));
dot(Label("$F$", F, unit(F)));

