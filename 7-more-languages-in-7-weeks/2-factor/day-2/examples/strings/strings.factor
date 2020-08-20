USING: kernel sequences ;
IN: examples.strings

: palindrome? ( str -- ? ) dup reverse = ;
