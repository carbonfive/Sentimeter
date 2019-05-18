import React from "react";
import "./ChangeDetail.scss";
import classnames from "classnames";

const ChangeDetail = ({ modifier, isOpen, action }) => {
  const containerClasses = classnames("ChangeDetail", {
    [`ChangeDetail--${modifier}`]: modifier
  });

  const buttonClasses = classnames("ChangeDetail__button", {
    [`ChangeDetail__button--${modifier}`]: modifier
  });
  if (isOpen) {
    return (
      <div className={containerClasses}>
        <div className={buttonClasses} onClick={action}>
          {modifier == "left" ? (
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="100%"
              viewBox="8 12 28 24"
            >
              <path
                fill="white"
                d="M30.83 14.83L28 12 16 24l12 12 2.83-2.83L21.66 24z"
              />
            </svg>
          ) : modifier == "right" ? (
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="100%"
              viewBox="12 12 28 24"
            >
              <path
                fill="white"
                d="M20 12l-2.83 2.83L26.34 24l-9.17 9.17L20 36l12-12z"
              />
            </svg>
          ) : null}
        </div>
      </div>
    );
  } else {
    return null;
  }
};

export default ChangeDetail;
