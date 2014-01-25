project ( xml CXX )

cmake_minimum_required ( VERSION 2.8 )

include ( cmake/dist.cmake )
include ( lua )

# Install lua files
install (
  DIRECTORY xml/
  DESTINATION ${INSTALL_LMOD}/xml
  COMPONENT Runtime
)

# This is not good as it installs in /usr/local/share/xml which might
# be used by some non-lua xml library...
# install_data ( readme.md LICENSE )

# install_example ( examples/ )

# Create and install a Lua module:
include_directories(include src/bind src/vendor)

install_lua_module ( xml.core
  src/bind/dub/dub.cpp
  src/bind/xml_core.cpp
  src/bind/xml_Parser.cpp
  src/Parser.cpp
)

# Schedules a test, this is optional
# add_lua_test ( test/all.lua )

# Install documentation
# install_doc ( doc/ )
