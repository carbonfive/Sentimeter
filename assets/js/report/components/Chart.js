import React, { useState } from "react";
import _ from "lodash";

import Point from "./Point";
import Axes from "./Axes";
import ChartHeader from "./ChartHeader";
import geom from "../geom";
import DetailedView from "./DetailedView";

import "./Chart.scss";

const preprocessResponses = responses =>
  responses
    .map(p => ({
      ...p,
      pos: geom.point(p.x_plot, p.y_plot)
    }))
    .sort((a, b) => b.influential - a.influential);

export default ({ surveyData, width }) => {
  const [curPoint, setCurPoint] = useState(null);
  const [modalOpen, setModalOpen] = useState(false);
  const aspect = 16 / 10,
    height = width / aspect,
    padding = 0.05,
    dataWidth = width / (1 + 2 * padding),
    dataHeight = height / (1 + 2 * padding);

  const points = preprocessResponses(surveyData.report_trends);

  const maxCount = _.maxBy(points, "influential").influential,
    viewMatrix = geom
      .scaleNonUniform(1, -1)
      .scaleNonUniform(dataWidth, dataHeight)
      .translate(padding, -(1.0 + padding)),
    scaleMatrix = geom.scaleNonUniform(dataWidth, dataWidth);

  const closeModal = () => {
    setModalOpen(false);
  };

  return (
    <div>
      <ChartHeader surveyData={surveyData} curPoint={curPoint} />

      <React.Fragment>
        <svg
          className="Chart"
          viewBox={`0 0 ${width} ${height}`}
          width="100%"
          xmlns="http://www.w3.org/2000/svg"
        >
          <Axes surveyData={surveyData} viewMatrix={viewMatrix} />

          <g>
            {points.map(point => (
              <Point
                key={point.name}
                point={point}
                viewMatrix={viewMatrix}
                scaleMatrix={scaleMatrix}
                scale={point.influential / maxCount}
                setCurPoint={setCurPoint}
                setModalOpen={setModalOpen}
              />
            ))}
          </g>
        </svg>
        <DetailedView
          surveyData={surveyData}
          point={curPoint}
          modalOpen={modalOpen}
          closeModal={closeModal}
        />
      </React.Fragment>
    </div>
  );
};
