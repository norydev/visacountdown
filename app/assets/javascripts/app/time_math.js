$(document).ready(function () {

  //calc day per stay
  $('.last_day').change(function(){

    var first_day = $('#period_first_day').val();
    var last_day = $('#period_last_day').val();

    var nb_days = Math.round(( Date.parse(last_day) - Date.parse(first_day) ) / 86400000) + 1;

    $(this).parents('.form-inputs').find('.time-spent').html(nb_days + " days");
  });

  $('.first_day').change(function(){

    var first_day = $('#period_first_day').val();
    var last_day = $('#period_last_day').val();

    var nb_days = Math.round(( Date.parse(last_day) - Date.parse(first_day) ) / 86400000) + 1;

    $(this).parents('.form-inputs').find('.time-spent').html(nb_days + " days");
  });
  //calc day per stay

});