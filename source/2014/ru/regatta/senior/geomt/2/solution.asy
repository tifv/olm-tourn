import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

real r = 1;

point
    D = (0,0), B = D + 3.7 dir(112), O = D + r * up;
circle
    inABC = circle(O, abs(O-D));
var
    sidesB = tangents(inABC, B);
line BC = sidesB[0], BA = sidesB[1], AC = tangent(inABC, down);
point A = intersectionpoint(BA, AC), C = intersectionpoint(BC, AC);
circle
    inBDA = incircle(B, D, A), inBDC = incircle(B, D, C);
point
    O1 = inBDA.C, O2 = inBDC.C,
    M = extension(O1, O2, B, D);

pen circlepen = gray(0.7) + 1;
draw(inABC, circlepen);
draw(inBDA, circlepen);
draw(inBDC, circlepen);

draw(triangle(A, B, C), linewidth(1));
draw(B--D);
draw(O1--D--O2--cycle);

markangle(A, D, O1, n=2, radius=0.55mr);
markangle(O1, D, B, n=2, radius=0.7mr);
markangle(D, O2, O1, n=2, radius=0.6mr);

markangle(B, D, O2, n=1, radius=0.75mr);
markangle(O2, D, C, n=1, radius=0.6mr);
markangle(O2, O1, D, n=1, radius=0.6mr);

perpendicularmark(M, unit(D-M), dir=NW, size=0.5mr);

dot(Label("$A$", A, SE));
dot(Label("$B$", B, N));
dot(Label("$C$", C, SW));
dot(Label("$D$", D, S));
dot(Label("$O_1$", O1, NNE));
dot(Label("$O_2$", O2, NNW));

label(scale(0.7) * "$60^{\circ}$", D, 4unit(unit(A-D) + unit(O1-D)));
label(scale(0.7) * "$30^{\circ}$", D, 3.5unit(unit(C-D) + unit(O2-D)));

