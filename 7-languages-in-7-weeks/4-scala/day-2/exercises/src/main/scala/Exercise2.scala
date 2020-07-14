import censor.Censor

object Exercise2 {
  class Replace extends Censor {
  }

  def main(args: Array[String]): Unit = {
    val data = "darn! shoot me parrot."
    val replacer = new Replace()
    val result = replacer.censor(data)
    println(result)
  }
}
