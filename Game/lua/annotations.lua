---@meta

---@class GameEngine
local GameEngine = {}

---@param title string
function GameEngine:SetTitle(title) end

---@param w integer
function GameEngine:SetWidth(w) end

---@param h integer
function GameEngine:SetHeight(h) end

---@param fps integer
function GameEngine:SetFrameRate(fps) end

---@return void
function GameEngine:GoFullscreen() end

---@return void
function GameEngine:GoWindowedMode() end

---@return void 
function GameEngine:Quit() end

---@return void
function GameEngine:Repaint() end

---@return boolean
function GameEngine:IsFullScreen() end

---@return string
function GameEngine:GetTitle() end

---@return integer
function GameEngine:GetWidth() end

---@return integer
function GameEngine:GetHeight() end

---@return integer
function GameEngine:GetFrameRate() end

---@return integer
function GameEngine:GetFrameDelay() end

---@param keyCode integer
---@return boolean
function GameEngine:IsKeyDown(keyCode) end

---@param text string
---@param fontPtr Font
---@return SIZE
function GameEngine:CalculateTextDimensions(text, fontPtr)

---@param color integer
function GameEngine:SetColor(color) end

---@param color integer
---@return boolean
function GameEngine:FillWindowRect(color) end

---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@return boolean
function GameEngine.DrawLine(x1, y1, x2, y2) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@return boolean
function GameEngine:DrawRect(l, t, r, b) end

---@overload fun(l:integer, t:integer, r:integer, b:integer)
---@overload fun(l:integer, t:integer, r:integer, b:integer, opacity:integer)
---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param opacity? integer
---@return boolean
function GameEngine:FillRect(l, t, r, b, opacity) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param radius integer
---@return boolean
function GameEngine:DrawRoundRect(l, t, r, b, radius) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param radius integer
---@return boolean
function GameEngine:FillRoundRect(l, t, r, b, radius) end

---@param text string
---@param x integer
---@param y integer
---@return integer
function GameEngine:DrawString(text, x, y) end

---@return Point
function GameEngine:GetWindowPosition() end

---@type GameEngine
Engine = {}

-- GAME LOGIC ANNOTATIONS
---@class Enemy
---@field id number
---@field x number
---@field y number
---@field size number
---@field telegraphTicks number

---@class EnemyManager
---@field laserMgr any                 # The LaserManager instance
---@field enemies Enemy[]              # Table of active enemies
---@field nextEnemyId number           # Next enemy id
---@field spawnCooldown number         # Current spawn cooldown
---@field spawnCooldownMax number      # Max spawn cooldown
---@field telegraphTicksMax number     # Max telegraph ticks
---@field enemySize number             # Enemy size
---@field score number                 # Current score
local EnemyManager = {}

---@param laserManager any @LaserManager instance
---@return EnemyManager
function EnemyManager.new(laserManager) end

------------------------------------------------
-- Methods
------------------------------------------------
---@param w number @Width of the playfield
---@param h number @Height of the playfield
function EnemyManager:SpawnEnemyAtEdge(w, h) end

---@param player any @The player object
---@param w number @Width of the playfield
---@param h number @Height of the playfield
function EnemyManager:Update(player, w, h) end

---@param Engine any @Rendering engine instance (with SetColor, FillRect)
---@param colors table @Color table (ENEMY, ENEMY_ATTACK)
function EnemyManager:Draw(Engine, colors) end

---@param meleeMgr any @Melee manager instance
---@param laserMgr any @Laser manager instance
function EnemyManager:KillEnemiesHitByMelee(meleeMgr, laserMgr) end

function EnemyManager:ResetAllEnemies() end

return EnemyManager

-- MELEE ATTACK MANAGER
ine (with IsKeyDown)
---@param keys table        # Keys table (e.g., keys.SPACE)
function MeleeManager:TryStart(Engine, keys) end

---@param Engine any
---@param keys table
---@param player any        # Player object (with x, y, playerRectSize)
function MeleeManager:Update(Engine, keys, player) end

---@param Engine any        # Rendering engine (with SetColor, FillRoundRect)
---@param color any         # Color to draw the melee attack
function MeleeManager:Draw(Engine, color) end

---@return number x
---@return number y
---@return number width
---@return number height
function MeleeManager:GetRect() end

function MeleeManager:Reset() end

return MeleeManager

-- LASER MANAGER
---@class Laser
---@field ownerId number          # Enemy ID that spawned the laser
---@field x number
---@field y number
---@field w number                # Width of laser
---@field h number                # Height of laser
---@field horizontal boolean      # Whether laser is horizontal
---@field telegraphTicks number   # Countdown before laser becomes active
---@field activeTicks number      # Duration laser stays active
---@field isActive boolean        # True if laser is active
---@field didHit boolean          # True if laser already hit player

---@class LaserManager
---@field lasers Laser[]           # List of active lasers
---@field thinThickness number
---@field thickThickness number
---@field telegraphTicksMax number
---@field activeTicksMax number

local LaserManager = {}

---@return LaserManager
function LaserManager.new() end

------------------------------------------------
-- Methods
------------------------------------------------
---@param enemy any      # Enemy table
---@param player any     # Player table
---@param w number       # Width of the playfield
---@param h number       # Height of the playfield
function LaserManager:Spawn(enemy, player, w, h) end

---@param w number
---@param h number
function LaserManager:Update(w, h) end

---@param player any
---@param isInvulnerable boolean
---@return boolean @true if hit
function LaserManager:DamagePlayerIfHit(player, isInvulnerable) end

---@param Engine any
---@param colors table
function LaserManager:Draw(Engine, colors) end

---@param id number
function LaserManager:RemoveLasersByOwner(id) end

function LaserManager:ResetAllLasers() end

return LaserManager

-- PLAYER
---@class Player
---@field x number
---@field y number
---@field playerRectSize number
---@field walkSpeed number
---@field runSpeed number
---@field dashSpeed number
---@field speed number
---@field dashTickMax number
---@field dashCooldownMax number
---@field dashTicks number
---@field dashCooldown number
---@field prevAltDown boolean
---@field hp number
local Player = {}

---@return Player
function Player.new() end

------------------------------------------------
-- Methods
------------------------------------------------
---@param windowWidth number
---@param windowHeight number
function Player:SetBounds(windowWidth, windowHeight) end

---@param Engine any
---@param keys table
function Player:DashLogic(Engine, keys) end

---@param Engine any
---@param keys table
function Player:Update(Engine, keys) end

---@return boolean
function Player:IsDashing() end

return Player