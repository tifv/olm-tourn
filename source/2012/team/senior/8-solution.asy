import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);

point chord(point A, circle c, vector n) {
    return reflect(parallel(c.C, n)) * A;
}
point other_intersection(point A, circle c1, circle c2) {
    return reflect(c1.C, c2.C) * A;
}

var
    T = (point)(0,0),
    gamma1 = circle((point)(-1,0), 1),
    gamma2 = circle((point)(2,0), 2),

    a = parallel(T, dir(-30)),
    b = parallel(T, dir(35)),

    A = chord(T, gamma1, a.v),
    B = chord(T, gamma1, b.v),
    A1 = chord(T, gamma2, a.v),
    B1 = chord(T, gamma2, b.v),

    X = 0.8 dir(170),
    ATX = triangle(A, T, X),
    BTX = triangle(B, T, X),
    circumATX = circumcircle(ATX),
    circumBTX = circumcircle(BTX),

    A2 = other_intersection(T, gamma2, circumATX),
    B2 = other_intersection(T, gamma2, circumBTX),

    Y = chord(A2, circumATX, line(B1, A2).v),
    Z = chord(B2, circumBTX, line(A1, B2).v);

draw(line(Y, Z), gray(0.5));

draw(gamma1, black+1);
draw(gamma2, black+1);
draw(circumATX);
draw(circumBTX);

draw(B--B1--Y);
draw(A--A1--Z);

dot(Label("$A$", A, 1.5WNW));
dot(Label("$B$", B, SW));
dot(Label("$A_1$", A1, unit(A1-gamma2.C)));
dot(Label("$B_1$", B1, unit(B1-gamma2.C)));
dot(Label("$A_2$", A2, 1.6NNE));
dot(Label("$B_2$", B2, unit(NE+ENE)));
dot(Label("$X$", X, S));
dot(Label("$Y$", Y, WNW));
dot(Label("$Z$", Z, NW));
dot(Label("$T$", T, NE+1.5NNE));


