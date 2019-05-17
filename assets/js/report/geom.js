export default {
  identity: () => new DOMMatrixReadOnly(),
  translate: (x, y) => new DOMMatrixReadOnly().translate(x, y),
  scaleNonUniform: (x, y) => new DOMMatrixReadOnly().scaleNonUniform(x, y),
  rotate: x => new DOMMatrixReadOnly().rotate(x),
  point: (x, y) => new DOMPoint(x, y),
  transform: (mat, v) => mat.transformPoint(v)
};
