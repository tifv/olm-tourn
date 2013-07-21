import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);

currentpen = gray(0.5);

for (int i = 0; i <= 10; ++i) {
    draw((0, i)--(10, i));
    draw((i, 0)--(i, 10));
}

currentpen = black+2;
draw((0,0)--(10,0)--(10,10)--(0,10)--cycle);
draw((1,0)--(1,5));
for (int i = 5; i <= 9; ++i) {
    draw((0,i)--(10,i));
}
for (int i = 1; i <= 4; ++i) {
    draw((i,10-i)--(i,9-i));
}

