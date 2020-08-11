
function reduce(max, init, f)
	function loop(i, acc)
		if i > max then
			return acc
		else
			return loop(i + 1, f(i, acc))
		end
	end
	return loop(init+1, init)
end

function add(a, b)
	return a + b
end

function factorial(n)
	return reduce(n, 1, function(a, b) return a * b end)
end


assert(reduce(5, 0, add) == 15)

assert(factorial(5) == 120)
print(factorial(6))

