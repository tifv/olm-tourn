import geometry;
access jeolm;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

real a = sqrt(3) / 2;

path[] piece;

for (int i = -3; i <= 3; ++i) {
    piece[i+3] = (0, a * i)--(3 - .5 abs(i), a * i);
}

for (int j = 0; j < 360; j += 60) {
    draw(rotate(j) * piece);
}

