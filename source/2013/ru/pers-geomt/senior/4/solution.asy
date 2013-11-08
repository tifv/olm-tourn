import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    circR = 1, inR = 0.465, d = sqrt(circR * (circR - 2 inR)),
    circABC = circle((point)(0,0), circR),
    inABC = circle((point)(d, 0), inR),
    O = circABC.C, I = inABC.C,
    A1 = I + inR * unit(O-I) * plain.I,
    A1B = line(A1, A1 + unit(O-I), extendA=false), A1C = complementary(A1B),
    B = intersectionpoints(A1B, circABC)[0],
    C = intersectionpoints(A1C, circABC)[0],
    AB = parallel(B, unit(I-B)^2 / unit(A1-B)),
    A = O + (B-O) * AB.v^2 / unit(B-O)^2,
    ABC = triangle(A, B, C),
    H = orthocentercenter(ABC),
    C1 = projection(ABC.AB) * H,
    B1 = projection(ABC.AC) * H,
    F = (A+H) / 2;

draw(circle(A, H), gray(0.5));
draw(circumcircle(B1, C1, F), gray(0.5)); // euler

draw(A--B--C--cycle, linewidth(1));

draw(A--H ^^ B--B1 ^^ C--C1);

mark(A--F, 1);
mark(F--H, 1);

perpendicularmark(B1, unit(A-B1), dir=NE, size=0.5mr);
perpendicularmark(C1, unit(H-C1), dir=NE, size=0.5mr);

dot(Label("$A$", A, N));
dot(Label("$B$", B, SW));
dot(Label("$C$", C, SE));
dot(Label("$H$", H, 1.3 SSW));
dot(Label("$I$", I, SW+0.4W));
dot(Label("$O$", O, SSW));
dot(Label("$F$", F, SW));
dot(Label("$B_1$", B1, 1.2ESE));
dot(Label("$C_1$", C1, NW));

