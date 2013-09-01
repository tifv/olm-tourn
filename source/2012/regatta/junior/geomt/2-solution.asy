import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0, 0), B = (2, 0),
    circAB = circle(A, B),
    K = angpoint(circAB, aSin(1/5)+90),
    arcAB = arccircle(A, K, B),
    DC = tangent(circAB, K),
    D = intersectionpoint(DC, perpendicular(A, normal=B-A)),
    C = intersectionpoint(DC, perpendicular(B, normal=B-A)),
    O = extension(A, C, B, D);

draw(A--B--C--D--cycle, linewidth(1));
draw(A--C ^^ B--D);
draw(O--K);

mark(D--A, 1);
mark(D--K, 1);
mark(C--B, 2);
mark(C--K, 2);

draw(arcAB);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, NW));
dot(Label("$K$", K, unit(D-C)/I));
dot(Label(
    "$O$", O, unit(unit(A-O) + unit(B-O))
));

