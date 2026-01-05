#pragma once
#include "AbstractGame.h"
#include <sol/sol.hpp>

class LuaGame final : public AbstractGame
{
public:
    LuaGame(sol::state& lua);

    void Initialize() override;
    void Start() override;
    void Tick() override;
    void Paint(RECT rect) const override;
    void End() override;

    void MouseButtonAction(bool isLeft, bool isDown, int x, int y, WPARAM wParam) override;
    void MouseWheelAction(int x, int y, int distance, WPARAM wParam) override;
    void MouseMove(int x, int y, WPARAM wParam) override;
    void CheckKeyboard() override;
    void KeyPressed(TCHAR key) override;

private:
    sol::state& m_Lua;
};