(ns day-2.core)

(println "DAY 2\n")

(println "Exercise 1")

(defmacro unless-or [uncond no yes]
  (list 'if (list 'not uncond) no yes))

(unless-or true (println "didn't") (println "did"))
(unless-or false (println "didn't") (println "did"))
