open Unix

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

let create_project (project_name: string) =
  Printf.printf "Creating a project '%s'...\n" project_name;
  
  Unix.mkdir project_name 0o755;
  Sys.chdir project_name;

  let quickstart_command = "oasis quickstart" in
  Printf.printf "Running '%s'...\n%!" quickstart_command;
  ignore (Sys.command quickstart_command);
  print_endline "[OK] A file '_oasis' was created.\n";

  let setup_command = "oasis setup" in
  Printf.printf "Running '%s'...\n%!" setup_command;
  ignore (Sys.command setup_command);
  print_endline "[OK] A file 'setup.ml' was created.\n";

  let configure_command = "ocaml setup.ml -configure" in 
  Printf.printf "Running '%s'...\n%!" configure_command;
  ignore (Sys.command configure_command);

  let build_command = "ocaml setup.ml -build" in 
  Printf.printf "Running '%s'...\n%!" build_command;
  ignore (Sys.command build_command);

  Printf.printf "\nA project '%s' was created successfully!\n%!" project_name

let run (command: command) =
  match command with
  | HELP -> display_usage ()
  | NEW project_name -> create_project project_name

let () =
  try let command = get_command (List.tl (Array.to_list Sys.argv)) in
  run command
  with Unsupported_command -> display_usage()
  