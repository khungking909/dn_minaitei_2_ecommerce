//= require jquery
//= require jquery_ujs
$(document).on('turbo:load', function() {
  $('.dropdown-toggle').click(function(e) {
    e.preventDefault();
    var $parent = $(this).parent();
    $parent.toggleClass('show');
    $parent.find('.dropdown-menu').toggleClass('show');
  });

  $(document).click(function(e) {
    var $clickTarget = $(e.target);
    if (!$clickTarget.closest('.dropdown-toggle').length && !$clickTarget.closest('.dropdown-menu').length) {
      $('.dropdown-toggle').parent().removeClass('show');
      $('.dropdown-menu').removeClass('show');
    }
  });
});
