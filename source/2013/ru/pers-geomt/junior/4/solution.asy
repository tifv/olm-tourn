import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (2,5.60), B = (0,0), C = (9,0),
    ABC = triangle(A, B, C),
    circumABC = circumcircle(ABC),
    O = circumABC.C,
    H = orthocentercenter(ABC),
    H_A = O + A - H,
    H_B = O + B - H,
    H_C = O + C - H,
    cA = circumcircle(O, A, H_A),
    cB = circumcircle(O, B, H_B),
    cC = circumcircle(O, C, H_C),
    X = reflect(cB.C, cC.C) * O;

pen gray = gray(0.7);

draw(cA, gray+1);
//draw(cB, gray(0.8));
//draw(cC, gray(0.8));
draw(circumABC, gray+1);

draw(ABC, linewidth(1));
draw(H--H_A);
draw(X--O--A ^^ B--X);

mark(H--((A+O)/2), tildeframe(1));
mark(H_A--((A+O)/2), tildeframe(1));

dot(Label("$A$", A, unit(A-O)));
dot(Label("$B$", B, unit(B-O)));
dot(Label("$C$", C, unit(C-O)));

dot(Label("$O$", O, SE));
dot(Label("$H$", H, NNW));

dot(Label("$H_A$", H_A, NE));
dot(Label("$X$", X, unit(X-O)));
dot((H+H_A)/2);

