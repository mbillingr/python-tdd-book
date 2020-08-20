USING: examples.strings tools.test ;
IN: examples.strings.tests

{ f } [ "foobar" palindrome? ] unit-test
{ t } [ "racecar" palindrome? ] unit-test
