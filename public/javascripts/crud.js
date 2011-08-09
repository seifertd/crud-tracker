var crudGame = function () {
  var game_id = 1;
  var table = null;
  var players = [];

  function player(entrant_id) {
    var return_value = null;
    $(players).each(function(idx) {
      if (this.entrant_id == entrant_id) {
        return_value = this;
      }
    });
    return return_value;
  }

  function num_alive_players() {
    var num_alive = 0;
    $(players).each(function(idx) {
      if (this.alive) { num_alive++; }
    });
    return num_alive;
  }

  function move_row_to_bottom(row) {
    var dom_row = $(row).get(0);
    // Delete the row
    row.remove();
    // Append the row to the end of the table
    table.append(dom_row);
  }

  function end_game() {
    var winner = $(table).find("tr[data-player]:first");
    var winner_dom = winner.get(0);
    winner.remove();
    table.append(winner_dom);
    var game_data = {
      id: game_id,
      entrant_ids: [],
      player_ids: [],
      submit: 'game over',
      _method: 'put',
      authenticity_token: AUTH_TOKEN
    };
    $($(table).find("tr[data-player]").get().reverse()).each(function(idx) {
      game_data.entrant_ids.push($(this).attr("data-player"));
      game_data.player_ids.push($(this).attr("data-pid"));
    });
    $.post('/games/' + game_id + '.json', game_data, function(response_data, textStatus, jqXHR) {

      // TODO: Ask to start another game with same players.
      
      // If the game is over, redirect to home
      if (!response_data.game.started) {
        if ( confirm("The game is over!\nDo you want to continue this game\n(play another game with the\norder set by the previous game)?") ) {
          var form = $("<form>").attr("method", "post").attr("action", "/games");
          $("<input type='hidden'>").attr("name", "authenticity_token").attr("value", AUTH_TOKEN).appendTo(form);
          $(game_data.player_ids.reverse()).each(function(idx, player_id) {
            $("<input type='hidden'>").attr("name", "player_ids[]").attr("value", player_id).appendTo(form);
          });
          form.appendTo("body");
          form.submit();
        } else {
          window.location = "/players";
        }
        return;
      }
      // Make everything live
      $(table).find("tr[data-player]").attr("data-alive", 'true');
      // Clear the strikes
      $(table).find("tr[data-player] td.strikes").html("");
      // Clean the data
      $(players).each(function(idx) {
        this.alive = true;
        this.strikes = 0;
      });
      // Add the click handlers back
      add_click_handlers();
    });
  }

  function add_click_handlers() {
    $(table).find("td.strikes").click(function() {
      var row = $(this).parent();
      var entrant_id = parseInt(row.attr("data-player"));
      var entrant = player(entrant_id);
      if (entrant) {
        $(this).append("<img src='/images/strike.gif'>");
        entrant.strikes++;
        if (entrant.strikes >= 3) {
          entrant.alive = false;
          row.attr("data-alive", "false"); 
          $(this).unbind('click');
          move_row_to_bottom(row);
        }
        // Check if there is only one alive entry and end the game
        if (num_alive_players() <= 1) {
          end_game();
        }
      } else {
        alert("COULD NOT FIND ENTRANT WITH ID " + entrant_id);
      }
    });
  }

  return {
    start: function(crud_game) {
      game_id = $(crud_game).attr("data-game");
      table = $(crud_game).find("table");
      $(table).find("tr[data-player]").each(function(idx) {
        players.push({
          entrant_id: parseInt($(this).attr("data-player")),
          strikes: parseInt($(this).attr("data-strikes")),
          alive: $(this).attr("data-alive") == "true"
        });
      });
      add_click_handlers();
    }
  }
}();

$(document).ready(function() {
  crudGame.start($(".crud_game"));
});
