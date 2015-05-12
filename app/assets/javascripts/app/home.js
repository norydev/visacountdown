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
        }
      }
    });
  };
  date_picker();
  //end calendar dates for booking

  $('#all_stays first_day').change(function() {
    var last_day_val = $(this).parents('#all_stays').find('.last_day').val();
    if ($(this).val() != '' && last_day_val != '') {
      $(this).parents('#all_stays').find('#stay_submit').attr('disabled', '');
    }
  });

  $('#all_stays last_day').change(function() {
    var last_day_val = $(this).parents('#all_stays').find('.first_day').val();
    if ($(this).val() != '' && last_day_val != '') {
      $(this).parents('#all_stays').find('#stay_submit').attr('disabled', '');
    }
  });

  // // latest visible if in Turkey
  // if ($('#in_turkey').prop("checked")){
  //   $('#inside_last_entry').show();
  // } else {
  //   $('#inside_last_entry').hide();
  // }

  // $('#in_turkey').change(function() {
  //   if ($(this).prop("checked")){
  //     $('#inside_last_entry').slideDown();
  //   } else {
  //     $('#inside_last_entry').slideUp();
  //   }
  // });
  // // latest visible if in Turkey

  // // all stays visible if had previous stays
  // if ($('#has_previous_stays').prop("checked")){
  //   $('#all_stays').show();
  // } else {
  //   $('#all_stays').hide();
  // }

  // $('#has_previous_stays').change(function() {
  //   if ($(this).prop("checked")){
  //     $('#all_stays').slideDown();
  //   } else {
  //     $('#all_stays').slideUp();
  //   }
  // });
  // // all stays visible if had previous stays

});