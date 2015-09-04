import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    B = (0, 0), A = (Cos(30), 0), C = (0, Sin(30));

triangle ABC = triangle(A, B, C);

point
    L = bisectorpoint(ABC.AB),
    M = midpoint(ABC.AC);

draw(ABC, linewidth(1));
draw(C--L ^^ L--M);

markangle(B, C, L, radius=mr);
markangle(L, C, A, radius=0.7mr);

markangle(C, A, B, radius=mr);

perpendicularmark(M, unit(A-M), dir=SE, size=0.5mr);

dot(Label("$A$", A, SSE));
dot(Label("$B$", B, SSW));
dot(Label("$C$", C, NW));
dot(Label("$L$", L, S));
dot(Label("$M$", M, NNE));

