// game selection
$(document).ready(function() {
  var playing_list = $('#playing_players');
  var available_list = $('#available_players');
  function handle_click(original_li) {
    var li_clicked = $(original_li);
    var parent_ul = li_clicked.parent();

    // Remove from original list
    li_clicked.remove();

    if (parent_ul.attr('id') == 'playing_players') {
      // Make sure the check box is unchecked
      li_clicked.find("input").prop('checked', false);
      if ( $("#playing_players li").length == 1 ) {
        $("li.empty").show();
      }
      // Insert back into available list in alphabetical order by name
      var name = li_clicked.text().trim();
      var inserted = false;
      available_list.find('li').each(function() {
        if ($(this).text().trim() > name) {
          li_clicked.insertBefore($(this));
          inserted = true;
          return false;
        }
      });
      if (!inserted) { available_list.append(original_li); }
      li_clicked.hide().slideDown(200);
    } else {
      // Make sure the check box is checked
      li_clicked.find("input").prop('checked', true);
      $("li.empty").hide();
      li_clicked.hide();
      playing_list.append(original_li);
      li_clicked.slideDown(200);
    }

    // reattach the click handler
    $(original_li).click(function() {
      handle_click(this);
    })
  }
  $(".players li").click(function() {
      handle_click(this);
  });

  $("#new_game").submit(function() {
    try {
    var list_items = $("#playing_players li");
    list_items.each(function(idx) {
      var item = $(list_items[idx]);
      if ( ! item.hasClass('empty') ) {
        $(this).append("<input type='hidden' name='entrant_ids[]' value='" + item.attr("data-id") + "'>");
      }
    });
    } catch(exc) {
      alert("Error submitting form: " + exc);
      return false;
    }
    return true;
  });
});
