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

let reset_print_color () = print_string "\027[0m"

let print_message (message: string) =
  print_string "\027[1;32m";
  print_endline message;
  reset_print_color();
  flush stdout

let print_error_message (message: string) =
  print_string "\027[1;31m";
  print_endline message;
  reset_print_color();
  flush stdout

let initial_directory = Sys.getcwd()

let create_project (project_name: string) =
  print_message ("Creating a project '" ^ project_name ^ "'...\n");
  
  (try Unix.mkdir project_name 0o755
  with Unix.Unix_error (err, command, dir) ->
    print_error_message ("Failed to create a project '" ^ project_name ^ "': Directory already exists!");
    ignore (exit 0));
  Unix.chdir project_name;

  let interrupt_handler signal =
    let current_directory = Sys.getcwd() in
      if current_directory = (initial_directory ^ "/" ^ project_name) then
        (Unix.chdir initial_directory;
        Unix.rmdir project_name);
      ignore (exit 0) in
    Sys.set_signal Sys.sigint (Signal_handle interrupt_handler);

  let quickstart_command = "oasis quickstart" in
    print_message ("Running '" ^ quickstart_command ^ "'...");
    (match Unix.system quickstart_command with
      | WEXITED 0 -> print_message "[OK] A file '_oasis' was created."
      | _ -> ignore (exit 0));  

  let setup_command = "oasis setup" in
    print_message ("Running '" ^ setup_command ^ "'...");
    ignore (Sys.command setup_command);
    print_message "[OK] A file 'setup.ml' was created.";

  let configure_command = "ocaml setup.ml -configure" in 
    print_message ("Running '" ^ configure_command ^ "'...");
    ignore (Sys.command configure_command);

  let build_command = "ocaml setup.ml -build" in
    print_message ("Running '" ^ build_command ^ "'...");
    ignore (Sys.command build_command);

  print_message ("\nA project '" ^ project_name ^ "' was created successfully!")

let run (command: command) =
  match command with
    | HELP -> display_usage ()
    | NEW project_name -> create_project project_name

let () =
  try let command = get_command (List.tl (Array.to_list Sys.argv)) in
    run command
  with Unsupported_command -> display_usage()
  