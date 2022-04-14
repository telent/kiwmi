(local cursor (kiwmi:cursor))

(cursor:on "motion"
           #(match (cursor:view_at_pos) view (view:focus)))

(cursor:on "button_up" #(kiwmi:stop_interactive))

(kiwmi:on "view"
          (fn [view]
            (let [(w h) (: (kiwmi:active_output) :size)]
              (view:resize w h))
            (view:focus)
            (view:show)

            (view:on "request_move" #(view:imove))
            (view:on "request_resize" (fn [ev] (view:iresize ev.edges)))))

(local keybinds {
                 :Escape #(kiwmi:quit)
                 :Return #(kiwmi:spawn "foot")
                 :w #(match (kiwmi:focused_view) view (view:close))
                 })

(kiwmi:on "keyboard"
          (fn [keyboard]
            (keyboard:on "key_down"
                         (fn [ev]
                           (if (. (ev.keyboard:modifiers) :alt)
                               (match (. keybinds ev.key)
                                 bind (or (bind ev) true)
                                 nil false)
                               false)))))

(kiwmi:spawn "swaybg -c '#ff00ff'")
