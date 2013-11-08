import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    the_circle = circle((point) (0,0), 1),
    r = 0.6,
    X = r * dir(100), Y = r * dir(40), Z = r * dir(-140),
    A = intersectionpoints(the_circle, line(Y, X, extendA=false))[0],
    B = intersectionpoints(the_circle, line(Z, X, extendA=false))[0],
    C = intersectionpoints(the_circle, line(Z, Y, extendA=false))[0],
    D = intersectionpoints(the_circle, line(X, Y, extendA=false))[0],
    E = intersectionpoints(the_circle, line(X, Z, extendA=false))[0],
    F = intersectionpoints(the_circle, line(Y, Z, extendA=false))[0];

draw(the_circle, linewidth(1));
draw(A--D ^^ B--E ^^ C--F);

mark(A--X, 1);
mark(Y--D, 1);

mark(C--Y, 2);
mark(Z--F, 2);

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));
dot(Label("$E$", E, unit(E)));
dot(Label("$F$", F, unit(F)));
dot(Label("$X$", X, 1.2SW));
dot(Label("$Y$", Y, N));
dot(Label("$Z$", Z, SE));


