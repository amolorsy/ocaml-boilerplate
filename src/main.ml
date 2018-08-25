let () =
  let arguments = List.tl (Array.to_list Sys.argv) in
  Command.run arguments
