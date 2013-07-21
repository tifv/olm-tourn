import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

var
    A = (0, Tan(40)), B = (-1, 0), C = (1, 0),
    ABC = triangle(A, B, C),

    D = bisectorpoint(ABC.AC),
    X = intersectionpoint(ABC.BC, parallel(D, (C-D) / ((A-B) / (C-B))));

draw(ABC);
draw(B--D--X);

markangle(D, X, B, radius=0.8mr, n=1, L="$4 \alpha$");

markangle(A, C, B, radius=0.8mr, n=2, L=Label("$2 \alpha$", align=NW));
markangle(X, D, C, radius=0.8mr, n=2);

markangle(D, B, A, radius=mr, n=3);
markangle(C, B, D, radius=1.25mr, n=3, L="$\alpha$");

mark(A--D, n=1);
mark(D--X, n=1);
mark(X--C, n=1);

dot(Label("$A$", A, N));
dot(Label("$B$", B, WSW));
dot(Label("$C$", C, ESE));
dot(Label("$D$", D, NNE));
dot(Label("$X$", X, S));

