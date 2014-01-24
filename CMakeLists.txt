project ( lub NONE )

cmake_minimum_required ( VERSION 2.8 )

include ( cmake/dist.cmake )
include ( lua )

install (
  DIRECTORY lub/
  DESTINATION ${INSTALL_LMOD}/lub
  COMPONENT Runtime
)

install_data ( README.md LICENSE )

# install_example ( examples/ )


