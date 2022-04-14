;; lib.fnl

;; surely there is a better way to do this

(fn next-key [tbl current-key]
  (or
   (accumulate [val nil
                id view (pairs tbl)
                :until val]
               (if (= id current-key)
                   (next tbl id)
                   nil))
   (next tbl)))

(let [mytable  { :a 5 :b 7 999 17 }]
  ;; we don't know (or care much) in what order pairs will
  ;; return values, so these assertions are just that
  ;; next-key returns an index that is (i) in the table;
  ;; (2) not the current key
  (assert (. { :a true 999 true} (next-key mytable :b)))
  (assert (. { :b true 999 true} (next-key mytable :a)))
  (assert (. { :a true :b true} (next-key mytable 999))))

{ : next-key }
