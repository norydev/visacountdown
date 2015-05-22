$(document).ready(function () {

  //Calendar dates for booking
  var date_picker = function(){

    var max_date = "";

    if ($('#user_last_entry').val()) {
      max_date = $('#user_last_entry').val();
    }

    $(".latest_planned").datepicker({
      dateFormat: "MM dd, yy",
      defaultDate: 0,
      defaultDate: 0,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( ".last_day").datepicker( "option", {"maxDate": selectedDate, "defaultDate": 0} );
        $( ".first_day").datepicker( "option", {"maxDate": selectedDate, "defaultDate": 0} );
        $(this).change();
      }
    });

    $( ".first_day" ).datepicker({
      dateFormat: "MM dd, yy",
      defaultDate: 0,
      // maxDate: 0,
      maxDate: max_date,
      defaultDate: 0,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        if (selectedDate) {
          $(this).parents('.form-inputs').find( ".last_day").datepicker( "option", {"minDate": selectedDate, "defaultDate": selectedDate} );
          $(this).change();
        }
      }
    });
    $( ".last_day" ).datepicker({
      dateFormat: "MM dd, yy",
      defaultDate: +1,
      // maxDate: 0,
      maxDate: max_date,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        if (selectedDate) {
          $(this).parents('.form-inputs').find( ".first_day").datepicker( "option", {"maxDate": selectedDate, "defaultDate": selectedDate} );
          $(this).change();
        }
      }
    });
  };
  date_picker();
  //end calendar dates for booking


  // Validates submit btn
  var validate_submit = function() {
    var first_day_input = $('#all_stays .first_day');
    var last_day_input = $('#all_stays .last_day');
    var latest_planned_input = $('#user_last_entry');

    if (first_day_input.val() != '' && last_day_input.val() != '') {
      first_day_input.parents('.form-inputs').find('.stay_submit').prop("disabled", false);
    } else {
      first_day_input.parents('.form-inputs').find('.stay_submit').prop("disabled", true);
    }

    if (latest_planned_input.val() != '') {
      $('#calculate').prop("disabled", false);
    } else {
      $('#calculate').prop("disabled", true);
    }

    //on change
    first_day_input.change(function() {
      var last_day_val = $(this).parents('.form-inputs').find('.last_day').val();
      if ($(this).val() != '' && last_day_val != '') {
        $(this).parents('.form-inputs').find('.stay_submit').prop("disabled", false);
      } else {
        $(this).parents('.form-inputs').find('.stay_submit').prop("disabled", true);
      }
    });

    last_day_input.change(function() {
      var last_day_val = $(this).parents('.form-inputs').find('.first_day').val();
      if ($(this).val() != '' && last_day_val != '') {
        $(this).parents('.form-inputs').find('.stay_submit').prop("disabled", false);
      } else {
        $(this).parents('.form-inputs').find('.stay_submit').prop("disabled", true);
      }
    });

    latest_planned_input.change(function() {
      if ($(this).val() != '') {
        $('#calculate').prop("disabled", false);
      } else {
        $('#calculate').prop("disabled", true);
      }
    });
  };
  validate_submit();

  // Validates submit btn

});