//Calendar dates for booking
  $(function() {
    $( ".first_day" ).datepicker({
      dateFormat: "dd/mm/yy",
      // minDate: 0,
      defaultDate: 0,
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).next().datepicker( "option", "minDate", selectedDate );
      }
    });
    $( ".last_day" ).datepicker({
      dateFormat: "dd/mm/yy",
      defaultDate: +1,
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).prev().datepicker( "option", "maxDate", selectedDate );
      }
    });
  });
//end calendar dates for booking