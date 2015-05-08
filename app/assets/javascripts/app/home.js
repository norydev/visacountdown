$(document).ready(function () {

  //Calendar dates for booking
  var date_picker = function(){
    $( ".first_day" ).datepicker({
      dateFormat: "dd MM yy",
      defaultDate: 0,
      maxDate: +1,
      defaultDate: 0,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).parents('.form-inputs').find( ".last_day").datepicker( "option", {"minDate": selectedDate, "defaultDate": selectedDate} );
      }
    });
    $( ".last_day" ).datepicker({
      dateFormat: "dd MM yy",
      defaultDate: +1,
      maxDate: +1,
      changeMonth: false,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $(this).parents('.form-inputs').find( ".first_day").datepicker( "option", {"maxDate": selectedDate, "defaultDate": selectedDate} );
      }
    });
  };
  date_picker();
  //end calendar dates for booking

  //calc day per stay
  // var time_spent = function(){
  //   $('.last_day').change(function(){

  //     var first_day = $(this).parents('.form-inputs').find('.first_day').val();
  //     var last_day = $(this).val();

  //     var nb_days = Math.round(( Date.parse(last_day) - Date.parse(first_day) ) / 86400000) + 1;

  //     if (nb_days) {
  //       $(this).parents('.form-inputs').find('.time-spent').val(nb_days + " days");
  //     } else {
  //       $(this).parents('.form-inputs').find('.time-spent').val("0 days");
  //     }
  //     total_amount();
  //   });

  //   $('.first_day').change(function(){

  //     var first_day = $(this).val();
  //     var last_day = $(this).parents('.form-inputs').find('.last_day').val();

  //     var nb_days = Math.round(( Date.parse(last_day) - Date.parse(first_day) ) / 86400000) + 1;

  //     if (nb_days) {
  //       $(this).parents('.form-inputs').find('.time-spent').val(nb_days + " days");
  //     } else {
  //       $(this).parents('.form-inputs').find('.time-spent').val("0 days");
  //     }
  //     total_amount();
  //   });
  // };
  // time_spent();

  //calc day per stay

  // latest visible if in Turkey
  if ($('#in_turkey').prop("checked")){
    $('#inside_last_entry').show();
  } else {
    $('#inside_last_entry').hide();
  }

  $('#in_turkey').change(function() {
    if ($(this).prop("checked")){
      $('#inside_last_entry').slideDown();
    } else {
      $('#inside_last_entry').slideUp();
    }
  });
  // latest visible if in Turkey

  // Add a stay
  // var stay_row_pt = 0;

  // $('.add_stay').click(function(e){
  //   e.preventDefault();

  //   stay_row_pt += 1;
  //   var stay_row = '<tr class="form-inputs"><td><label for="entry_date_'+stay_row_pt+'">Entry Day:</label><input type="text" id="entry_date_'+stay_row_pt+'" class="first_day form-control"></td><td><label for="exit_date_'+stay_row_pt+'">Exit Day:</label><input type="text" id="exit_date_'+stay_row_pt+'" class="last_day form-control"></td><td><label>Time spent:</label><p id="time_spent_'+stay_row_pt+'" class="time-spent" ></p></td></tr>';

  //   $(this).prev('#all_stays').append(stay_row);

  //   time_spent();
  //   $('.first_day').datepicker('destroy');
  //   $('.last_day').datepicker('destroy');
  //   date_picker();
  // });
  // Add a stay

  // Total amount of days
  // var total_amount = function(){

  //   var total = 0;
  //   var today = new Date();

  //   if ($('#in_turkey').prop("checked") && $('#user_last_entry').val()) {
  //     last_entry = $('#user_last_entry').val();
  //     total += Math.round((Date.parse(today) - Date.parse(last_entry) ) / 86400000);
  //   }

  //   for (i = 0; i <= stay_row_pt; i++) {
  //     value = $('#time_spent_' + i).val();
  //     if (value != "0 days") {
  //       total += parseInt(value.split(" ")[0]);
  //     }
  //   }
  //   $('#total_time_spent').html(total + " days");
  // };
  // Total amount of days

  // Detect change
  // $('#user_last_entry').change(function(){
  //   total_amount();
  // });
  // Detect change

});