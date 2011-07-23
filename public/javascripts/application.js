// game drag n drop
$(document).ready(function() {
  $("#available_players, #playing_players").sortable({
    connectWith: ".players",
    receive: function(event, ui) {
      if (ui.sender.attr('id') == 'playing_players') {
        if ( $("#playing_players li").size() == 1 ) {
          $("li.empty").show();
        }
      } else {
        $("li.empty").hide();
      }
    }
  }).disableSelection();

  $("#new_game").submit(function() {
    if ( $("#playing_players li").size() <= 2 ) {
      alert("You must select 2 or more players to compete!");
      return false;
    }

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
