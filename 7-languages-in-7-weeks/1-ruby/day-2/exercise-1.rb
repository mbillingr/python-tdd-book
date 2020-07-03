
a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

i = 0
buffer = []

a.each do |x|
  buffer.push x
  i = i + 1
  if i % 4 == 0
    puts "group: #{buffer}"
    buffer = []
  end
end

a.each_slice(4) {|xx| puts "group: #{xx}"}

