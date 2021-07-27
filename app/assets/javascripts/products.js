$(document).ready(function() {
  $('#selectAll').click(function() {
    if (this.checked) {
      $(':checkbox').each(function() {
        this.checked = true;
      });
    } else {
      $(':checkbox').each(function() {
        this.checked = false;
      });
    }
  });

  $("#edit_multiple").click(function(event) {
    // event.preventDefault();
    var checked_pr_array = [];
    $('#products_table :checked').each(function() {
      checked_pr_array.push($(this).val());
    });
    var url = $(this).attr('href');
    $.ajax({
      url: url,
      data: {
        product_ids: checked_pr_array
      },
      type: "GET",
      success: function(response) {
        //console.log(response)
      },
      error: function(xhr, textStatus, errorThrown) {}
    });
  });

  $('#deleteAll').click(function() {
    // event.preventDefault();
    var array = [];
    $('#products_table :checked').each(function() {
      array.push($(this).val());
    });

    $.ajax({
      type: "POST",
      url: $(this).attr('href') + '.json',
      data: {
        ids: array
      },
      beforeSend: function() {
        return confirm("Вы уверенны?");
      },
      success: function(data, textStatus, jqXHR) {
        if (data.status === 'ok') {
          //alert(data.message);
          location.reload();
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log(jqXHR);
      }
    })

  });


});

$(document).ready(function(e) {
  var $container_table = $('#container_for_table_with_data');

  var header_height = $('header').height();
  var filter_height = $('#filter_menu').height();
  var pagination_height = $('.digg_pagination').height();

  $container_table.height($(window).height() - header_height - filter_height - pagination_height - 70);
  console.log($(window).height(), header_height, filter_height, pagination_height, $container_table.height())

  $(window).resize(function() {
    var header_height = $('header').height();
    var filter_height = $('#filter_menu').height();
    var pagination_height = $('.digg_pagination').height();

    $container_table.height($(window).height() - header_height - filter_height - pagination_height - 70);
  })
});
