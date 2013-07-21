import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

var
    A = (0,0), B = dir(60), D = (2,0), C = B + D,
    M = (B + C) / 2;

marker m = marker(markinterval(stickframe(1), rotated=true));

draw(A--B--C--D--A--cycle);
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

