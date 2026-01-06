local LaserMgr = require("laserManager")

-- lua/enemyManager.lua
local M = {}

M.enemies = {}
M.nextEnemyId = 1

M.spawnCooldown = 0
M.spawnCooldownMax = 75 -- enemy spawn cooldown
M.telegraphTicksMax = 40 -- interval before shooting laser

-- sizes
M.enemySize = 28

------------------------
-- HELPERS
------------------------
local function Clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end
local function AABB(ax, ay, aw, ah, bx, by, bw, bh)
  return ax < bx + bw and
         ax + aw > bx and
         ay < by + bh and
         ay + ah > by
end

local function SpawnEnemyAtEdge(windowWidth, windowHeight)
  local side = math.random(1, 4)
  local ex, ey

  if side == 1 then
    ex = 0
    ey = math.random(0, windowHeight - M.enemySize)
  elseif side == 2 then
    ex = windowWidth - M.enemySize
    ey = math.random(0, windowHeight - M.enemySize)
  elseif side == 3 then
    ex = math.random(0, windowWidth - M.enemySize)
    ey = 0
  else
    ex = math.random(0, windowWidth - M.enemySize)
    ey = windowHeight - M.enemySize
  end

 M.enemies[#M.enemies + 1] = {
    id = M.nextEnemyId,
  x = ex,
  y = ey,
  size = M.enemySize,
  telegraphTicks = M.telegraphTicksMax
}
M.nextEnemyId = M.nextEnemyId + 1

end

function M.Update(player, windowWidth, windowHeight)

  -- Spawn
  if M.spawnCooldown > 0 then
    M.spawnCooldown = M.spawnCooldown - 1
  else
    SpawnEnemyAtEdge(windowWidth, windowHeight)
    M.spawnCooldown = M.spawnCooldownMax
  end

  -- Update enemies (telegraph -> fire)
  for i = #M.enemies, 1, -1 do
    local e = M.enemies[i]
    e.telegraphTicks = e.telegraphTicks - 1

    if e.telegraphTicks <= 0 then
        LaserMgr.Spawn(e, player, windowWidth, windowHeight)
      e.telegraphTicks = M.telegraphTicksMax
    end
  end

end

function M.Draw(Engine, colors)

  Engine:SetColor(colors.ENEMY)
  for i = 1, #M.enemies do
    local e = M.enemies[i]
    if(e.telegraphTicks >= M.telegraphTicksMax - 5) then Engine:SetColor(colors.ENEMY_ATTACK) end
    Engine:FillRect(e.x, e.y, e.x + e.size, e.y + e.size)
  end

end


function M.KillEnemiesHitByMelee(meleeMgr, laserMgr)
  local mx, my, mw, mh = meleeMgr.GetRect()
  if not mx then return end

  for i = #M.enemies, 1, -1 do
    local e = M.enemies[i]
    if AABB(mx, my, mw, mh, e.x, e.y, e.size, e.size) then
      laserMgr.RemoveLasersByOwner(e.id) -- delete its lasers
      table.remove(M.enemies, i)         -- delete enemy
    end
  end
end


-- ============================
-- Delete ALL Enemies
-- ============================
function M.ResetAllEnemies()
  
  for i = #M.enemies, 1, -1 do
    table.remove(M.enemies, i)
  end
end

return M
