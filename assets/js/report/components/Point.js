import React, { useState } from "react";
import geom from "../geom";
import classnames from "classnames";

import "./Point.scss";

const MAX_RADIUS = 0.2;

const Point = ({
  viewMatrix,
  scaleMatrix,
  point,
  scale,
  setCurPoint,
  setModalOpen
}) => {
  const { pos, name } = point,
    { x: cx, y: cy } = viewMatrix.transformPoint(pos),
    radius = scale * MAX_RADIUS,
    transform = geom
      .translate(cx, cy)
      .scale(radius, radius)
      .multiply(scaleMatrix),
    textTransform = geom
      .translate(cx, cy)
      .scale(MAX_RADIUS, MAX_RADIUS)
      .multiply(scaleMatrix);

  const textClasses = classnames("Point__label", {
    "Point__label--small": scale < 0.5
  });

  const openModal = point => {
    setCurPoint(point);
    setModalOpen(true);
  };

  return (
    <g className="Point">
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
