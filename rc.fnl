(local cursor (kiwmi:cursor))

(local {:view inspect : repl} (require :fennel))

(local { : next-key } (require :lib))

(cursor:on "motion"
           #(match (cursor:view_at_pos) view (view:focus)))

(cursor:on "button_up" #(kiwmi:stop_interactive))

(local all-views {})

(fn focus-view [view]
  (view:focus))

(fn view-attributes []
  (collect
      [k v
       (pairs all-views)]
    k [(v:id) (v:title)]))

(fn cycle-focus []
  (let [next-view (next-key all-views (: (kiwmi:focused_view) :id))]
    (: (. all-views next-view) :focus)))

(kiwmi:on "view"
          (fn [view]
;            (repl {:env {:aa 42 :kiwmi kiwmi :view view }})
            (let [(w h) (: (kiwmi:active_output) :size)]
              (view:resize w h))
            (view:focus)
            (view:show)
            (tset all-views (view:id) view)
            (print (inspect (view-attributes)))
            (view:on "request_move" #(view:imove))
            (view:on "request_resize" (fn [ev] (view:iresize ev.edges)))))

(local keybinds {
                 :Escape #(kiwmi:quit)
                 :Return #(kiwmi:spawn "foot")
                 :Tab cycle-focus
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
