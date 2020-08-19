! exercise easy 1
3 3 * 4 4 * + .


! exercise easy 2
USE: math.functions
3 sq 4 sq + sqrt .


! exercise easy 3
1 2 swap dup rot . . .


! exercise easy 4
USE: ascii
"martin"
"Hello, " swap append >upper
.


! exercise medium 1
{ 1 4 17 9 11 } 0 [ + ] reduce .


! exercise medium 2
100 [1,b] 0 [ + ] reduce .


! exercise medium 3
10 [1,b] [ sq ] map .


! exercise hard 1
42
[ 10 /i ] [ 10 mod ] bi
. .


! exercise hard 2
123456
number>string [ 1string string>number ] each