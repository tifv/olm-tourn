import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = dir(210), B = dir(90), C = dir(-30);
triangle ABC = triangle(A, B, C);

point O = incenter(ABC);
line l = line(O, 14);
point
    D = intersectionpoint(l, ABC.AB), E = intersectionpoint(l, ABC.BC);

point
    F = intersectionpoints(circle(D, abs(C-D)), circle(E, abs(A-E)))[0],
    Fp = projection(l) * F;

draw(ABC, linewidth(1));

draw(l);

draw(A--E--F--D--C ^^ F--Fp);

frame circlebarframe = circlebarframe(1);

mark(A--E, 2);
mark(F--E, 2);

mark(C--D, tildeframe);
mark(F--D, tildeframe);

perpendicularmark(Fp, unit(F-Fp), dir=SE, size=0.3mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, plain.N));
dot(Label("$C$", C, SE));
dot(Label("$D$", D, NW));
dot(Label("$E$", E, NNE));
dot(Label("$F$", F, plain.S));

label("$l$", 1.4E - 0.4D, NW);

