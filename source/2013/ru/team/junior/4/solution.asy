import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (-1,0), B = (0,0.8), C = (1,0),
    ABC = triangle(A, B, C),
    DC = parallel(C, unit(B-C)^2 / unit(A-C)),
    D = intersectionpoint(DC, line(A, B)),
    H = foot(ABC.VB),
    F = projection(B, H) * D,
    Dp = reflect(B, H) * D,
    E = F + unit(H-B) * sqrt(abs(C-D)^2 - abs(F-D)^2);

draw(ABC, linewidth(1));
draw(line(F, H));
draw(D--B ^^ D--C ^^ D--E);
draw(Dp--A ^^ Dp--B ^^ Dp--D);

mark(E--D, 2);
mark(C--D, 2);

markangle(C, A, D, radius=mr);
markangle(Dp, C, A, radius=1.3mr);
markangle(D, C, Dp, radius=mr);

perpendicularmark(H, unit(C-H), dir=NE, size=0.5mr);
perpendicularmark(F, unit(H-F), dir=NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, 1.6W));
dot(Label("$C$", C, SE));
dot(Label("$D$", D, NE));
dot(Label("$E$", E, W));
dot(Label("$H$", H, SE));

dot(Label("$F$", F, NW));
dot(Label("$D'$", Dp, NW));

