document.addEventListener("DOMContentLoaded", function() {
  var orderButton = document.getElementById("order_button");
  var orderPopup = document.getElementById("order_popup");

  orderButton.addEventListener("click", function() {
    if (orderPopup.style.display === "none" || orderPopup.style.display === "") {
      orderPopup.style.display = "block";
      localStorage.setItem('orderPopupVisible', 'true');
    } else {
      orderPopup.style.display = "none";
      localStorage.setItem('orderPopupVisible', 'false');
    }
  });

  window.addEventListener("click", function(event) {
    if (event.target == orderPopup) {
      orderPopup.style.display = "none";
    }
  });

  window.addEventListener("keydown", function(event) {
    if (event.key === "Escape") {
      orderPopup.style.display = "none";
    }
  });
});
