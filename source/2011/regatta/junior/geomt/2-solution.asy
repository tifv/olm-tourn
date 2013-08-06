import geometry;
access jeolm;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), BC = parallel((1,0), (0,1)),
    B = intersectionpoint(BC, parallel(A, dir(-20))),
    C = intersectionpoint(BC, parallel(A, dir(20))),
    ABC = triangle(A, B, C),

    S = intersectionpoint(ABC.AB, parallel(C, unit(B-C) / dir(10))),
    T = intersectionpoint(ABC.BC, parallel(A, unit(B-A) * dir(10))),

    P = extension(A, T, C, S);

draw(ABC, linewidth(1));
draw(A--T);
draw(C--S);
draw(S--T);

markangle(A, C, B, radius=0.7mr, n=1);
markangle(C, B, A, radius=0.6mr, n=1);
markangle(B, S, T, radius=0.6mr, n=1);

markangle(S, T, B, radius=0.9mr, n=2);
markangle(B, A, C, radius=0.9mr, n=2);

markangle(B, A, T, radius=1.4mr, n=3);
markangle(S, C, B, radius=1.3mr, n=3);

perpendicularmark(P, unit(C-P), dir=NE, size=0.5mr);

dot(Label("$A$", A, W));
dot(Label("$B$", B, SSE));
dot(Label("$C$", C, NNE));
dot(Label("$P$", P, dir(45)));
dot(Label("$T$", T, E));
dot(Label("$S$", S, SSW));

