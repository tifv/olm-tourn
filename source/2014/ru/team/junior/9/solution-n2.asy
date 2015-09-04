// access ../common/ as common.asy
import common;

point X = (0.5A[1]+0.5A[2]), Y = (0.5A[5]+0.5A[6]);

draw(X--Y);

label("$n-2$", (0.5-0.2I) * X + (0.5+0.2I) * Y);

