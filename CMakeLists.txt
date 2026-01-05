cmake_minimum_required(VERSION 3.20)
project(LuaGameRoot)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

# -----------------------------
# Lua
# -----------------------------
FetchContent_Declare(
    lua
    URL https://github.com/marovira/lua/archive/refs/tags/5.4.4.tar.gz
)
FetchContent_MakeAvailable(lua)

# Fetch SOL2
# ++++++++++
FetchContent_Declare(
    sol2
    URL https://github.com/ThePhD/sol2/archive/refs/tags/v3.3.0.tar.gz
)
FetchContent_MakeAvailable(sol2)

# Engine is prebuilt = >
add_library(GameEngineLib STATIC IMPORTED)
set_target_properties(GameEngineLib PROPERTIES
    IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/Engine/lib/GameEngine8_01.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/Engine/include"  
)

# Add subdirectories
add_subdirectory(Project)
add_subdirectory(Game)
