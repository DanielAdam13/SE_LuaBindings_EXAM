set(PROJECT_NAME "ProjectLuaBindings")

add_library(${PROJECT_NAME} STATIC
    src/EngineLuaBindings.cpp
    src/LuaGame.cpp
)

# Include engine headers
target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc           # wrapper headers
)

# Link to sol2 + Lua + engine library
target_link_libraries(${PROJECT_NAME} PUBLIC
    sol2::sol2
    lua::lua
    GameEngineLib
)

if (MSVC)
  target_compile_definitions(${PROJECT_NAME} PUBLIC UNICODE _UNICODE)
endif()

if (WIN32)
  target_link_libraries(${PROJECT_NAME} PUBLIC winmm)
endif()
