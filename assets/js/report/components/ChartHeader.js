import React from "react";

import "./ChartHeader.scss";

export default ({ surveyData, curPoint }) => (
  <header className="ChartHeader">
    <h1>{surveyData.name}</h1>
  </header>
);
