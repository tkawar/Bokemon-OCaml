let save_path =
  "data/save.dat"

let save_exists () =
  Sys.file_exists save_path

let save_game (player : Player.player) =
  let channel =
    open_out_bin save_path
  in

  Fun.protect
    ~finally:(fun () ->
      close_out_noerr channel)
    (fun () ->
      Marshal.to_channel
        channel
        player
        [])

let load_game () =
  if not (save_exists ()) then
    None
  else
    try
      let channel =
        open_in_bin save_path
      in

      Fun.protect
        ~finally:(fun () ->
          close_in_noerr channel)
        (fun () ->
          let player =
            (Marshal.from_channel channel
              : Player.player)
          in

          Some player)
    with
    | _ ->
        None