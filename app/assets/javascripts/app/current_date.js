$(document).ready(function () {

// Current date in turkey
  var today = new Date();
  $('#current_tk_dt').html(today);
// Current date

  $('.last_day').change(function(){

    var first_day = $('#period_first_day').val();
    var last_day = $('#period_last_day').val();

    var nb_days = Math.round(( Date.parse(last_day) - Date.parse(first_day) ) / 86400000) + 1;

    $('#time-spent').html(nb_days);
  });

  $('.first_day').change(function(){

    var first_day = $('#period_first_day').val();
    var last_day = $('#period_last_day').val();

    var nb_days = Math.round(( Date.parse(last_day) - Date.parse(first_day) ) / 86400000) + 1;

    $('#time-spent').html(nb_days);
  });

});