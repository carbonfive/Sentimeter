import React, { Component } from "react";
import getSurveyData from "./surveyData";
import Chart from "./components/Chart";
import "./App.scss";
import geom from "./geom";

const CHART_WIDTH = 1200;

const preprocessResponses = responses => {
  const byComments = responses.sort(
    (a, b) => a.responses.length - b.responses.length
  );
  return responses
    .map(p => ({
      ...p,
      pos: geom.point(p.x_plot, p.y_plot),
      commentIndex: byComments.findIndex(q => p.name == q.name)
    }))
    .sort((a, b) => b.influential - a.influential);
};

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { surveyData: null };
  }

  componentDidMount = async () => {
    const surveyData = await getSurveyData();
    const points = preprocessResponses(surveyData.report_trends);

    this.setState({ surveyData: { ...surveyData, report_trends: points } });
  };
  render() {
    return (
      <div className="App">
        {this.state.surveyData == null ? null : (
          <Chart surveyData={this.state.surveyData} width={CHART_WIDTH} />
        )}
      </div>
    );
  }
}

export default App;
