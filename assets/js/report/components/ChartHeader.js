import React from "react";

import "./ChartHeader.scss";

export default ({ surveyData, curPoint }) => (
  <header className="ChartHeader">
    <h1>{surveyData.name}</h1>
    <div className="ChartHeader__details">
      <div className="ChartHeader__detail">
        <h4>{surveyData.response_count}</h4>
        <p>Respondents</p>
      </div>
      <div className="ChartHeader__detail">
        <h4>{surveyData.report_trends.length}</h4>
        <p>Technologies</p>
      </div>
    </div>
  </header>
);
