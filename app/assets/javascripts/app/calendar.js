//Calendar dates for booking
  $(function() {
    $( ".first_day" ).datepicker({
      dateFormat: "dd/mm/yy",
      // minDate: 0,
      defaultDate: 0,
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).parents('.form-inputs').find( ".last_day").datepicker( "option", "minDate", selectedDate );
      }
    });
    $( ".last_day" ).datepicker({
      dateFormat: "dd/mm/yy",
      defaultDate: +1,
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).parents('.form-inputs').find( ".first_day").datepicker( "option", "maxDate", selectedDate );
      }
    });
  });
//end calendar dates for booking