/*
 * Size of images. Each image is responsible for supplementing this
 * value to size() routine */
real size = 7cm;
real markradius = size / 13;

/*
 * Increasing the value results in better quality of 3D images. And
 * larger document. And larger compilation times both on Asymptote
 * stage and LaTeX/dvipdf stage. */
// FIXME should be changed to 16 for the production
int render = 4;

/***** Utils *****/
access geometry;

void mark(path p, int n) {
    draw(p,
        marker(geometry.markinterval(geometry.stickframe(n), rotated=true)),
        p=invisible );
};

