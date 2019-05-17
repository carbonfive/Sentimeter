import React from "react";
import geom from "../geom";

import "./Axes.scss";

const LABEL_X_OFFSET = 20,
  LABEL_Y_OFFSET = 20,
  TIP_ALLOWANCE = 4;

const ArrowTip = ({ transform }) => (
  <path
    d="M10 10 L0 0 L10 -10"
    transform={transform.translate(TIP_ALLOWANCE, 0)}
  />
);

const LeftArrowTip = ({ label, transform, labelAboveAxis }) => (
  <g className="Axes__left-arrow" transform={transform}>
    <ArrowTip transform={geom.identity()} />
    <text x={LABEL_X_OFFSET} y={(labelAboveAxis ? -1 : 1) * LABEL_Y_OFFSET}>
      {label}
    </text>
  </g>
);

const RightArrowTip = ({ label, transform, labelAboveAxis }) => (
  <g className="Axes__right-arrow" transform={transform}>
    <ArrowTip transform={geom.rotate(180)} />
    <text x={-LABEL_X_OFFSET} y={(labelAboveAxis ? -1 : 1) * LABEL_Y_OFFSET}>
      {label}
    </text>
  </g>
);

const HorizontalAxis = ({ viewMatrix, minLabel, maxLabel }) => {
  const minPoint = geom.transform(viewMatrix, geom.point(0, 0.5)),
    maxPoint = geom.transform(viewMatrix, geom.point(1, 0.5)),
    minPointMat = geom.translate(minPoint.x, minPoint.y),
    maxPointMat = geom.translate(maxPoint.x, maxPoint.y);

  return (
    <g className="Axis">
      <line
        x1={minPoint.x + TIP_ALLOWANCE}
        y1={minPoint.y}
        x2={maxPoint.x - TIP_ALLOWANCE}
        y2={maxPoint.y}
      />
      <LeftArrowTip
        label={minLabel}
        labelAboveAxis={false}
        transform={minPointMat}
      />
      <RightArrowTip
        label={maxLabel}
        labelAboveAxis={false}
        transform={maxPointMat}
      />
    </g>
  );
};

const VerticalAxis = ({ viewMatrix, minLabel, maxLabel }) => {
  const minPoint = geom.transform(viewMatrix, geom.point(0.5, 0)),
    maxPoint = geom.transform(viewMatrix, geom.point(0.5, 1)),
    minPointMat = geom.translate(minPoint.x, minPoint.y),
    maxPointMat = geom.translate(maxPoint.x, maxPoint.y);

  return (
    <g className="Axis">
      <line
        x1={minPoint.x}
        y1={minPoint.y - TIP_ALLOWANCE}
        x2={maxPoint.x}
        y2={maxPoint.y + TIP_ALLOWANCE}
      />
      <LeftArrowTip
        label={maxLabel}
        labelAboveAxis={true}
        transform={maxPointMat.rotate(90)}
      />
      <RightArrowTip
        label={minLabel}
        labelAboveAxis={true}
        transform={minPointMat.rotate(90)}
      />
    </g>
  );
};

export default ({ surveyData, viewMatrix }) => {
  console.log(surveyData);
  return (
    <g className="Axes">
      <VerticalAxis
        viewMatrix={viewMatrix}
        minLabel={surveyData.y_min_label}
        maxLabel={surveyData.y_max_label}
      />
      <HorizontalAxis
        viewMatrix={viewMatrix}
        minLabel={surveyData.x_min_label}
        maxLabel={surveyData.x_max_label}
      />
    </g>
  );
};
