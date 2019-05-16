import React from "react"

import "./ChartHeader.scss"

const PointDetail = ({ point }) => (
  <div className="ChartHeader__point-detail">
    {point && (
      <span>
        {point.trend} ({point.count} responses) ({point.pos.x.toFixed(1)},
        {point.pos.y.toFixed(1)})
      </span>
    )}
  </div>
)

export default ({ surveyData, curPoint }) => (
  <header className="ChartHeader">
    <h1>{surveyData.survey.name}</h1>
    <PointDetail point={curPoint} />
  </header>
)
