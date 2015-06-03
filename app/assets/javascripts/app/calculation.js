var delete_row = function(){
  $('.delete-row').click(function(e){
    e.preventDefault();
    var row_to_delete = $(this).closest('.row');
    row_to_delete.slideUp;
    row_to_delete.html('');
  });
};

var add_row = function(){
  $('.add-row').on('click', function(e){
    e.preventDefault();

    $.ajax({
      async: false,
      type: "GET",
      data: {'id': $(this).closest('.row').data('emptyid')},
      url: 'add_empty.js'
    });

    $(this).removeClass('btn-success add-row').addClass('btn-danger delete-row').off('click').html('<i class="fa fa-trash"></i>');
    delete_row();
  });
};

$(document).ready(function () {
  delete_row();
  add_row();
});