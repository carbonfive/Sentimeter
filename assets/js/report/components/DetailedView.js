import React from "react";
import Popup from "reactjs-popup";
import "./DetailedView.scss";
import Response from "./Response";

//alternate ways of doing confidence and interest
// Example 1: flat array
// confidence: [0.25, 2.4, 3, 3.5, 4.2]

// Example 2: nested array
// confidence: [3, [2.4, 3.5], [0.25, 4.2]],

const defaultStyle = {
  backgroundColor: "#FFFFFF",
  borderRadius: "3px",
  width: "auto",
  marginRight: "50px",
  marginLeft: "50px",
  marginTop: "50px",
  marginBottom: "50px",
  paddingLeft: "0px",
  paddingRight: "0px"
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
          <div className="DetailedView__top">
            <div className="DetailedView__title">{point && point.name}</div>
            <div className="DetailedView__description">
              {point && point.description}
            </div>
            <div className="DetailedView__highlights-box">
              <div className="DetailedView__highlights">
                <strong>{point && point.influential} people</strong> consider{" "}
                {point && point.name} influential
              </div>
              <div className="DetailedView__highlights">
                <strong>{point && point.would_recommend} people</strong> would
                recommend using {point && point.name} on a project at Carbon
                Five
              </div>
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
    </Popup>
  );
};

export default DetailedView;
