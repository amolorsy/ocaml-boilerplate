exception Unsupported_command

type command = 
  | HELP
  | NEW of string

let get_command (arguments: string list) = 
  match arguments with
  | ["help"] -> HELP
  | ["new"; project_name] -> NEW project_name
  | _ -> raise Unsupported_command

let display_usage () = print_endline
  "Usage:
    ocaml-boilerplate help                  Display full usage
    ocaml-boilerplate new <project_name>    Create a new project which is named <project_name>"

(* TODO *)
let create_project (project_name: string) = ()

let run (command: command) =
  match command with
  | HELP -> display_usage ()
  | NEW project_name -> create_project project_name

let () =
  try let command = get_command (List.tl (Array.to_list Sys.argv)) in
  run command
  with Unsupported_command -> display_usage()
  