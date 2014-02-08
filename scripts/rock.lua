#!/usr/bin/env lua
local lub = require 'lub'
local lib = require 'xml'

local def = {
  description = {
    summary = "Very fast xml parser based on RapidXML",
    detailed = [[
      This module is part of the Lubyk project.

      Main features are:
       - Fast and easy to use
       - Complete documentation
       - Based on proven code (RapidXML)
       - Full test coverage

      Read the documentation at http://doc.lubyk.org/xml.html.
    ]],
    homepage = "http://doc.lubyk.org/"..lib.type..".html",
    author   = "Gaspard Bucher",
    license  = "MIT",
  },

  includes  = {'include', 'src/bind', 'src/vendor'},
  libraries = {'stdc++'},
  platlibs = {
  },
}

-- Platform specific sources or link libraries
def.platspec = def.platspec or lub.keys(def.platlibs)

--- End configuration

local tmp = lub.Template(lub.content(lub.path '|rockspec.in'))
lub.writeall(lib.type..'-'..lib.VERSION..'-1.rockspec', tmp:run {lib = lib, def = def, lub = lub})

tmp = lub.Template(lub.content(lub.path '|dist.info.in'))
lub.writeall('dist.info', tmp:run {lib = lib, def = def, lub = lub})

tmp = lub.Template(lub.content(lub.path '|CMakeLists.txt.in'))
lub.writeall('CMakeLists.txt', tmp:run {lib = lib, def = def, lub = lub})


