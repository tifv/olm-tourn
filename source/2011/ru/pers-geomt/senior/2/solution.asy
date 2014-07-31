import three;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;
from geometry access tildeframe;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    D = (0,0,0),
    A = (5,0,0), B = (2,3,4), C = (1,4.5,0),

    d = 16,

    A1 = unit(A) * d / abs(A),
    B1 = unit(B) * d / abs(B),
    C1 = unit(C) * d / abs(C),

    A2 = A + (D - A1),
    B2 = B + (D - B1),
    C2 = C + (D - C1);

// Hand-made projection
real phi = -33, psi = 70;
pair p(triple A) {
    return (
        A.x * Cos(phi) - A.y * Sin(phi),
        A.z * Sin(psi) + A.x * Sin(phi) * Cos(psi) + A.y * Cos(phi) * Cos(psi));
}

draw(p(A)--p(B)--p(C)--cycle ^^ p(D)--p(A) ^^ p(D)--p(B) ^^ p(D)--p(C),
    linewidth(1) );
draw(p(A2)--p(B2)--p(C2)--cycle, p=gray(0.5));

dot(Label("$A$", p(A), SE));
dot(Label("$B$", p(B), NNE));
dot(Label("$C$", p(C), ENE));
dot(Label("$D$", p(D), WSW));

dot(Label("$A_1$", p(A1), SSW));
dot(Label("$B_1$", p(B1), NW));
dot(Label("$C_1$", p(C1), NNW));
dot(Label("$A_2$", p(A2), SSW));
dot(Label("$B_2$", p(B2), NW));
dot(scale(0.7) * Label("$C_2$", p(C2), 0.8NW));

mark(p(D)--p(A2), 3);
mark(p(A1)--p(A), 3);

mark(p(D)--p(B2), 2);
mark(p(B1)--p(B), 2);

mark(p(D)--p(C2), tildeframe(1));
mark(p(C1)--p(C), tildeframe(1));

