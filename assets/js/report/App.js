import React, { Component } from "react";
import getSurveyData from "./surveyData";
import Chart from "./components/Chart";
import "./App.scss";

const CHART_WIDTH = 1200;

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { surveyData: null };
  }

  componentDidMount = async () => {
    const surveyData = await getSurveyData();
    this.setState({ surveyData });
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
