$(document).ready(function () {

  if ($('#in_turkey').prop("checked")){
    $('#inside_last_entry').show();
  } else if ($('#not_in_turkey').prop("checked")) {
    $('#inside_last_entry').hide();
  }


  //hide social sign up for investors
  $('#in_turkey').change(function() {
    if ($(this).prop("checked")){
      $('#inside_last_entry').slideDown();
    }
  });

  $('#not_in_turkey').change(function() {
    if ($(this).prop("checked")){
      $('#inside_last_entry').slideUp();
    }
  });

});