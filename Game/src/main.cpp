#include "EngineLuaBindings.h"
#include "LuaGame.h"

#include <windows.h>

#include "GameEngine.h"

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow)
{
    ::MessageBoxA(nullptr, "Entered WinMain", "Debug", MB_OK); 
    EngineLuaBindings bindings;
    bindings.BindAll();
    

    // Load default Lua game
    bindings.LoadMain("lua/main.lua");

    
    LuaGame game(bindings.GetLua());
    GAME_ENGINE->SetGame(&game);
    

    return GAME_ENGINE->Run(hInstance, nCmdShow) ? 0 : 1;
    ::MessageBoxA(nullptr, "About to Run()", "Debug", MB_OK);
}