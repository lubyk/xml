--[[------------------------------------------------------
  # Very fast xml parser

  The parser does not return information on comments, declarations,
  doctypes and pi nodes. These are validly parsed but not returned.

  This module is part of [lubyk](http://lubyk.org) project.  
  Install with [luarocks](http://luarocks.org) or [luadist](http://luadist.org).

    $ luarocks install xml    or    luadist install xml
  
  Dump a table to xml example:

    local xml = require 'xml'

--]]------------------------------------------------------
local core = require 'xml.core'
local lib  = core.Parser

-- ## Parser types
-- The following constants can be used with #new when creating a parser.
-- Depending on the type, the parser behavior is different. The default type is
-- Default.

-- Default parser type
-- lib.Default

-- Type of blah
-- lib.NonDestructive

-- xxx
-- lib.Fastest

-- Create a new parser. Type flag is optional.
-- Usage example:
--
--   local xml = require 'xml'
--   local parser = xml.Parser(xml.Parser.Fastest)
-- function lib.new(type)

-- Parse an xml string and return a Lua table. See [lua/xml](xml.html)
-- for the format of the returned table. Usage:
--
--   local data = parser:parse(some_xml_string)
--   --> lua table
-- function lib:parse(str)

return lib
