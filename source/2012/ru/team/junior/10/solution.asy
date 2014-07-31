import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    next1 = rotate(360.0 / 7),
    A = dir(360.0/28 + 360.0/14),
    B = next1 * A, C = next1 * B, D = next1 * C,
    E = next1 * D, F = next1 * E, G = next1 * F,
    H = extension(A, D, C, G),

    alpha = dir(360.0 / 7),
    X = (F - alpha * H) / (1 - alpha),

    next2 = rotate(360.0 / 7, X),
    I = next2 * F, J = next2 * I, K = next2 * J,
    L = next2 * K, M = next2 * L,
    N = extension(M, J, K, H),

    heptagon1 = A--B--C--D--E--F--G--cycle,
    heptagon2 = H--F--I--J--K--L--M--cycle;

// plain.E, plain.N, plain.I

fill(heptagon2, gray(0.85));
fill(heptagon1, gray(0.7));

draw(heptagon1, linewidth(1));
draw(heptagon2);

draw(A--D);
draw(C--G);
draw(A--M--B);

draw(G--N);
draw(M--J);
draw(K--H);

dot(Label("$A$", A, unit(M-G)/plain.I));
dot(Label("$B$", B, unit(M-C)*plain.I));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));
dot(Label("$E$", E, unit(E)));
dot(Label("$F$", F, unit(unit(I-F)+unit(E-F))));
dot(Label("$G$", G, unit(N-F)/plain.I));
dot(Label("$H$", H, NNW+plain.N));
dot(Label("$I$", I, unit(I-X)));
dot(Label("$J$", J, unit(J-X)));
dot(Label("$K$", K, unit(K-X)));
dot(Label("$L$", L, unit(L-X)));
dot(Label("$M$", M, unit(unit(M-L)+unit(M-C))));
dot(Label("$N$", N, 1.5NNE));

