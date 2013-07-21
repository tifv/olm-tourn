import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

var
    A = (0,0), B = (2,0), C = (2 * A + 3I * B) / (2 + 3I),
    ABC = triangle(A, B, C),
    alpha = 0.3,
    Y = (1-2alpha) * B + 2 alpha * C,
    X = (1-alpha) * B + alpha * A,
    Yp = 2 C - Y;

draw(ABC, black+1);
draw(A--Y--X);
draw(A--Yp--C, dashed);

mark(Y--C, 1);
mark(C--Yp, 1);

perpendicularmark(C, unit(A-C), dir=NE, size=0.5mr);

markangle(C, Y, A, radius=0.8mr);
markangle(X, Y, B, radius=0.8mr);
markangle(A, Yp, B, radius=0.8mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, unit(Yp-B)/I));
dot(Label("$X$", X, S));
dot(Label("$Y$", Y, unit(Yp-B)/I));
dot(Label("$Y'$", Yp, N));

