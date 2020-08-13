
local SUCCESS_COUNTER = 0

function maybe_succeed()
  if SUCCESS_COUNTER > 0 then
    SUCCESS_COUNTER = SUCCESS_COUNTER - 1
    coroutine.yield("ERROR")
  end

  print("SUCCESS")
end

function succeed_after(n)
  SUCCESS_COUNTER = n
  return maybe_succeed
end


function retry(count, body)
  for r = 1, count do
    co = coroutine.create(body)
    _, error = coroutine.resume(co)
    if error then
      print(r, error)
    else
      return
    end
  end
end


retry(5, succeed_after(0))
retry(5, succeed_after(10))
retry(5, succeed_after(4))


-- Q: Why do we need coroutines for this exercise?
--    The implementation below works equally.
-- A: Probably they did not mean to "restart body() from its beginning",
--    because you need coroutines only if you want to continue a function.
--    Restarting from the beginning is something an ordinary function can do
--    as well.

local SUCCESS_COUNTER = 0

function maybe_succeed()
  if SUCCESS_COUNTER > 0 then
    SUCCESS_COUNTER = SUCCESS_COUNTER - 1
    return "ERROR"
  end

  print("SUCCESS")
end

function succeed_after(n)
  SUCCESS_COUNTER = n
  return maybe_succeed
end


function retry(count, body)
  for r = 1, count do
    error = body()
    if error then
      print(r, error)
    else
      return
    end
  end
end


retry(5, succeed_after(0))
retry(5, succeed_after(10))
retry(5, succeed_after(4))
