/**
 * See the default export for the shape of data to feed to the chart.
 *
 * The only weird thing is the `pos` attribute; it is as point generated
 * from `geom.point(x, y)`, where x and y are normalized values from 0 to 1.
 */

export default async () => {
  const segments = window.location.pathname.match(new RegExp("[^/]+(?=/$|$)"));
  if (segments.length != 1) {
    throw "No report guid";
  }
  const reportGuid = segments[0];
  const response = await fetch(`/api/reports/${reportGuid}`);
  const json = await response.json();
  return json.data;
};
