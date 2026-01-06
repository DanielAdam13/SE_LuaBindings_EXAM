local M = {}

M.lasers = {}

-- ============================
-- Tweakables
-- ============================
M.thinThickness  = 10 -- non-active thickness
M.thickThickness = 25 -- active thickness

M.telegraphTicksMax = 100 -- interval before non-active and active state
M.activeTicksMax    = 25 -- active ticks before deleting laser

-- ============================
-- Utilities
-- ============================
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

-- ============================
-- Spawn laser
-- ============================
function M.Spawn(enemy, player, windowWidth, windowHeight, enemyId) 
  local px = math.floor(player.x + player.playerRectSize / 2)
  local py = math.floor(player.y + player.playerRectSize / 2)

  local ex = math.floor(enemy.x + enemy.size / 2)
  local ey = math.floor(enemy.y + enemy.size / 2)

  local horizontal = math.abs(px - ex) >= math.abs(py - ey)

  local lx, ly, lw, lh

  if horizontal then
    ly = Clamp(py - M.thinThickness // 2, 0, windowHeight - M.thinThickness)
    lx = 0
    lw = windowWidth
    lh = M.thinThickness
  else
    lx = Clamp(px - M.thinThickness // 2, 0, windowWidth - M.thinThickness)
    ly = 0
    lw = M.thinThickness
    lh = windowHeight
  end

  M.lasers[#M.lasers + 1] = {
    ownerId = enemyId,
    x = math.floor(lx),
    y = math.floor(ly),
    w = math.floor(lw),
    h = math.floor(lh),

    horizontal = horizontal,

    telegraphTicks = M.telegraphTicksMax,
    activeTicks    = M.activeTicksMax,

    isActive = false,
    didHit   = false
  }
end

-- ============================
-- Remove all lasers per enemy
-- ============================
function M.RemoveLasersByOwner(enemyId)
  for i = #M.lasers, 1, -1 do
    if M.lasers[i].ownerId == enemyId then
      table.remove(M.lasers, i)
    end
  end
end

-- ============================
-- Update lasers
-- ============================
function M.Update(windowWidth, windowHeight)
  for i = #M.lasers, 1, -1 do
    local L = M.lasers[i]

    if not L.isActive then
      L.telegraphTicks = L.telegraphTicks - 1

      if L.telegraphTicks <= 0 then
        L.isActive = true

        -- grow ONCE (KEEP INTEGERS)
        if L.horizontal then
          local cy = L.y + L.h // 2
          L.h = M.thickThickness
          L.y = Clamp(cy - L.h // 2, 0, windowHeight - L.h)
        else
          local cx = L.x + L.w // 2
          L.w = M.thickThickness
          L.x = Clamp(cx - L.w // 2, 0, windowWidth - L.w)
        end

        -- enforce integer safety
        L.x = math.floor(L.x)
        L.y = math.floor(L.y)
        L.w = math.floor(L.w)
        L.h = math.floor(L.h)
      end

    else
      L.activeTicks = L.activeTicks - 1
      if L.activeTicks <= 0 then
        table.remove(M.lasers, i)
      end
    end
  end
end

-- ============================
-- Player collision (ONLY active)
-- ============================
function M.DamagePlayerIfHit(player, invulnerable)
  if invulnerable then
    return false end

  for i = 1, #M.lasers do
    local L = M.lasers[i]
    if L.isActive and not L.didHit then
      if AABB(
        player.x, player.y,
        player.playerRectSize, player.playerRectSize,
        L.x, L.y, L.w, L.h
      ) then
        L.didHit = true
        return true
      end
    end
  end
  return false
end

-- ============================
-- Draw lasers
-- ============================
function M.Draw(Engine, colors)
  
  for i = 1, #M.lasers do
    local L = M.lasers[i]
    if(L.isActive) then Engine:SetColor(colors.LASER) 
  else Engine:SetColor(0x808080) 
  end
    Engine:FillRect(L.x, L.y, L.x + L.w, L.y + L.h)
  end
end

-- ============================
-- Delete ALL Lasers
-- ============================
function M.ResetAllLasers()
  
  for i = #M.lasers, 1, -1 do
    table.remove(M.lasers, i)
  end
end

return M
