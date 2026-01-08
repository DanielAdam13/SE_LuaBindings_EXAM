#include "EngineLuaBindings.h"

#include "GameEngine.h"

// SHOW real error for when Lua aborts (panic)
static int LuaPanic(lua_State* L) {
    const char* msg = lua_tostring(L, -1);
    ::MessageBoxA(nullptr,
        msg ? msg : "Lua panic (no message)",
        "Lua PANIC - abort() would be called",
        MB_OK | MB_ICONERROR);
    return 0;
}

EngineLuaBindings::EngineLuaBindings()
    : m_Lua(sol::c_call<decltype(&LuaPanic), &LuaPanic>)
{
    m_Lua.open_libraries(
        sol::lib::base, sol::lib::math, sol::lib::table, sol::lib::string,
        sol::lib::package, sol::lib::utf8
    );

    m_Lua["package"]["path"] =
        m_Lua["package"]["path"].get<std::string>() + ";lua/?.lua;lua/?/init.lua";
}

void EngineLuaBindings::BindAll()
{
    // Global pointer to engine singleton
    m_Lua["Engine"] = GAME_ENGINE;

    m_Lua.new_usertype<POINT>("Point",
    sol::no_constructor,
    "x", &POINT::x,
    "y", &POINT::y
    );

    m_Lua.new_usertype<SIZE>("Size",
    sol::no_constructor,
    "w", &SIZE::cx,
    "h", &SIZE::cy
    );

    // Binding Engine methods
    m_Lua.new_usertype<GameEngine>("GameEngine",
        sol::no_constructor,

        // Window / control
        "SetTitle", &GameEngine::SetTitle,           // PROBLEMATIC WITH tstring and UNICODE
        "SetWindowPosition", &GameEngine::SetWindowPosition,
        "SetWidth", &GameEngine::SetWidth,
        "SetHeight", &GameEngine::SetHeight,
        "SetKeyList", &GameEngine::SetKeyList,
        "SetFrameRate", &GameEngine::SetFrameRate,
        "Quit", &GameEngine::Quit,
        "Repaint", &GameEngine::Repaint,

        "GoFullscreen", &GameEngine::GoFullscreen,
        "GoWindowedMode", &GameEngine::GoWindowedMode,
        "ShowMousePointer", &GameEngine::ShowMousePointer,

        "HasWindowRegion", &GameEngine::HasWindowRegion,
        "IsFullScreen", &GameEngine::IsFullscreen,

        "GetTitle", &GameEngine::GetTitle,
        "GetWidth", &GameEngine::GetWidth,
        "GetHeight", &GameEngine::GetHeight,
        "GetFrameRate", &GameEngine::GetFrameRate,
        "GetFrameDelay", &GameEngine::GetFrameDelay,

        // Input
        "IsKeyDown", &GameEngine::IsKeyDown,

        //"MessageBox", [](GameEngine& e, const std::string& msg) { e.MessageBox(msg); },

        "CalculateTextDimensions", static_cast<SIZE (GameEngine::*) (const tstring&, const Font*) const>(&GameEngine::CalculateTextDimensions),

        // Drawing
        "SetColor", &GameEngine::SetColor,
        "FillWindowRect", &GameEngine::FillWindowRect,
        "DrawLine", &GameEngine::DrawLine,
        "DrawRect", &GameEngine::DrawRect,
        "FillRect", sol::overload(
            [](GameEngine& e, int l, int t, int r, int b) { return e.FillRect(l, t, r, b); },
            [](GameEngine& e, int l, int t, int r, int b, int opacity) { return e.FillRect(l, t, r, b, opacity); }
        ),
        "DrawRoundRect", &GameEngine::DrawRoundRect,
        "FillRoundRect", &GameEngine::FillRoundRect,

        // PROBLEMATIC WITH tstring and UNICODE
        "DrawString", sol::overload(
        static_cast<int (GameEngine::*)(const tstring&, int, int) const>(&GameEngine::DrawString),
        static_cast<int (GameEngine::*)(const tstring&, int, int, int, int) const>(&GameEngine::DrawString)
        ),

        "GetWindowPosition", &GameEngine::GetWindowPosition
    );
}

void EngineLuaBindings::LoadMain(const std::string& file)
{
    // Only runtime scripts are loaded.
    try 
    {
        m_Lua.script_file(file);
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua error", MB_OK | MB_ICONERROR);
    throw;
}
}