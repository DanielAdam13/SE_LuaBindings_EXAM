local Player = require("player")
local player1 = Player.new()

local EnemyManager = require("enemyManager")
local LaserManager = require("laserManager")

local Lasers  = LaserManager.new()
local Enemies = EnemyManager.new(Lasers)


local MeleeAttackMgr = require("meleeAttack")
local Melee = MeleeAttackMgr.new()

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
local VK_R = 0x52

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

local objectColors = {ENEMY = COLOR_ORANGE, ENEMY_ATTACK = COLOR_MAGENTA, LASER = COLOR_RED}

-- Window Size
local windowWidth = 800
local windowHeight = 600

-- Game State
local gameLost = false

function Initialize()
  Engine:SetWidth(windowWidth)
  Engine:SetHeight(windowHeight)
  Engine:SetFrameRate(60)
  Engine:SetTitle("Dodge_Out")
end

function Start()
  math.randomseed(os.time())
end

function Tick()
  Engine:Repaint()

  if gameLost == false then
  player1:Update(Engine, keys)
  player1:SetBounds(windowWidth, windowHeight)

  Enemies:Update(player1, windowWidth, windowHeight)
  Lasers:Update(windowWidth, windowHeight)

  Melee:Update(Engine, keys, player1)
  Enemies:KillEnemiesHitByMelee(Melee, Lasers)

  if Lasers:DamagePlayerIfHit(player1, player1:IsDashing()) then
    player1.hp = player1.hp - 1

    if player1.hp <= 0 then
    player1.hp = 0
    gameLost = true
    end
  end
else
  -- Logic When Game Lost
  if Engine:IsKeyDown(VK_R) then 
    -- Restart...
    gameLost = false
    player1.hp = 10
    Lasers:ResetAllLasers()
    Enemies:ResetAllEnemies()
    Melee:Reset()
  end
end
      
  if Engine:IsKeyDown(VK_ESC) then Engine:Quit() end
end

function Paint(l, t, r, b)
  
  if gameLost == false then
  Engine:FillWindowRect(COLOR_PURPLE)

  -- Melee hitbox follows player
  Melee:Draw(Engine, COLOR_PINK)

    -- Player
  Engine:SetColor(COLOR_CYAN)
  Engine:FillRect(player1.x, player1.y, player1.x + player1.playerRectSize, player1.y + player1.playerRectSize)

  -- Enemies and Lasers
  Enemies:Draw(Engine, objectColors)
  Lasers:Draw(Engine, objectColors)

  -- UI text
  Engine:SetColor(COLOR_GRAY_LIGHT)
  Engine:DrawString("Arrows - move", 10, 10)
  Engine:DrawString("Shift - run, Alt - dash", 10, 30)
  Engine:DrawString("SPACE - melee", 10, 50)
  Engine:DrawString("Escape - quit", 10, 570)

  Engine:SetColor(COLOR_BLUE)
  Engine:DrawString(string.format("SCORE: %d", Enemies.score), 360, 30)
  else
  Engine:FillWindowRect(COLOR_GRAY_DARK)

  -- UI text
  Engine:SetColor(COLOR_RED)
  Engine:DrawString("YOU LOST", 370, 220)
  Engine:DrawString("Try Again? ----> Press R", 320, 300)
  Engine:DrawString("Exit Game ----> Press ESC", 320, 500)

  Engine:SetColor(COLOR_WHITE)
  Engine:DrawString(string.format("SCORE: %d", Enemies.score), 360, 30)
  end

  Engine:SetColor(COLOR_RED)
  Engine:DrawString(string.format("HEALTH: %d", player1.hp), windowWidth - 100, 10)

  
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

