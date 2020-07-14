package censor

trait Censor {
  val replacements = Map("shoot"->"pucky", "darn"->"beans")

  def censor(input: String): String = {
    val s = input.split("((?<=[ ,.!;:]+)|(?=[ ,.!;:]+))")
    s.foldLeft("")((a, b) => a + replacements.getOrElse(b, b))
  }
}
