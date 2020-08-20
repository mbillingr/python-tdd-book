USING: examples.strings tools.test math ;
IN: examples.sequences.tests

{ 42 } [ { 0 0 0 0 42 0 10 0 } [ 1 > ] find-first ] unit-test
{ f } [ { 0 0 0 0 42 0 10 0 } [ 100 > ] find-first ] unit-test
