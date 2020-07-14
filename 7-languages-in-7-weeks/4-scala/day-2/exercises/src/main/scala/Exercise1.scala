object Exercise1 {
  def main(args: Array[String]): Unit = {
    val data = Array("A", "BC", "CDE")
    println(s"Total size: ${total_size(data)}")
  }

  def total_size(strings: Array[String]): Int = {
    strings.foldLeft(0)((n, str) => n + str.length)
  }
}
