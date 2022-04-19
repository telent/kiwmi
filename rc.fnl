(local cursor (kiwmi:cursor))

(local {:view inspect : repl} (require :fennel))

(local { : next-key } (require :lib))

(cursor:on "motion"
           #(match (cursor:view_at_pos) view (view:focus)))

(cursor:on "button_up" #(kiwmi:stop_interactive))

(local all-views {})

(fn focus-view [view]
  (view:focus))

(fn table-size [tbl]
  (accumulate [size 0
               _k _v (pairs tbl)]
              (+ size 1)))

(fn view-attributes []
  (collect
      [k v
       (pairs all-views)]
    k [(v:id) (v:title)]))

;; we will arrange each view to be the output width and height
;; and at an x offset such that it doesn't overlap any other view.
;; then we can switch from one view to the next by panning the
;; output x position sideways

;; I don't know how this interacts with layer-shell windows but
;; I *think* they deal in output-relative or surface-relative
;; co-ordinates so maybe it will be OK. Do need to check whether
;; kiwmi supports layer-shell, ofc

(fn cycle-focus []
  (let [next-id (next-key all-views (: (kiwmi:focused_view) :id))
        output (kiwmi:active_output)
        next-view (. all-views next-id)]
    (let [(x y) (next-view:pos)]
      (output:move x y)
      (next-view:focus)
      (output:redraw)
      )))

(kiwmi:on "view"
          (fn [view]
;            (repl {:env {:aa 42 :kiwmi kiwmi :view view }})
            (let [(w h) (: (kiwmi:active_output) :size)]
              (print :new (* (table-size all-views) w) 0 w h)
              (view:resize w h)
              (view:move (* (table-size all-views) w) 0))
            (view:focus)
            (view:show)
            (tset all-views (view:id) view)
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
