
function ends_in_3(num)
	return num % 10 == 3
end

function is_prime(num)
	i = 2
	while i*i <= num do
		if num % i == 0 then
			return false
		end
		i = i + 1
	end
	return true
end

print(assert(ends_in_3(3)))
print(assert(ends_in_3(13)))
print(assert(ends_in_3(253)))

print(assert(not ends_in_3(7)))
print(assert(not ends_in_3(31)))
print(assert(not ends_in_3(339)))


print(assert(is_prime(2)))
print(assert(not is_prime(4)))
print(assert(is_prime(3)))
print(assert(is_prime(5)))
print(assert(not is_prime(6)))
print(assert(is_prime(7)))

count = 0
num = 3
while count < 10 do
	-- I guess this was intended by the book's author. 
	-- It would be easier to increment num in steps of 10 :)
	if ends_in_3(num) and is_prime(num) then
		print(num)
		count = count + 1
	end
	num = num + 1
end

