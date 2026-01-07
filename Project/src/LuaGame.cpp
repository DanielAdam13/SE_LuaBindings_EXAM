#include "LuaGame.h"
#include <windows.h> // for RECT
#include "GameEngine.h"

LuaGame::LuaGame(sol::state& lua)
    : m_Lua(lua) {}

void LuaGame::Initialize()
{
    AbstractGame::Initialize();
      static bool onceInit = false;
if (!onceInit) { onceInit = true; ::MessageBoxA(nullptr, "LuaGame::Initialize called", "Debug", MB_OK); }
    try
    {
        if (auto f = m_Lua["Initialize"]; f.valid())
        f();
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::Start()
{
    static bool onceStart = false;
if (!onceStart) {
    onceStart = true;
    ::MessageBoxA(nullptr, "LuaGame::Start called", "Debug", MB_OK);
}
    try
    {
        if (auto f = m_Lua["Start"]; f.valid())
        f();
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
}
}

void LuaGame::Tick()
{
    try
    {
        if (auto f = m_Lua["Tick"]; f.valid())
        f();
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
}
}

void LuaGame::Paint(RECT rect) const
{
    static bool oncePaint = false;
if (!oncePaint) {
    oncePaint = true;
    ::MessageBoxA(nullptr, "LuaGame::Paint called", "Debug", MB_OK);
}
    try
    {
        if (auto f = m_Lua["Paint"]; f.valid())
        f(rect.left, rect.top, rect.right, rect.bottom);
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::End()
{
    try
    {
         if (auto f = m_Lua["End"]; f.valid())
        f();
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::MouseButtonAction(bool isLeft, bool isDown, int x, int y, WPARAM wParam)
{
    try
    {
        if (auto f = m_Lua["MouseButtonAction"]; f.valid())
        f(isLeft, isDown, x, y, static_cast<std::uintptr_t>(wParam));
    }
     catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::MouseWheelAction(int x, int y, int distance, WPARAM wParam)
{
    try
    {
       if (auto f = m_Lua["MouseWheelAction"]; f.valid())
        f(x, y, distance, static_cast<std::uintptr_t>(wParam));
    }
     catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::MouseMove(int x, int y, WPARAM wParam)
{
    try
    {
       if (auto f = m_Lua["MouseMove"]; f.valid())
        f(x, y, static_cast<std::uintptr_t>(wParam));
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::CheckKeyboard()
{
    try
    {
        if (auto f = m_Lua["CheckKeyboard"]; f.valid())
        f();
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}

void LuaGame::KeyPressed(TCHAR key)
{
    try
    {
        // pass key code as number (for wchar_t)
        if (auto f = m_Lua["KeyPressed"]; f.valid())
        f(static_cast<int>(key));
    }
    catch (const sol::error& e) {
    ::MessageBoxA(nullptr, e.what(), "Lua callback error", MB_OK | MB_ICONERROR);
    if (GAME_ENGINE) GAME_ENGINE->Quit();
    }
}