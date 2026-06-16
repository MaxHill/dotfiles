open Cmdliner

let greet_handler name greeting = Logs.app (fun m -> m "%s %s" greeting name)

let greet_cmd =
  let name_arg =
    let doc = "Name to greet." in
    Arg.(value & pos 0 string "person" & info [] ~docv:"NAME" ~doc)
  in
  let greeting_arg =
    let doc = "Greeting to use." in
    Arg.(value & opt string "Hello" & info [ "greeting" ] ~docv:"GREETING" ~doc)
  in

  let info = Cmd.info "greet" ~doc:"Say hello" in
  Cmd.v info Term.(const greet_handler $ name_arg $ greeting_arg)

let () =
  let main_info = Cmd.info "prg" ~version:"0.1.0" ~doc:"Example CLI" in
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs.set_level (Some Logs.Info);
  exit (Cmd.eval (Cmd.group main_info [ greet_cmd ]))
