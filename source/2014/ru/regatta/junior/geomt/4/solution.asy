import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    C = (3/2 * sqrt(10), 0), A = -C, B = C / (3 - 9 I) * (3 + 9 I), D = -B,
    Dp = reflect(A, C) * B,
    N = (0, 0), K = extension(A, D, C, Dp),
    M = extension(B, C, N, K);

draw(line(A, C), p=gray(0.7));
draw(line(M, K), p=gray(0.7));

draw(A--B--C--D--cycle, linewidth(1));
draw(A--Dp--extension(A, D, Dp, C) ^^ A--M);

label("$3$", (A+B)/2, I * unit(B-A));
label("$4$", (B+M)/2, I * unit(M-B));
label("$5$", (M+A)/2, I * unit(M-A));
label("$5$", (M+C)/2, I * unit(C-M));
label("$3$", (A+Dp)/2, I * unit(A-Dp));
label("$4$", (Dp+K)/2, I * unit(M-B));
label("$5$", (A+K)/2, I * unit(K-A));

dot(Label("$A$", A, W));
dot(Label("$B$", B, NNW));
dot(Label("$C$", C, E));
dot(Label("$D$", D, SSE));
dot(Label("$M$", M, NNE));
dot(Label("$N$", N, SE));
dot(Label("$K$", K, 1.2S));
dot(Label("$D'$", Dp, SSW));

