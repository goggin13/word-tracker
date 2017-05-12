$(document).ready(function () {
  $(".note").click(function () {
    $(this).children(".front").toggle();
    $(this).children(".back").toggle();
  });
});
