------------------------------------------------------------------------------
-- Templet for Lua.
-- Copyright © 2012–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local templet = require("templet")

-- test if-then-else
do
  local temp = templet.loadstring([[
  |if DEBUG then
  function log(msg, ...)
    print(msg:format(...))
  end
  |else
  function log() end
  |end
  ]])
  assert(temp({DEBUG = true}) == [[
  function log(msg, ...)
    print(msg:format(...))
  end
  ]])
  assert(temp({DEBUG = false}) == [[
  function log() end
  ]])
end

-- test loop
do
  local temp = templet.loadstring([[
  for (int i = 0; i < ${nparticle}; ++i) {
    |for i = 1, #coord do
    r[i].${coord[i]} = r[i].${coord[i]} + v[i].${coord[i]} * ${timestep};
    |end
  }
  ]])
  assert(temp({coord = {"x", "y", "z"}, nparticle = 5000, timestep = 0.001}) == [[
  for (int i = 0; i < 5000; ++i) {
    r[i].x = r[i].x + v[i].x * 0.001;
    r[i].y = r[i].y + v[i].y * 0.001;
    r[i].z = r[i].z + v[i].z * 0.001;
  }
  ]])
  assert(temp({coord = {"x", "y"}, nparticle = 1000, timestep = 0.002}) == [[
  for (int i = 0; i < 1000; ++i) {
    r[i].x = r[i].x + v[i].x * 0.002;
    r[i].y = r[i].y + v[i].y * 0.002;
  }
  ]])
end

-- test syntax
do
  assert(templet.loadstring(""    )() == ""    )
  assert(templet.loadstring(" "   )() == " "   )
  assert(templet.loadstring("  "  )() == "  "  )
  assert(templet.loadstring("\n " )() == "\n " )
  assert(templet.loadstring(" \n" )() == " \n" )
  assert(templet.loadstring("\n\n")() == "\n\n")

  assert(templet.loadstring("|"      )() == ""    )
  assert(templet.loadstring(" |"     )() == ""    )
  assert(templet.loadstring("  |"    )() == ""    )
  assert(templet.loadstring(" a |"   )() == " a |")
  assert(templet.loadstring("\n |"   )() == "\n"  )
  assert(templet.loadstring("\n | \n")() == "\n"  )
  assert(templet.loadstring(" |\n"   )() == ""    )
  assert(templet.loadstring(" | \n"  )() == ""    )

  assert(templet.loadstring("${math.pi}"    )() == ("%s"    ):format(math.pi))
  assert(templet.loadstring("${math.pi} "   )() == ("%s "   ):format(math.pi))
  assert(templet.loadstring(" ${math.pi}"   )() == (" %s"   ):format(math.pi))
  assert(templet.loadstring("\n${math.pi}"  )() == ("\n%s"  ):format(math.pi))
  assert(templet.loadstring("${math.pi}\n"  )() == ("%s\n"  ):format(math.pi))
  assert(templet.loadstring("\n${math.pi}\n")() == ("\n%s\n"):format(math.pi))

  assert(templet.loadstring("${math.pi}|"       )() == ("%s|"  ):format(math.pi))
  assert(templet.loadstring("${math.pi}\n|"     )() == ("%s\n"  ):format(math.pi))
  assert(templet.loadstring("${math.pi}\n|\n"   )() == ("%s\n"  ):format(math.pi))
  assert(templet.loadstring("|\n${math.pi}\n|"  )() == ("%s\n"  ):format(math.pi))
  assert(templet.loadstring("|\n\n${math.pi}\n|")() == ("\n%s\n"):format(math.pi))

  assert(templet.loadstring("| local s = \"${math.pi}\"\n${s}")() == "${math.pi}")

  local t = {}
  assert(templet.loadstring("| pi = \"${math.pi}\"")(t) == "")
  assert(t.pi == "${math.pi}")

  assert(templet.loadstring("${}"        )() == ""     )
  assert(templet.loadstring("${nil}"     )() == ""     )
  assert(templet.loadstring("${not true}")() == "false")
end

-- test output function
do
  local chunks = {}
  assert(templet.loadstring("")(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 0)

  local chunks = {}
  assert(templet.loadstring(" ")(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 1)
  assert(chunks[1] == " ")

  local chunks = {}
  assert(templet.loadstring("  ")(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 1)
  assert(chunks[1] == "  ")

  local chunks = {}
  assert(templet.loadstring("${math.pi}")(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 1)
  assert(chunks[1] == math.pi)

  local chunks = {}
  assert(templet.loadstring("${math.pi} ")(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 2)
  assert(chunks[1] == math.pi)
  assert(chunks[2] == " ")

  local chunks = {}
  assert(templet.loadstring(" ${math.pi}")(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 2)
  assert(chunks[1] == " ")
  assert(chunks[2] == math.pi)

  local chunks = {}
  local id = {}
  assert(templet.loadstring("  ${id} ")({id = id}, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 3)
  assert(chunks[1] == "  ")
  assert(chunks[2] == id)
  assert(chunks[3] == " ")

  local chunks = {}
  assert(templet.loadstring([[
  |for i = 1, 2 do
  x[${i}] = ${math.sqrt(i)}
  |end
  ]])(nil, function(chunk) table.insert(chunks, chunk) end) == nil)
  assert(#chunks == 11)
  assert(chunks[1] == "  x[")
  assert(chunks[2] == 1)
  assert(chunks[3] == "] = ")
  assert(chunks[4] == 1)
  assert(chunks[5] == "\n")
  assert(chunks[6] == "  x[")
  assert(chunks[7] == 2)
  assert(chunks[8] == "] = ")
  assert(chunks[9] == math.sqrt(2))
  assert(chunks[10] == "\n")
  assert(chunks[11] == "  ")
end

-- test loadfile
do
  local filename = "integrate.c.in"
  local file = assert(io.open(filename, "w"))
  file:write([[
  for (int i = 0; i < ${nparticle}; ++i) {
    |for i = 1, #coord do
    r[i].${coord[i]} = r[i].${coord[i]} + v[i].${coord[i]} * ${timestep};
    |end
  }
  ]])
  file:close()
  local temp = templet.loadfile(filename)
  assert(temp({coord = {"x", "y", "z"}, nparticle = 5000, timestep = 0.001}) == [[
  for (int i = 0; i < 5000; ++i) {
    r[i].x = r[i].x + v[i].x * 0.001;
    r[i].y = r[i].y + v[i].y * 0.001;
    r[i].z = r[i].z + v[i].z * 0.001;
  }
  ]])
  assert(temp({coord = {"x", "y"}, nparticle = 1000, timestep = 0.002}) == [[
  for (int i = 0; i < 1000; ++i) {
    r[i].x = r[i].x + v[i].x * 0.002;
    r[i].y = r[i].y + v[i].y * 0.002;
  }
  ]])
  assert(os.remove(filename))
end
