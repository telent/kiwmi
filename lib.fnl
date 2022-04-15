;; lib.fnl

;; surely there is a better way to do this

(fn next-key [tbl current-key]
  "Returns the next key in tbl after current-key
or the first key if current-key is last. tbl is traversed
using pairs, so ordering may not be what you expect."
  (or
   (accumulate [val nil
                id view (pairs tbl)
                :until val]
               (and (= id current-key) (next tbl id)))
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
