PHRASE = /line/

line_no = 0
File.foreach('exercise-3.rb') do |line|
  line_no = line_no + 1

  if PHRASE.match(line)
    puts "#{line_no} #{line}"
  end
end

