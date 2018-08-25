type color =
  | RED
  | GREEN

type weight =
  | NORMAL
  | BOLD

let get_color_value color =
  match color with
  | RED -> "31"
  | GREEN -> "32"

let get_weight_value weight =
  match weight with
  | NORMAL -> "0"
  | BOLD -> "1"

let get_message_style_value color weight =
  "\027[" ^ (get_color_value color) ^ ";" ^ (get_weight_value weight) ^ "m"

let set_message_style color weight =
  print_string (get_message_style_value color weight)

let reset_message_style () = print_string "\027[0m"

let print_message (message: string) =
  set_message_style GREEN BOLD;
  print_endline message;
  reset_message_style();
  flush stdout

let print_error_message (message: string) =
  set_message_style RED BOLD;
  print_endline message;
  reset_message_style();
  flush stdout
