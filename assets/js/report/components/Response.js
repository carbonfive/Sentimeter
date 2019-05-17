import React from "react";
import "./Response.scss";
import gravatar from "gravatar";
const Response = ({ response }) => {
  return (
    <div className="Response">
      <div className="Response__quote">"{response.thoughts}"</div>
      <div className="Response__attribution">
        <div className="Response__attribution-image">
          <img src={gravatar.url(response.email, { s: 50 })} />
        </div>
        <div className="Response__attribution-name">{response.email}</div>
      </div>
    </div>
  );
};

export default Response;
