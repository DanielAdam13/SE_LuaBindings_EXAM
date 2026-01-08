set(GAME_NAME "LuaGameEngine")

add_executable(${GAME_NAME} WIN32
    src/main.cpp
)

# set_target_properties(${GAME_NAME} PROPERTIES
#     RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/Game"
# )

foreach(cfg IN LISTS CMAKE_CONFIGURATION_TYPES)
    string(TOUPPER "${cfg}" cfg_upper)
    set_target_properties(${GAME_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY_${cfg_upper} "${CMAKE_SOURCE_DIR}/Game"
    )
endforeach()

target_link_libraries(${GAME_NAME} PRIVATE
    ProjectLuaBindings
)

# Copies resources after build - next to .exe (in this case it's the lua/ folder)
# add_custom_command(TARGET ${GAME_NAME} POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_directory
#             "${CMAKE_CURRENT_SOURCE_DIR}/lua"
#             "$<TARGET_FILE_DIR:${GAME_NAME}>/lua"
# )

if (MSVC)
  target_compile_definitions(${GAME_NAME} PRIVATE UNICODE _UNICODE)
endif()