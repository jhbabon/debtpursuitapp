jQuery.fn.fancyInput = function() {
  $(this).each(function() {
    var label = $('[data-class*="label"][data-effect*="overlay"][data-ref="' + $(this).attr("data-id") + '"]');
    label.hideLabel($(this).val());
    $(this).bind({
      'change keyup': function() {
        label.hideLabel($(this).val());
      },
      focus: function() {
        label.addClass('focus');
      },
      blur: function() {
        label.removeClass('focus');
      }
    });
  });
};

jQuery.fn.tooltip = function() {
  $(this).each(function() {
    var tooltip = $('[data-class*="tooltip"][data-ref="' + $(this).attr("data-id") + '"]');
    var offset = $(this).position();
    var left_offset = $(this).width();
    tooltip.css({
      'top': offset.top + "px",
      'left': (left_offset + 10) + "px"
    });
    $(this).bind({
      'mouseenter focus': function() {
        tooltip.fadeIn();
      },
      'mouseleave blur': function() {
        tooltip.fadeOut();
      },
    });
  });
};

jQuery.fn.hideLabel = function(value) {
  if (jQuery.trim(value).length == 0) {
    $(this).show();
  } else {
    $(this).hide();
  };
};

$(document).ready(function() {
  $('[data-class*="input"][data-effect*="overlay"]').fancyInput();
  $('[data-effect*="hintable"]').tooltip();
  $('[data-effect*="datepicker"]').datepicker({ dateFormat: "yy-mm-dd" });
});
