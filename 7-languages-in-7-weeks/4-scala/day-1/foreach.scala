def rubyStyleForLoop: Unit = {
  println("for loop using Ruby-style iteration... what's RUBY-STYLE, anyway?")
  args.foreach { arg =>
    println(arg)
  }
}

rubyStyleForLoop
