// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var focus = function (id) {
e = $(id);
e.value = "";
e.focus(); 
}

var edit_info = function() {
  Effect.BlindUp('info_panel')
  Effect.BlindDown('create_action')
}

var discard_edit_info = function() {
  Effect.BlindDown('info_panel')
  Effect.BlindUp('create_action')
}