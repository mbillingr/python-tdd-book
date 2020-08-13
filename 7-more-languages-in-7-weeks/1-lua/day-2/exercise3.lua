dofile("exercise1.lua")

local mt = {
  __add = concatenate
}

function make_array(table)
  setmetatable(table, mt)
  return table
end
