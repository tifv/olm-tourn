import geometry;
access jeolm;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (3,0), C = (1,2),
    ABC = triangle(A, B, C),
    alpha = 0.45,

    K = alpha * A + (1-alpha) * B,
    A1 = K + (A-K) * (A-C) / (B-C),
    C1 = K + (C-K) * (A-C) / (B-C),

    L = extension(B, C, A1, C1),
    M = K + (L-K) * (B-C) / (A-C),

    KLM = triangle(K, L, M);


//markangle(A, M, C, radius=mr);

draw(circumcircle(KLM), gray(0.5));
draw(arccircle(K, A, M), gray(0.5));
draw(arccircle(L, B, K), gray(0.5));
draw(arccircle(M, C, L), gray(0.5));

draw(ABC, linewidth(1));
draw(KLM);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, N));

dot(Label("$K$", K, 1.5 SSE + 1.5 S));
dot(Label("$L$", L, 1.7 NNE));
dot(Label("$M$", M, 1.4 W));

