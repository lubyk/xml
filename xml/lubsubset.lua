--[[------------------------------------------------------

  This is a fork of the lubyk XML module. Since the module depends
  only on a few functions of the lub module, these are imported here
  to avoid installing more dependencies

--]]-----------------------------------------------------

local lib     = {}
local ipairs, pairs, insert, type,
      match, tostring =
      ipairs, pairs, table.ins
      
-- Join elements of a table @list@ with separator @sep@. Returns a string.
--
--   local x = lk.join({'foo', 'bar', 'baz'}, '.')
--   --> 'foo.bar.baz'
function lib.join(list, sep)
  local res = nil
  for _, part in ipairs(list) do
    if not res then
      res = part
    else
      res = res .. sep .. part
    end
  end
  return res or ''
end

-- Return the content of a file as a lua string (not suitable for very long
-- content where parsing the file chunks by chunks is better). The method
-- accepts either a single @path@ argument or a @basepath@ and relative @path@.
function lib.content(basepath, path)
  if path then
    path = string.format('%s/%s', basepath, path)
  else
    path = basepath
  end
  local f = assert(io.open(path, 'rb'))
  local s = f:read('*all')
  f:close()
  return s
end

-- [Breath-first search](https://en.wikipedia.org/wiki/Breadth-first_search) with max depth testing. See #search for usage.
function lib.search(data, func, max_depth)
  local max_depth = max_depth or 3000
  local queue = {}
  local depth = {} -- depth queue
  local head  = 1
  local tail  = 1
  local function push(e, d)
    queue[tail] = e
    depth[tail] = d
    tail = tail + 1
  end

  local function pop()
    if head == tail then return nil end
    local e, d = queue[head], depth[head]
    head = head + 1
    return e, d
  end

  local elem = data
  local d = 1
  while elem and d <= max_depth do
    local r = func(elem)
    if r then return elem end
    for _, child in ipairs(elem) do
      if type(child) == 'table' then
        push(child, d + 1)
      end
    end
    elem, d = pop()
  end

  if d and d > max_depth then
    error(format('Could not finish search: maximal depth of %i reached.', max_depth))
  else
    return nil
  end
end

return lib