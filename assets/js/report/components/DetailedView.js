import React from "react";
import Popup from "reactjs-popup";
import "./DetailedView.scss";
import Response from "./Response";
import Distribution from "./Distribution";

//alternate ways of doing confidence and interest
// Example 1: flat array
// confidence: [0.25, 2.4, 3, 3.5, 4.2]

// Example 2: nested array
// confidence: [3, [2.4, 3.5], [0.25, 4.2]],

const defaultStyle = {
  backgroundColor: "#FFFFFF",
  borderRadius: "3px",
  width: "100%",
  marginRight: "60px",
  marginLeft: "60px",
  marginTop: "50px",
  marginBottom: "50px",
  paddingLeft: "0px",
  paddingRight: "0px"
};

const DetailedView = ({ surveyData, point, modalOpen, closeModal }) => {
  return (
    <Popup
      modal={true}
      open={modalOpen}
      contentStyle={defaultStyle}
      onClose={closeModal}
    >
      {triggerClose => (
        <div className="DetailedView">
          <div className="DetailedViewContainer">
            <div className="DetailedView__close" onClick={triggerClose}>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="100%"
                viewBox="3 3 12 12"
              >
                <path
                  fill="rgba(0,0,0,0.5)"
                  d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
                />
              </svg>
            </div>
            <div className="DetailedView__top">
              <div className="DetailedView__title">{point && point.name}</div>
              <div className="DetailedView__description">
                {point && point.description}
              </div>
              <div className="DetailedView__highlights-box">
                <div className="DetailedView__highlights">
                  <span className="DetailedView__highlights--emphasized">
                    {point && point.influential} people
                  </span>{" "}
                  consider {point && point.name} influential
                </div>
                <div className="DetailedView__highlights">
                  <span className="DetailedView__highlights--emphasized">
                    {point && point.would_recommend} people
                  </span>{" "}
                  would recommend using {point && point.name} on a project at
                  Carbon Five
                </div>
              </div>
              <div className="DetailedView__distributions">
                {point && (
                  <Distribution
                    distribution={point.x_axis_distribution}
                    minLabel={surveyData.x_min_label}
                    maxLabel={surveyData.x_max_label}
                  />
                )}
                {point && (
                  <Distribution
                    distribution={point.y_axis_distribution}
                    minLabel={surveyData.y_min_label}
                    maxLabel={surveyData.y_max_label}
                  />
                )}
              </div>
            </div>
            <div className="DetailedView__responses">
              {point &&
                point.responses.map((response, index) => (
                  <Response key={index} response={response} />
                ))}
            </div>
          </div>
        </div>
      )}
    </Popup>
  );
};

export default DetailedView;
