
object Status extends Enumeration {
  type Status = Value
  val Ongoing, XWins, OWins, Tie = Value
}
import Status._

class Board(val board: String) {
  val XRowPattern = ".*XXX.*".r
  val ORowPattern = ".*OOO.*".r
  val XColPattern = ".*X...X...X.*".r
  val OColPattern = ".*O...O...O.*".r
  val XDiaPattern = "X....X....X|..X..X..X..".r
  val ODiaPattern = "O....O....O|..O..O..O..".r
  val OngoingPattern = ".* .*".r
  val status = board match {
    case XRowPattern() => XWins
    case XColPattern() => XWins
    case XDiaPattern() => XWins
    case ORowPattern() => OWins
    case OColPattern() => OWins
    case ODiaPattern() => OWins
    case OngoingPattern() => Ongoing
    case _ => Tie
  }
}

// Tests

def test_empty_board(): Unit = {
  val state = new Board("   :   :   ")
  assert(state.status== Ongoing )
  println("OK")
}

def test_x_wins_row(): Unit = {
  val state = new Board("OO :XXX:   ")
  assert(state.status == XWins)
  println("OK")
}

def test_x_wins_col(): Unit = {
  val state = new Board("OX :OX : X ")
  assert(state.status == XWins)
  println("OK")
}

def test_x_wins_diag1(): Unit = {
  val state = new Board("XO :OX :  X")
  assert(state.status == XWins)
  println("OK")
}

def test_x_wins_diag2(): Unit = {
  val state = new Board(" OX:OX :X  ")
  assert(state.status == XWins)
  println("OK")
}

def test_o_wins_row(): Unit = {
  val state = new Board("X X:OOO: X ")
  assert(state.status == OWins)
  println("OK")
}

def test_o_wins_col(): Unit = {
  val state = new Board("OX :OX :O X")
  assert(state.status == OWins)
  println("OK")
}

def test_o_wins_diag1(): Unit = {
  val state = new Board("OX :XO : XO")
  assert(state.status == OWins)
  println("OK")
}

def test_o_wins_diag2(): Unit = {
  val state = new Board(" XO:XO :O X")
  assert(state.status == OWins)
  println("OK")
}

def test_tie(): Unit = {
  val state = new Board("XOX:XXO:OXO")
  assert(state.status == Tie)
  println("OK")
}

test_empty_board()

test_x_wins_row()
test_x_wins_col()
test_x_wins_diag1()
test_x_wins_diag2()

test_o_wins_row()
test_o_wins_col()
test_o_wins_diag1()
test_o_wins_diag2()

test_tie
