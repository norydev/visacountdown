$(document).ready(function () {

  if ($('#in_turkey').prop("checked")){
    $('#inside_last_entry').show();
  } else if ($('#not_in_turkey').prop("checked")) {
    $('#inside_last_entry').hide();
  }

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

  ///////////////
  $('.add_stay').click(function(e){
    e.preventDefault();

    $(this).prev('#all_stays').append('<div class="form-inputs"><div class="form-group string optional period_first_day"><label class="string optional control-label" for="period_first_day">First day</label><input class="string optional first_day form-control hasDatepicker" name="period[first_day]" id="period_first_day" type="text"></div><div class="form-group string optional period_last_day"><label class="string optional control-label" for="period_last_day">Last day</label><input class="string optional last_day form-control hasDatepicker" name="period[last_day]" id="period_last_day" type="text"></div></div><div>Time spent: <span id="time-spent"></span></div>');
  });

});