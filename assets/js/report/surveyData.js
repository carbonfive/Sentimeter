import dataclip from "./dataclip";

/**
 * See the default export for the shape of data to feed to the chart.
 *
 * The only weird thing is the `pos` attribute; it is as point generated
 * from `geom.point(x, y)`, where x and y are normalized values from 0 to 1.
 */

const maxValue = 5,
  minValue = 1,
  range = maxValue - minValue,
  { values } = dataclip;

const surveyResponses = values.map(([trend, x, y, count]) => ({
  x: (x - minValue) / range,
  y: (y - minValue) / range,
  trend,
  count
}));

export default {
  survey: {
    name: "2019 Carbon Five Survey",
    x_axis_labels: ["Disinterested in it", "Eager to use"],
    y_axis_labels: ["Wary of it", "Confident in using"]
  },
  responses: surveyResponses
};
