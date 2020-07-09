
curlyBrackets := method(
  call message arguments foreach(arg,
    doString(arg asString)
  )
)

Object writeAttr := method(
  write(
    call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
    "=",
    call evalArgAt(1))
)

OperatorTable addAssignOperator(":", "writeAttr")

Builder := Object clone

Builder forward := method(
  writeln("<", call message name, ">")
  call message arguments foreach(
    arg,
    content := self doMessage(arg);
    if(content type == "Sequence", writeln(content))
  )
  writeln("</", call message name, ">")
)

Builder book({"author": "Tate"}, "DATA")

{"abc" : "xyz"} println

// not quite there...
