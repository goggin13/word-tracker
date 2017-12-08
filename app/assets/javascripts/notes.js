$(document).ready(function () {
  $(".note").click(function () {
    $(this).children(".front").toggle();
    $(this).children(".back").toggle();
  });

  $("input[type=submit].delete").click(function () {
    return confirm("Really delete?");
  });
});
