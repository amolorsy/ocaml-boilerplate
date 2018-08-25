open Message

let create_project (project_name: string) =
  let initial_directory = Sys.getcwd() in
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
  | WEXITED 0 -> print_message "[OK] A file '_oasis' was created.\n"
  | _ -> ignore (exit 0));  

  if not (Sys.file_exists "setup.ml") then
    (let setup_command = "oasis setup" in
    print_message ("Running '" ^ setup_command ^ "'...");
    ignore (Sys.command setup_command);
    print_message "[OK] A file 'setup.ml' was created.\n");

  let configure_command = "ocaml setup.ml -configure" in 
  print_message ("Running '" ^ configure_command ^ "'...");
  ignore (Sys.command configure_command);

  let build_command = "ocaml setup.ml -build" in
  print_message ("Running '" ^ build_command ^ "'...");
  ignore (Sys.command build_command);

  print_message ("\nA project '" ^ project_name ^ "' was created successfully!")
