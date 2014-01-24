--[[------------------------------------------------------

  xml bindings generator
  ------------------------

  This uses the 'dub' tool and Doxygen to generate the
  bindings for mimas.

  Input:  headers in 'include/xml'
  Output: cpp files in 'src/core'

--]]------------------------------------------------------
local lub = require 'lub'
local dub = require 'dub'

local base = lub.path('|')

local ins = dub.Inspector {
  INPUT    = {
    base .. '/include/xml',
  },
  --doc_dir = base .. '/tmp',
  --html = true,
  --keep_xml = true,
}

local binder = dub.LuaBinder()
local format = string.format

----------------------------------------------------------------
-- bind
----------------------------------------------------------------

binder:bind(ins, {
  output_directory = base .. '/src/bind',
  -- Remove this part in included headers
  header_base = base .. '/include',
  -- Create a single library.
  single_lib = 'xml',
  -- Open the library with require 'xml.core' (not 'xml')
  luaopen    = 'xml_core',
})
