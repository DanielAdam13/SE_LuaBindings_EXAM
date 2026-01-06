local PlayerMod = require("player")
local player = PlayerMod.player

-- Virtual key codes (Windows)
local VK_LEFT  = 0x25
local VK_UP    = 0x26
local VK_RIGHT = 0x27
local VK_DOWN  = 0x28
local VK_ESC   = 0x1B
local VK_SPACE  = 0x20
local VK_SHIFT  = 0x10 
local VK_CONTROL = 0x11 
local VK_ALT = 0x12

local keys = {
  LEFT = VK_LEFT, RIGHT = VK_RIGHT, UP = VK_UP, DOWN = VK_DOWN, ESC = VK_ESC, 
  SPACE = VK_SPACE, SHIFT = VK_SHIFT, CONTROL = VK_CONTROL, ALT = VK_ALT
}

-- Preset Colors
local COLOR_BLACK      = 0x000000
local COLOR_WHITE      = 0xFFFFFF

local COLOR_RED        = 0x0000FF
local COLOR_GREEN      = 0x00FF00
local COLOR_BLUE       = 0xFF0000

local COLOR_YELLOW     = 0x00FFFF
local COLOR_CYAN       = 0xFFFF00
local COLOR_MAGENTA    = 0xFF00FF

local COLOR_GRAY_DARK  = 0x202020
local COLOR_GRAY       = 0x808080
local COLOR_GRAY_LIGHT = 0xD0D0D0

local COLOR_ORANGE     = 0x00A5FF
local COLOR_PURPLE     = 0x800080
local COLOR_PINK       = 0xCBC0FF

-- Window Size
local windowWidth = 800
local windowHeight = 600

function Initialize()
  Engine:SetWidth(windowWidth)
  Engine:SetHeight(windowHeight)
  Engine:SetFrameRate(60)
  Engine:SetTitle("Dodge_Out")
end

function Tick()
  Engine:Repaint()

  PlayerMod.Update(Engine, keys)
  PlayerMod.SetBounds(windowWidth, windowHeight)
      
  if Engine:IsKeyDown(VK_ESC) then Engine:Quit() end
end

function Paint(l, t, r, b)
  -- Background
  Engine:FillWindowRect(COLOR_PURPLE)

  -- Player
  Engine:SetColor(COLOR_CYAN)
  Engine:FillRect(player.x, player.y, player.x + player.playerRectSize, player.y + player.playerRectSize)

  -- UI text
  Engine:SetColor(COLOR_GRAY_DARK)
  Engine:DrawString("Arrows - move, ESC - quits", 10, 10)
  Engine:DrawString("Shift - Run, Alt - dash", 10, 30)
  Engine:DrawString("Space - Melee", 10, 50)
end

function End()
  -- Called once at end
end

-- Optional callbacks (only used if your LuaGame forwards them)
function KeyPressed(keyCode) end
function MouseMove(mx, my, wParam) end
function MouseButtonAction(isLeft, isDown, mx, my, wParam) end
function MouseWheelAction(mx, my, distance, wParam) end
function CheckKeyboard() end

