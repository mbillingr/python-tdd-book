
number = rand(123456)
running = true

while running
  puts "Guess my number..."
  guess = gets.to_i

  if guess > number
    puts "too high"
  end

  if guess < number
    puts "too low"
  end

  if guess == number
    puts "#{guess} is correct!"
    running = false
  end

end

