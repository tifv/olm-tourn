import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

var
    A = (0, 0), B = (0, -2),
    circAB = circle(A, B),
    K = angpoint(circAB, 15),
    arcAB = arccircle(A, K, B),
    DC = tangent(circAB, K),
    D = intersectionpoint(DC, perpendicular(A, normal=B-A)),
    C = intersectionpoint(DC, perpendicular(B, normal=B-A)),
    O = extension(A, C, B, D);

draw(A--B--C--D--cycle);
draw(A--C ^^ B--D);
draw(O--K);

mark(D--A, 1);
mark(D--K, 1);
mark(C--B, 2);
mark(C--K, 2);

draw(arcAB);

dot(Label("$A$", A, NW));
dot(Label("$B$", B, SW));
dot(Label("$C$", C, SE));
dot(Label("$D$", D, NE));
dot(Label("$K$", K, ENE));
dot(Label("$O$", O, W ));

