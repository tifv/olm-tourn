import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
   A = (0,0), B = (1,0), C = (1,1), D = (0,1),
   alpha = dir(18),
   AL = parallel(A, (B-A) * alpha),
   AM = parallel(A, (C-A) * alpha),
   L = intersectionpoint(AL, line(B, C)),
   M = intersectionpoint(AM, line(D, C)),
   LK = parallel(L, AM),
   MN = parallel(M, AL),
   K = intersectionpoint(LK, line(A, B)),
   N = intersectionpoint(MN, line(A, D)),

   Lp = L * (D/B);

// plain.N

draw(A--B--C--D--cycle, linewidth(1));
draw(K--L--A--M--N);
draw(A--Lp--N ^^ Lp--D, dashed);

markangle(A, L, K, radius=mr);
markangle(L, A, M, radius=mr);
markangle(N, M, A, radius=mr);
markangle(A, Lp, N, radius=mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, NW));
dot(Label("$K$", K, S));
dot(Label("$L$", L, E));
dot(Label("$M$", M, plain.N));
dot(Label("$N$", N, SW));
dot(Label("$L'$", Lp, plain.N));

