--[[------------------------------------------------------

  xml test
  --------

  ...

--]]------------------------------------------------------
local lub    = require 'lub'
local lut    = require 'lut'
local xml    = require 'xml'
local should = lut.Test('xml')

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
  assertType('table', xml)
end

function should.decodeXml()
  local data = xml.parse(TEST_XML)
  assertValueEqual(TEST_RES, data)

  assertEqual('document', data.xml)
  local b = xml.find(data,'b')
  assertEqual('b', b.xml)
  assertEqual("Rock'n Roll", b.rock)
  assertEqual('This is Bob', b[1])
end

function should.removeNamespace()
  local data = xml.parse [[
<?xml version="1.0" encoding="utf-8"?>
<D:propfind xmlns:D="DAV:">
  <D:prop>
    <D:getlastmodified/>
    <D:getcontentlength/>
    <D:creationdate/>
    <D:resourcetype/>
  </D:prop>
</D:propfind>
]]
  assertTrue(data)
  xml.removeNamespace(data, 'DAV:')
  assertEqual('propfind', data.xml)
  local prop = xml.find(data, 'prop')
  assertEqual('prop', prop.xml)
  assertEqual('getlastmodified', prop[1].xml)
end

function should.dump()
  local data = xml.dump(TEST_RES)
  assertEqual(TEST_XML, data)
end

function should.load()
  local data = xml.load(lub.path('|fixtures/foo.xml'))
  assertValueEqual(TEST_RES, data)
end

function should.load()
  assertPass(function()
    local data = xml.load(lub.path('|fixtures/doxy.xml'))
  end)
end

function should.raiseErrorOnRecursion()
  local data = {xml='one', 'hello'}
  data[2] = data
  assertError('Could not dump table to XML. Maximal depth of 3000 reached.', function()
    xml.dump(data)
  end)
end

function should.find()
  local data = {xml = 'document',
    'blah blah',
    {xml = 'article',
      {xml = 'p', 'Blah blah',
        {xml = 'b', 'Bob'},
      },
      {xml = 'p', 'Hop hop'},
    },
    {xml = 'b', 'Top'},
  }
  local r = xml.find(data, 'b')
  assertEqual('Top', r[1])
end

function should.parserLarge()
  local data = xml.load(lub.path '|fixtures/large.xml')
  local t = {}
  lub.search(data, function(node)
    if node.xml == 'MedlineCitation' and node.Status == 'In-Process' then
      table.insert(t, xml.find(node, 'PMID')[1])
    end
  end)
  assertValueEqual({
    '11056631',
    '18941263',
  }, t)
end

should:test()
