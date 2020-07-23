(ns day-1.core)

(println "Exercise 1")

(defn big [st n]  (> (count st) n))

(println (big "relatively big" 3))
(println (big "relatively small" 100))
(println "===================================")

(println "Exercise 2")

(defn collection-type [col]
  (cond (list? col) :list
        (vector? col) :vector
        (map? col) :map))

(println (collection-type '(1 2 3)))
(println (collection-type [1 2 3]))
(println (collection-type {1 'a 2 'b}))
(println "===================================")
