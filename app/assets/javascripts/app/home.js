$(document).ready(function () {

  //Calendar dates for booking
  var date_picker = function(){
    $( ".first_day" ).datepicker({
      dateFormat: "MM dd, yy",
      defaultDate: 0,
      maxDate: 0,
      defaultDate: 0,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).parents('.form-inputs').find( ".last_day").datepicker( "option", {"minDate": selectedDate, "defaultDate": selectedDate} );
      }
    });
    $( ".last_day" ).datepicker({
      dateFormat: "MM dd, yy",
      defaultDate: +1,
      maxDate: 0,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).parents('.form-inputs').find( ".first_day").datepicker( "option", {"maxDate": selectedDate, "defaultDate": selectedDate} );
      }
    });
  };
  date_picker();
  //end calendar dates for booking

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