import React from "react";
import "./Distribution.scss";

function toPercent(value) {
  return (value - 1) * 25;
}

const DistributionChart = ({ distribution }) => {
  const medianPercent = toPercent(distribution.median);
  const medianStyle =
    medianPercent == 100
      ? { right: "0px" }
      : { left: `${toPercent(distribution.median)}%` };
  const quartileStyle = {
    left: `${toPercent(distribution.lower_quartile)}%`,
    right: `${100 - toPercent(distribution.upper_quartile)}%`
  };
  const tailStyle = {
    left: `${toPercent(distribution.lower_extreme)}%`,
    right: `${100 - toPercent(distribution.upper_extreme)}%`
  };

  return (
    <div className="Distribution__chart">
      <div className="Distribution__chart-graph">
        <div
          style={medianStyle}
          className="Distribution__bar Distribution__bar--median"
        />
        <div
          style={quartileStyle}
          className="Distribution__bar Distribution__bar--quartile"
        />
        <div
          style={tailStyle}
          className="Distribution__bar Distribution__bar--tail"
        />
      </div>
      <div className="Distribution__chart-legend">
        <span className="Distribution__marker Distribution__marker--1">1</span>
        <span className="Distribution__marker Distribution__marker--2">2</span>
        <span className="Distribution__marker Distribution__marker--3">3</span>
        <span className="Distribution__marker Distribution__marker--4">4</span>
        <span className="Distribution__marker Distribution__marker--5">5</span>
      </div>
    </div>
  );
};
const Distribution = ({ distribution, minLabel, maxLabel }) => {
  return (
    <div className="Distribution">
      <div className="Distribution__min-label">{minLabel}</div>
      <DistributionChart distribution={distribution} />
      <div className="Distribution__max-label">{maxLabel}</div>
    </div>
  );
};

export default Distribution;
