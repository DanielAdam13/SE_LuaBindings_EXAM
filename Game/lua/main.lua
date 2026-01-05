-- Simple state
local x, y = 100, 100
local speed = 3

-- Virtual key codes (Windows)
local VK_LEFT  = 0x25
local VK_UP    = 0x26
local VK_RIGHT = 0x27
local VK_DOWN  = 0x28
local VK_ESC   = 0x1B

function Initialize()
  Engine:SetWidth(800)
  Engine:SetHeight(600)
  Engine:SetFrameRate(60)
end

function Start()
  -- Called once at start
end

function Tick()
  Engine:Repaint()

  if Engine:IsKeyDown(VK_LEFT)  then x = x - speed end
  if Engine:IsKeyDown(VK_RIGHT) then x = x + speed end
  if Engine:IsKeyDown(VK_UP)    then y = y - speed end
  if Engine:IsKeyDown(VK_DOWN)  then y = y + speed end
  if Engine:IsKeyDown(VK_ESC)   then Engine:Quit() end
end

function Paint(l, t, r, b)
  -- Background
  Engine:FillWindowRect(0x000000)

  -- Player
  Engine:SetColor(0x00FF00)
  Engine:FillRect(x, y, x + 40, y + 40)

  -- UI text
  Engine:SetColor(0xFFFFFF)
  --Engine:DrawString("Arrows move, ESC quits", 10, 10)
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

