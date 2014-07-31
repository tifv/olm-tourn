import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (1,3), B = (0,0), C = (5,0),
    ABC = triangle(A, B, C),

    L = bisectorpoint(ABC.BC),
    ABL = triangle(A, B, L),
    ACL = triangle(A, C, L),

    I = incenter(ABL),
    J = incenter(ACL),
    X = bisectorpoint(ABL.BC),
    Y = bisectorpoint(ACL.BC),

    IJ = line(I, J),
    B1 = intersectionpoint(IJ, ABC.AC),
    C1 = intersectionpoint(IJ, ABC.AB),
    P = intersectionpoint(IJ, ABC.BC);

draw(ABC, linewidth(1));
draw(A--X);
draw(A--L);
draw(A--Y);
draw(I--L--J);
draw(B1--C1);

markangle(B, A, X, radius=1.0mr, n=3);
markangle(X, A, L, radius=1.3mr, n=3);
markangle(L, A, Y, radius=1.0mr, n=3);
markangle(Y, A, C, radius=1.3mr, n=3);

markangle(A, L, I, radius=0.7mr, n=2);
markangle(I, L, B, radius=1.0mr, n=2);

markangle(C, L, J, radius=0.7mr, n=1);
markangle(J, L, A, radius=1.0mr, n=1);

dot(Label("$A$", A, NNW));
dot(Label("$B$", B, SW));
dot(Label("$C$", C, SE));
dot(Label("$L$", L, S));
dot(Label("$X$", X, S));
dot(Label("$Y$", Y, S));

dot(Label("$I\mathstrut$", I, 0.6NW));
dot(Label("$J\mathstrut$", J, 0.6NNE));
dot(Label("$B_1\mathstrut$", B1, 0.6NNE));
dot(Label("$C_1\mathstrut$", C1, 0.6NW));

