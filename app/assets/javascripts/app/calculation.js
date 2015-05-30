$(document).ready(function () {

  var delete_row = function() {

  }

  $('.delete-row').click(function(e){
    e.preventDefault();
    id = $(this).data('id')
    $('#'+id).html('');
  });

});