
function concatenate(a1, a2)
  a3 = {}

  for i, a in ipairs(a1) do
    a3[i] = a
  end

  for _, a in ipairs(a2) do
    a3[#a3 + 1] = a
  end

  return a3
end
