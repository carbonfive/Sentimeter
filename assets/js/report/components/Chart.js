import React, { useEffect, useState } from "react";
import _ from "lodash";

import Point from "./Point";
import Axes from "./Axes";
import ChartHeader from "./ChartHeader";
import geom from "../geom";
import DetailedView from "./DetailedView";
import ChangeDetail from "./ChangeDetail";

import "./Chart.scss";
import compatibleScale from "../compatibleScale";

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

  const points = surveyData.report_trends;
  const maxCount = _.maxBy(points, "influential").influential,
    viewMatrix = compatibleScale(
      geom.scale(1, -1),
      dataWidth,
      dataHeight
    ).translate(padding, -(1.0 + padding)),
    scaleMatrix = geom.scale(dataWidth, dataWidth);

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

  useEffect(() => {
    const listener = event => {
      if (curPoint != null) {
        if (event.keyCode == 37) {
          decrementIndex();
        } else if (event.keyCode == 39) {
          incrementIndex();
        }
      }
    };
    document.addEventListener("keydown", listener);
    return () => {
      document.removeEventListener("keydown", listener);
    };
  }, [curPoint]);

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
                commentQuadrant={
                  Math.floor((point.commentIndex * 5) / points.length) + 1
                }
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
