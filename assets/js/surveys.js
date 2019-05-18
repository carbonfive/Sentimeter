import $ from "jquery";
window.$ = $;
export default () => {
  $(document).ready(() => {
    let lastIndex = $("#survey-trends-fields .survey-trends-fields__row")
      .length;
    $("#add-survey-trend").on("click", function(e) {
      e.preventDefault();

      const template = $(this).attr("data-template");
      var uniq_template = template.replace(/\[0]/g, `[${lastIndex}]`);
      uniq_template = uniq_template.replace(/_0_/g, `_${lastIndex}_`);
      $("#survey-trends-fields").append($(uniq_template));
      lastIndex = lastIndex + 1;
    });
  });
};
