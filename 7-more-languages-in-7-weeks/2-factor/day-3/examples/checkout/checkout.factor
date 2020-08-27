USING: accessors kernel math sequences ;

IN: examples.checkout

TUPLE: cart-item name price quantity ;

: <cart-item> ( x y z -- item ) cart-item boa ;

! exercise 1
: <cart-item-price> ( x -- item ) "default" swap 0 <cart-item> ;

! exercise 2
: cart-item-discount ( item pct -- item )
  swap [ swap 100 / * ] change-price ;

TUPLE: checkout item-count base-price taxes shipping total-price ;

: sum ( seq -- n ) 0 [ + ] reduce ;
: cart-item-count ( cart -- count ) [ quantity>> ] map sum ;
: cart-item-price ( cart-item -- price ) [ price>> ] [ quantity>> ] bi * ;
: cart-base-price ( cart -- price ) [ cart-item-price ] map sum ;

: <base-checkout> ( item-count base-price -- checkout ) f f f checkout boa ;
: <checkout> ( cart -- checkout ) [ cart-item-count ] [ cart-base-price ] bi <base-checkout> ;

CONSTANT: gst-rate 0.05
CONSTANT: pst-rate 0.09975

: gst-pst ( price -- taxes ) [ gst-rate * ] [ pst-rate * ] bi + ;

: taxes ( checkout taxes-calc -- taxses )
  [ dup base-price>> ] dip
  call >>taxes
  ; inline

CONSTANT: base-shipping 1.49
CONSTANT: per-item-shipping 1.00

: per-item ( checkout -- shipping )
  per-item-shipping * base-shipping + ;

: shipping ( checkout shipping-calc -- shipping )
  [ dup item-count>> ] dip
  call >>shipping ; inline

: total ( checkout -- total-price )
  dup [ base-price>> ] [ taxes>> ] [ shipping>> ] tri + +
  >>total-price ;

: sample-checkout ( checkout -- checkout )
  [ gst-pst ] taxes [ per-item ] shipping total ;


! exericse 3

: capped-tax ( price -- tax ) 0.1 * 42 min ;
