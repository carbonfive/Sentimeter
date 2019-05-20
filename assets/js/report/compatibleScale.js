const scaleTest = new DOMMatrixReadOnly().scale(100, 200);
const compatibleScale =
  scaleTest.e != 0
    ? (m, xScale, yScale) => m.scaleNonUniform(xScale, yScale)
    : (m, xScale, yScale) => m.scale(xScale, yScale);

export default compatibleScale;
