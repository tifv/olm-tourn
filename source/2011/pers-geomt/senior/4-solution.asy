import geometry;
access jeolm;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

pair ratio(real alpha) {
    // required 72 < alpha < 90.
    pair
        A = dir(-36), B = dir(+36),
        C = intersectionpoint(
            parallel(A, dir(-36 + alpha/2)),
            parallel(B, dir(+36 - alpha/2))
        );

    return C / A;
}

pair ratio = ratio(85);

pair A = (0, 1);
pair A(int i) { return rotate(72 i) * A; }
pair A(int k, int i) { return A(i) * ratio^k; }

path P(int k) { return A(k,0)--A(k,1)--A(k,2)--A(k,3)--A(k,4)--cycle; }
path S(int k) { return
    A(k,0)--A(k+1,0)--A(k,1)--A(k+1,1)--A(k,2)--A(k+1,2)--
    A(k,3)--A(k+1,3)--A(k,4)--A(k+1,4)--cycle; }

draw(P(0));
draw(S(0));
draw(P(1));

for (int k = 0; k <= 1; ++k)
    for (int i = 0; i < 5; ++i)
        dot(A(k, i));

for (int i = 0; i < 5; ++i) {
    draw((0,0)--A(0,i));
}
dot((0,0));

real r = 1.5;
draw((-r,-r)--(-r,r)--(r,r)--(r,-r)--cycle, gray(0.5)+1+dashed);
label("$k=1$", (r,1), E, p=gray(0.5));

