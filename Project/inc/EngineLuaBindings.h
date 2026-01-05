#pragma once
#include <sol/sol.hpp>
#include <string>

class EngineLuaBindings
{
public:
    EngineLuaBindings();

    sol::state& GetLua() { return m_Lua; }

    void BindAll();
    void LoadMain(const std::string& file); // e.g. "lua/main.lua"

private:
    sol::state m_Lua;
};