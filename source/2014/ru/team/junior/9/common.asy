import geometry;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(0.5sizes.size);

int n = 7;

point A[];
for (int i = 0; i <=n; ++i) {
    A[i] = dir(degrees(i*pi/n));
}

draw(A[0]--A[1]--A[2]--A[3]--A[4]--A[5]--A[6]--A[7]);
dot(A[1]);
dot(A[2]);
dot(A[3]);
dot(A[4]);
dot(A[5]);
dot(A[6]);

