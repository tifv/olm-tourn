import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0, Tan(40)), B = (-1, 0), C = (1, 0),
    ABC = triangle(A, B, C),

    D = bisectorpoint(ABC.AC),
    X = intersectionpoint(ABC.BC, parallel(D, (C-D) / ((A-B) / (C-B))));

draw(ABC, linewidth(1));
draw(B--D--X);

markangle(D, X, B, radius=0.8mr, n=1, L="$4 \alpha$");

markangle(
    A, C, B,
    radius=0.8mr, n=2,
    L=Label("$2 \alpha$", align=unit(NW+WNW))
);
markangle(X, D, C, radius=0.8mr, n=2);

markangle(D, B, A, radius=mr, n=3);
markangle(C, B, D, radius=1.25mr, n=3, L="$\alpha$");

mark(A--D, scale(0.7) * stickframe(linewidth(0.5/0.7)));
mark(D--X, scale(0.7) * stickframe(linewidth(0.5/0.7)));
mark(X--C, scale(0.7) * stickframe(linewidth(0.5/0.7)));

dot(Label("$A$", A, N));
dot(Label("$B$", B, WSW));
dot(Label("$C$", C, ESE));
dot(Label("$D$", D, NNE));
dot(Label("$X$", X, S));

