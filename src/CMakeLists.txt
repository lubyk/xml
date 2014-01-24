# --------------------------------------------------------------
#  xml_core                                  xml/core.so
# --------------------------------------------------------------
set(target "${MODULE_NAME}_core")

include_directories(bind vendor)

# set(OS_LIBRARIES "-framework Cocoa")

# --------------------------------------------------------------
#  MODULE_src
# --------------------------------------------------------------
file(GLOB MODULE_src bind/dub/*.cpp bind/*.cpp *.cpp ${PLAT}/*.cpp ${PLAT}/*.mm)

# --------------------------------------------------------------
#  xml/core.so
# --------------------------------------------------------------
add_library(${target} MODULE ${MODULE_src})

set_target_properties(${target}
  PROPERTIES OUTPUT_NAME core
  LINK_FLAGS ${PLAT_OBJ_FLAGS}
  PREFIX ""
  SUFFIX ".so"
)  

target_link_libraries(${target}
  ${OS_LIBRARIES}
)

add_dependencies(${MODULE_NAME} ${target})

# --------------------------------------------------------------
#  install                                     
# --------------------------------------------------------------

# install(TARGETS ${target}
#   DESTINATION ${LUBYK_LIB}/lib/${MODULE_NAME}
# )



