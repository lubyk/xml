--[[------------------------------------------------------

  xml.Parser test
  --------

  ...

--]]------------------------------------------------------
local lub    = require 'lub'
local lut    = require 'lut'
local xml    = require 'xml'

local should = lut.Test('xml.Parser')

should.ignore.deleted = true

local TEST_XML = [[
<document>
  <nodes>
    <a>This is a</a>
    <b rock='Rock&apos;n Roll'>This is Bob</b>
    <c/>
  </nodes>
  <p>Dear <b>Pedro</b>, how are you ?</p>
</document>]]

local TEST_RES = {xml = 'document',
  {xml = 'nodes',
    {xml = 'a', 'This is a'},
    {xml = 'b', rock = 'Rock\'n Roll', 'This is Bob'},
    {xml = 'c'},
  },
  {xml = 'p',
    'Dear ',
    {xml = 'b', 'Pedro'},
    ', how are you ?',
  },
}

function should.autoLoad()
  assertType('table', xml.Parser)
end

function should.createNew()
  local p = xml.Parser(xml.Parser.TrimWhitespace)
  assertEqual('xml.Parser', p.type)
end

function should.renderToString()
  local p = xml.Parser(xml.Parser.TrimWhitespace)
  assertMatch('xml.Parser: 0x%d', tostring(p))
end

function should.load()
  local p = xml.Parser()
  local data = p:load(lub.path('|fixtures/foo.xml'))
  assertValueEqual(TEST_RES, data)
end

function should.parse()
  local p = xml.Parser()
  assertValueEqual(TEST_RES, p:parse(TEST_XML))
end


should:test()

