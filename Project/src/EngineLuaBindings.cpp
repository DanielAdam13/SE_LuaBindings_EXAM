#include "EngineLuaBindings.h"

#include "GameEngine.h"

static int LuaPanic(lua_State* L) {
    const char* msg = lua_tostring(L, -1);
    ::MessageBoxA(nullptr,
        msg ? msg : "Lua panic (no message)",
        "Lua PANIC - abort() would be called",
        MB_OK | MB_ICONERROR);
    return 0; // Lua will still abort after this, but at least you see the real message
}

EngineLuaBindings::EngineLuaBindings()
    : m_Lua(sol::c_call<decltype(&LuaPanic), &LuaPanic>)
{
    m_Lua.open_libraries(
        sol::lib::base, sol::lib::math, sol::lib::table, sol::lib::string,
        sol::lib::package, sol::lib::coroutine, sol::lib::utf8
    );

    m_Lua["package"]["path"] =
        m_Lua["package"]["path"].get<std::string>() + ";lua/?.lua;lua/?/init.lua";
}

void EngineLuaBindings::BindAll()
{
    // Global pointer to engine singleton
    m_Lua["Engine"] = GAME_ENGINE;

    // Bind GameEngine methods (expand this list over time)
    m_Lua.new_usertype<GameEngine>("GameEngine",
        sol::no_constructor,

        // Window / control
        //"SetTitle", &GameEngine::SetTitle,           // PROBLEMATIC WITH tstring and UNICODE
        "SetWidth", &GameEngine::SetWidth,
        "SetHeight", &GameEngine::SetHeight,
        "SetFrameRate", &GameEngine::SetFrameRate,
        "Quit", &GameEngine::Quit,
        "Repaint", &GameEngine::Repaint,

        "GetWidth", &GameEngine::GetWidth,
        "GetHeight", &GameEngine::GetHeight,

        // Input
        "IsKeyDown", &GameEngine::IsKeyDown,

        // Drawing
        "SetColor", &GameEngine::SetColor,
        "FillWindowRect", &GameEngine::FillWindowRect,
        "DrawLine", &GameEngine::DrawLine,
        "DrawRect", &GameEngine::DrawRect,
        "FillRect", sol::overload(
            [](GameEngine& e, int l, int t, int r, int b) { return e.FillRect(l, t, r, b); },
            [](GameEngine& e, int l, int t, int r, int b, int opacity) { return e.FillRect(l, t, r, b, opacity); }
        )

        // PROBLEMATIC WITH tstring and UNICODE

        // "DrawString", sol::overload(
        //     [](GameEngine& e, const tstring& text, int l, int t) { return e.DrawString(text, l, t); },
        //     [](GameEngine& e, const tstring& text, int l, int t, int r, int b) { return e.DrawString(text, l, t, r, b); }
        // )
    );
}

void EngineLuaBindings::LoadMain(const std::string& file)
{
    // Only runtime scripts are loaded.
    // This will error out if Lua has an error.
    try 
    {
        m_Lua.script_file(file);
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua error", MB_OK | MB_ICONERROR);
    throw;
}
}