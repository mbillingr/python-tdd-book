"original: " println
"  5 / 0 = " print
(5 / 0) println
"  5 / 2 = " print
(5 / 2) println

Number orig_div := Number getSlot("/")
Number / = method(n, if(n == 0, 0, self orig_div(n)))

"changed: " print
"  5 / 0 = " print
(5 / 0) println
"  5 / 2 = " print
(5 / 2) println
