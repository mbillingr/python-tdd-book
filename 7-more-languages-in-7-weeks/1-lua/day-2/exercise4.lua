
Queue = {}

function Queue.new()
  return setmetatable({first=1, last=1}, {__index=Queue})
end

function Queue.add(self, item)
  self[self.last] = item
  self.last = self.last + 1
end

function Queue.remove(self)
  if self.first >= self.last then
    -- keep indices low
    self.first = 1
    self.last = 1
    return nil
  end

  item = self[self.first]
  self[self.first] = nil
  self.first = self.first + 1
  return item
end

q = Queue.new()
q:add('a')
q:add('b')
q:add('c')
assert(q:remove() == 'a')
assert(q:remove() == 'b')
q:add('d')
assert(q:remove() == 'c')
assert(q:remove() == 'd')
assert(q:remove() == nil)
q:add('x')
assert(q:remove() == 'x')
