import React, { useState } from "react";
import _ from "lodash";

import Point from "./Point";
import Axes from "./Axes";
import ChartHeader from "./ChartHeader";
import geom from "../geom";
import DetailedView from "./DetailedView";
import ChangeDetail from "./ChangeDetail";

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
  const [curIndex, setCurIndex] = useState(0);
  const [modalOpen, setModalOpen] = useState(false);
  const [hovered, setHovered] = useState(false);
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

  const incrementIndex = () => {
    const nextIndex = (curIndex + 1) % points.length;
    const nextPoint = points[nextIndex];
    setCurIndex(nextIndex);
    setCurPoint(nextPoint);
  };

  const decrementIndex = () => {
    const nextIndex = (curIndex - 1 + points.length) % points.length;
    const nextPoint = points[nextIndex];
    setCurIndex(nextIndex);
    setCurPoint(nextPoint);
  };

  const hover = () => setHovered(true);
  const unhover = () => setHovered(false);
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
            {points.map((point, index) => (
              <Point
                hover={hover}
                unhover={unhover}
                hovered={hovered}
                key={point.name}
                point={point}
                index={index}
                viewMatrix={viewMatrix}
                scaleMatrix={scaleMatrix}
                scale={point.influential / maxCount}
                setCurIndex={setCurIndex}
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
        <ChangeDetail
          modifier="left"
          isOpen={modalOpen}
          action={decrementIndex}
        />
        <ChangeDetail
          modifier="right"
          isOpen={modalOpen}
          action={incrementIndex}
        />
      </React.Fragment>
    </div>
  );
};
