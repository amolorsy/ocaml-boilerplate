open Help
open New

exception Unsupported_command

type command = 
  | HELP
  | NEW of string

let get_command (arguments: string list) = 
  match arguments with
  | ["help"] -> HELP
  | ["new"; project_name] -> NEW project_name
  | _ -> raise Unsupported_command

let run (arguments: string list) =
  try let command = get_command arguments in
  match command with
  | HELP -> display_usage()
  | NEW project_name -> create_project project_name
  with Unsupported_command -> display_usage()
