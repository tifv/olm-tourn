import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    circle = circle((point)(0,0), 1),

    A = dir(0), B = A * dir(144),
    C = dir(90), D = C / dir(72), P = C / dir(36),
    ABE = triangleabc(
        abs(B-D), abs(A-C), abs(A-B),
        angle=degrees(B-A), A=A ),

    E = ABE.C, EP = line(E, P),

    Bp = C * D / B;

pen gray = gray(0.7);

draw(circle, linewidth(1));
draw(EP, gray+1);
draw(line(ABE.AB), gray+1);
perpendicularmark(ABE.AB, EP, gray);

draw(B--C);
mark(B--C, 1);
draw(Bp--D);
mark(Bp--D, 1);
mark(arc(circle, D, P), 2);
mark(arc(circle, P, C), 2);

dot(Label("$A$", A, NE));
dot(Label("$B$", B, 1.2NNW));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));

dot(Label("$E$", E, SSE));
dot(Label("$P$", P, ENE));
dot(Label("$B'$", Bp, unit(Bp)));

