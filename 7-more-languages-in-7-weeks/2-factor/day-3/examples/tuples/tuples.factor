USE: kernel

IN: examples.tuples

TUPLE: cart-item name price quantity ;

: <dollar-cart-item> ( name -- cart-item ) 1.00 1 cart-item boa ;
