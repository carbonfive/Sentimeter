import React from "react"
import ReactDom from "react-dom"
import Popup from "reactjs-popup";
import './DetailedView.scss'

const vueExample = {
  title: "Vue.js",
  description: "An alternative JS MVC framework to both React and Angular that follows some of the syntax and styles of Angular.js 1.x, but with significantly better speed and modern tooling. Allows progressive adoption so it can be “dropped in” to existing server side applications more easily.",
  influential: 32,
  recommend: 14,
  confidence: {
    lower_extreme: 0.25,
    lower_quartile: 2.4,
    median: 3,
    upper_quartile: 3.5,
    upper_extreme: 4.2
  },
  interest: {
    lower_extreme: 2.4,
    lower_quartile: 3.5,
    median: 4.2,
    upper_quartile: 4.5,
    upper_extreme: 5
  },
  responses: [
    {
      name: "Rudy Jahchan",
      email: "rudy@carbonfive.com",
      text: "This is a great framework for replacing Angular. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    },
  ]
}

//alternate ways of doing confidence and interest
// Example 1: flat array
// confidence: [0.25, 2.4, 3, 3.5, 4.2]

// Example 2: nested array
// confidence: [3, [2.4, 3.5], [0.25, 4.2]],


const defaultStyle = {
  "backgroundColor":"#FFFFFF",
  "borderRadius": "3px",
  "width": "auto",
  "margin-right": "50px",
  "margin-left": "50px",
};

const DetailedView = ({ point, modalOpen, closeModal }) => {
  return (
    <Popup
      modal={true}
      open={modalOpen}
      contentStyle={defaultStyle}
      onClose={closeModal}
      >
      <div className="DetailedView">
        <div className="DetailedViewContainer">
          <div className="DetailedView__title">{point && point.trend}</div>
          <div className="DetailedView__description">{vueExample.description}</div>
          <div className="DetailedView__highlights-box">
            <div className="DetailedView__highlights">
              <strong>{vueExample.influential} people</strong> consider {point && point.trend} influential
            </div>
            <div className="DetailedView__highlights">
              <strong>{vueExample.recommend} people</strong> would recommend using {point && point.trend} on a project at Carbon Five
            </div>
          </div>
        </div>
      </div>
    </Popup>
  )
}

export default DetailedView