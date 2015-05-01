//= require jquery
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require bootstrap-sprockets

//= require_tree ./app


// Please do not put any code in here. Create a new .js file in
// app/assets/javascripts/app instead, and put your code there

//Calendar dates for booking
  $(function() {
    $( "#period_first_day" ).datepicker({
      dateFormat: "dd/mm/yy",
      // minDate: 0,
      defaultDate: 0,
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( "#period_last_day" ).datepicker( "option", "minDate", selectedDate );
      }
    });
    $( "#period_last_day" ).datepicker({
      dateFormat: "dd/mm/yy",
      defaultDate: +1,
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( "#period_first_day" ).datepicker( "option", "maxDate", selectedDate );
      }
    });
  });
//end calendar dates for booking