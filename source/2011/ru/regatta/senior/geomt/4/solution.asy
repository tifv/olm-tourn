import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    circle = circle((point)(0,0), 1),

    B = dir(20), D = dir(120), F = dir(250),
    BDF = triangle(B, D, F),

    O = orthocentercenter(BDF),
    A = - F * B / D,
    C = - B * D / F,
    E = - D * F / B;

pen gray = gray(0.7);

draw(circle, gray+1);

draw(BDF, dashed);
draw(A--B--C--D--E--F--cycle, linewidth(1));
draw(B--O);
draw(D--O);
draw(F--O);

mark(B--A, 1);
mark(B--O, 1);
mark(B--C, 1);

mark(D--C, 2);
mark(D--O, 2);
mark(D--E, 2);

mark(F--E, 3);
mark(F--O, 3);
mark(F--A, 3);

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));
dot(Label("$E$", E, unit(E)));
dot(Label("$F$", F, unit(F)));
dot(Label("$O$", O, unit(unit(B-O)+unit(F-O))));

