USING: accessors kernel math prettyprint ;

USE: examples.tuples

cart-item new 25.00 >>price
[ 0.5 * ] change-price .


"Seven Languages Book" 25.00 1 cart-item boa .
"Paint brush" <dollar-cart-item> .

T{ cart-item f "orange" 0.59 100 } .
