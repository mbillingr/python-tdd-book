
Builder := Object clone

Builder depth := "" asMutable

Builder forward := method(
  writeln(depth, "<", call message name, ">")
  depth appendSeq("    ")
  call message arguments foreach(
    arg,
    content := self doMessage(arg);
    if(content type == "Sequence", writeln(depth, content))
  )
  depth removeSuffix("    ")
  writeln(depth, "</", call message name, ">")
)

Builder ul(
  li("Io"),
  li("Lua"),
  li("JavaScript")
)
