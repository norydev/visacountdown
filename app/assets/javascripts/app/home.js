//Calendar dates for booking
var date_picker = function(){

  if ($( ".latest_planned" ).val()) {
    $( ".latest_planned" ).val(moment($(".latest_planned").val().toString()).format('DD MMM YYYY'));
  }
  $( ".latest_planned" ).datepicker({
    dateFormat: "dd M yy",
    defaultDate: 0,
    changeMonth: false,
    numberOfMonths: 1,
  });

  if ($( ".first_day" ).val()) {
    $( ".first_day" ).val(moment($( ".first_day" ).val().toString()).format('DD MMM YYYY'));
  }
  $( ".first_day" ).datepicker({
    dateFormat: "dd M yy",
    defaultDate: 0,
    changeMonth: false,
    numberOfMonths: 1,
    onClose: function( selectedDate ) {
      if (selectedDate) {
        $(this).parents('.row').find( ".last_day").datepicker( "option", {"defaultDate": selectedDate} );
        $(this).change();
      }
    }
  });

  if ($( ".last_day" ).val()) {
    $( ".last_day" ).val(moment($( ".last_day" ).val().toString()).format('DD MMM YYYY'));
  }
  $( ".last_day" ).datepicker({
    dateFormat: "dd M yy",
    defaultDate: +1,
    changeMonth: false,
    numberOfMonths: 1,
    onClose: function( selectedDate ) {
      if (selectedDate) {
        $(this).parents('.row').find( ".first_day").datepicker( "option", {"defaultDate": selectedDate} );
        $(this).change();
      }
    }
  });
};
//end calendar dates for booking

$(document).ready(function () {
  if (!Modernizr.inputtypes.date) {
    date_picker();
  }
});