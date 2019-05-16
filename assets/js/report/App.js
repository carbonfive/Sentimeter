import React, { Component } from "react";
import surveyData from "./surveyData";
import Chart from "./components/Chart";
import "./App.scss"

const CHART_WIDTH = 1200

class App extends Component {
  render() {
    return (
      <div className="App">
        <Chart surveyData={surveyData} width={CHART_WIDTH} />
      </div>
    )
  }
}

export default App
