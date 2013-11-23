import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = dir(60), D = (2,0), C = B + D,
    M = (B + C) / 2;

marker m = marker(markinterval(stickframe(1), rotated=true));

draw(A--B--C--D--A--cycle, linewidth(1));
draw(A--M);
draw(B--D);

mark(A--B, 1);
mark(B--M, 1);
mark(M--C, 1);
mark(C--D, 1);

markangle(D, A, M, radius=mr);
markangle(M, A, B, radius=1.2mr);
markangle(B, M, A, radius=mr);

perpendicularmark(D, unit(C-D), NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, NW));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, SE));
dot(Label("$M$", M, N));

