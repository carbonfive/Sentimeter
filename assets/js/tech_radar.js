import GraphingRadar from "./graphing_radar/graphing_radar";

export default function () {
  $('#js-demo').text('This text was injected by tech_radar.js.  Brunch with custom js is working.')
  $(document).ready(() => {
    [1, 2, 3, 4].forEach(num => {
      const category_field_id = `#radar_category_${num}_name`;
      $(category_field_id).on("blur", () => {
        const newName = $(category_field_id).val();
        $(`.category-select option[value="${num}"]`).each(function () {
          $(this).html(newName);
        });
      });
    });
    let lastIndex = $("#radar-trend-fields .row").length;
    $("#add-radar-trend").on("click", function (e) {
      e.preventDefault();
      const template = $(this).attr("data-template");
      var uniq_template = template.replace(/\[0]/g, `[${lastIndex}]`)
      uniq_template = uniq_template.replace(/_0_/g, `_${lastIndex}_`)
      $("#radar-trend-fields").append($(uniq_template));
      [1, 2, 3, 4].forEach(num => {
        const newName = $(`#radar_category_${num}_name`).val();
        $(`.category-select option[value="${num}"]`).each(function () {
          $(this).html(newName);
        });
      });
      lastIndex = lastIndex + 1;
    });

    $("#report-graph").each((index, elem) => GraphingRadar().build("#report-graph", $(elem).attr('data-report-guid')));
  });
}