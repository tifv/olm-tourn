/** Some sizes common to most images in the project **/
/* Proposed usage:
 * // use /commmon-sizes.asy as common-sizes.asy
 * access "commmon-sizes.asy" as sizes;
 */

/** Size of images **/
real size = 7cm;
/* Proposed usage:
 * size(sizes.size);
 */

/** Radius of arcs marking the angles **/
real markradius = size / 13;
/* Proposed usage:
 * var mr = sizes.markradius;
 * markangle(A, B, C, radius=mr);
 */

/** Render quality (for 3D images) **/
// FIXME should be changed to 16 for the production
int render = 4;
/* Proposed usage:
 * settings.render = sizes.render;
 *
 * Increasing the value results in better quality 3D images. And
 * larger document. And larger compilation times both on Asymptote
 * stage and LaTeX/dvipdf stage. */

