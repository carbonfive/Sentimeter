import $ from "jquery";
window.$ = $;
window.scrollButton = function(elem) {
  const index = parseInt(
    $(elem)
      .closest(".answer-form")
      .attr("data-index")
  );
  const next = $(".answer-form").get(index);
  const y = next.getBoundingClientRect().top + window.scrollY;
  window.scroll({
    top: y,
    behavior: "smooth"
  });
};
