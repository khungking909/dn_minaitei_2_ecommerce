$(document).on('click', '#accept-button', function (event) {
  event.preventDefault();
  var modalSubmitButton = document.querySelector("#modal-submit-button");
  modalSubmitButton.addEventListener("click", function () {
    var modalValue = document.getElementById("modal-text-area").value;
    var form_comment = document.getElementById("order-form-comment");
    form_comment.value = modalValue;
    var form = document.getElementById("order-form-accept");
    form.submit();
  });
});

$(document).on('click', '#refuse-button', function (event) {
  event.preventDefault();
  var modalSubmitButton = document.querySelector("#modal-submit-button");
  modalSubmitButton.addEventListener("click", function () {

    var modalValue = document.getElementById("modal-text-area").value;
    var form_comment = document.getElementById("order-form-comment-refuse");
    form_comment.value = modalValue;
    var form = document.getElementById("order-form-refuse");
    form.submit();
  });
});
