local EnemyManager = {}
EnemyManager.__index = EnemyManager

local LaserMgr = require("laserManager") -- module

------------------------------------------------
-- Constructor
------------------------------------------------
function EnemyManager.new(laserManager)
  local self = setmetatable({}, EnemyManager)

  self.laserMgr = laserManager

  self.enemies = {}
  self.nextEnemyId = 1

  self.spawnCooldown = 0
  self.spawnCooldownMax = 75
  self.telegraphTicksMax = 40

  self.enemySize = 28
  self.score = 0

  return self
end

-- Module Methods...

-- Helper function
local function AABB(ax, ay, aw, ah, bx, by, bw, bh)
  return ax < bx + bw and ax + aw > bx and
         ay < by + bh and ay + ah > by
end

-- Spawn Enemy
function EnemyManager:SpawnEnemyAtEdge(w, h)
  local side = math.random(1, 4)
  local x, y

  if side == 1 then
    x = 0; y = math.random(0, h - self.enemySize)
  elseif side == 2 then
    x = w - self.enemySize; y = math.random(0, h - self.enemySize)
  elseif side == 3 then
    x = math.random(0, w - self.enemySize); y = 0
  else
    x = math.random(0, w - self.enemySize); y = h - self.enemySize
  end

  self.enemies[#self.enemies + 1] = {
    id = self.nextEnemyId,
    x = x, y = y,
    size = self.enemySize,
    telegraphTicks = self.telegraphTicksMax
  }

  -- Increment next enemy Id for when it is spawned
  self.nextEnemyId = self.nextEnemyId + 1
end

function EnemyManager:Update(player, w, h)
  if self.spawnCooldown > 0 then
    self.spawnCooldown = self.spawnCooldown - 1 -- Countdown spawn
  else
    self:SpawnEnemyAtEdge(w, h)
    self.spawnCooldown = self.spawnCooldownMax -- Reset cooldown
  end

  for i = #self.enemies, 1, -1 do
    self.enemies[i].telegraphTicks = self.enemies[i].telegraphTicks - 1 -- Countdown telegraphing laser

    if self.enemies[i].telegraphTicks <= 0 then
      self.laserMgr:Spawn(self.enemies[i], player, w, h)
      self.enemies[i].telegraphTicks = self.telegraphTicksMax
    end
  end
end

function EnemyManager:Draw(Engine, colors)
  for _, e in ipairs(self.enemies) do
    if e.telegraphTicks >= self.telegraphTicksMax - 5 then
      Engine:SetColor(colors.ENEMY_ATTACK)
    else
      Engine:SetColor(colors.ENEMY)
    end
    Engine:FillRect(e.x, e.y, e.x + e.size, e.y + e.size)
  end
end

function EnemyManager:KillEnemiesHitByMelee(meleeMgr, laserMgr)
  local mx, my, mw, mh = meleeMgr:GetRect() -- Melee hitbox
  if not mx then return end

  for i = #self.enemies, 1, -1 do
    if AABB(mx, my, mw, mh, self.enemies[i].x, self.enemies[i].y, self.enemies[i].size, self.enemies[i].size) then
      --laserMgr:RemoveLasersByOwner(e.id)
      table.remove(self.enemies, i)
      self.score = self.score + 10
    end
  end
end

function EnemyManager:ResetAllEnemies()
  self.enemies = {}
  self.score = 0
end

return EnemyManager
