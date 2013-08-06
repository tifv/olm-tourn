import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    the_circle = circle((point)(0,0), 1),

    A = dir(0), B = A * dir(144),
    C = dir(90), D = C / dir(72), P = C / dir(36),
    ABE = triangleabc(
        abs(B-D), abs(A-C), abs(A-B),
        angle=angle(B-A) * 180/pi, A=A ),

    E = ABE.C, EP = line(E, P),

    Bp = C * D / B;

draw(the_circle, linewidth(1));
draw(EP);
draw(ABE.AB);
perpendicularmark(ABE.AB, EP);

draw(B--C);
mark(B--C, 1);
draw(Bp--D);
mark(Bp--D, 1);
mark(arc(the_circle, D, P), 2);
mark(arc(the_circle, P, C), 2);

dot(Label("$A$", A, NE));
dot(Label("$B$", B, 1.2NNW));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));

dot(Label("$E$", E, SSE));
dot(Label("$P$", P, ENE));
dot(Label("$B'$", Bp, unit(Bp)));

