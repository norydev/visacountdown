//Calendar dates for booking
var date_picker = function(){

  $(".latest_planned").datepicker({
    dateFormat: "dd M yy",
    defaultDate: 0,
    changeMonth: false,
    numberOfMonths: 1,
  });

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
  date_picker();
});