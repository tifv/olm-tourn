import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

pen gray = gray(0.7);

for (int i = 0; i <= 10; ++i) {
    draw((0, i)--(10, i), gray);
    draw((i, 0)--(i, 10), gray);
}

draw((0,0)--(10,0)--(10,10)--(0,10)--cycle, linewidth(2));
draw((1,0)--(1,5), linewidth(2));
for (int i = 5; i <= 9; ++i) {
    draw((0,i)--(10,i), linewidth(2));
}
for (int i = 1; i <= 4; ++i) {
    draw((i,10-i)--(i,9-i), linewidth(2));
}

