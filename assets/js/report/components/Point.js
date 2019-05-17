import React, { useState } from "react";
import geom from "../geom";
import classnames from "classnames";

import "./Point.scss";

const MAX_RADIUS = 0.2;

const Point = ({
  viewMatrix,
  scaleMatrix,
  point,
  index,
  scale,
  hovered,
  hover,
  unhover,
  setCurIndex,
  setCurPoint,
  setModalOpen
}) => {
  const opacity = 0.6 * scale + 0.2;

  const { pos, name } = point,
    { x: cx, y: cy } = viewMatrix.transformPoint(pos),
    radius = scale * MAX_RADIUS,
    transform = geom
      .translate(cx, cy)
      .scaleNonUniform(radius, radius)
      .multiply(scaleMatrix),
    textTransform = geom
      .translate(cx, cy)
      .scaleNonUniform(MAX_RADIUS, MAX_RADIUS)
      .multiply(scaleMatrix);

  const textClasses = classnames("Point__label", {
    "Point__label--small": scale < 0.5
  });

  const pointClasses = classnames("Point", {
    "Point--hovered": hovered
  });

  const openModal = point => {
    setCurPoint(point);
    setCurIndex(index);
    setModalOpen(true);
  };

  return (
    <g
      className={pointClasses}
      onMouseEnter={hover}
      onMouseLeave={unhover}
      opacity={opacity}
    >
      <circle
        className="Point__highlight"
        transform={transform}
        r={MAX_RADIUS * 1.05}
      />
      <circle
        transform={transform}
        r={MAX_RADIUS}
        onClick={() => {
          openModal(point);
        }}
      />
      <text
        className={textClasses}
        transform={textTransform}
        y={radius + 0.1}
        textAnchor="middle"
      >
        {name}
      </text>
    </g>
  );
};

export default Point;
