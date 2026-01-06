local M = {}

M.lasers = {}

-- tweakables
M.laserThickness = 12
M.laserTicksMax = 25

----------------------------
-- Utilities
----------------------------
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

----------------------------
-- Spawn laser
----------------------------
function M.Spawn(enemy, player, windowWidth, windowHeight)
  local px = math.floor(player.x + player.playerRectSize / 2)
  local py = math.floor(player.y + player.playerRectSize / 2)

  local ex = enemy.x + enemy.size / 2
  local ey = enemy.y + enemy.size / 2

  local dx = px - ex
  local dy = py - ey
  local horizontal = math.abs(dx) >= math.abs(dy)

  local lx, ly, lw, lh

  if horizontal then
    ly = Clamp(py - M.laserThickness / 2, 0, windowHeight - M.laserThickness)
    lx = 0
    lw = windowWidth
    lh = M.laserThickness
  else
    lx = Clamp(px - M.laserThickness / 2, 0, windowWidth - M.laserThickness)
    ly = 0
    lw = M.laserThickness
    lh = windowHeight
  end

  M.lasers[#M.lasers + 1] = {
    x = math.floor(lx),
    y = math.floor(ly),
    w = math.floor(lw),
    h = math.floor(lh),
    ticks = M.laserTicksMax,
    didHit = false
  }
end

----------------------------
-- Update lasers
----------------------------
function M.Update()
  for i = #M.lasers, 1, -1 do
    local L = M.lasers[i]
    L.ticks = L.ticks - 1
    if L.ticks <= 0 then
      table.remove(M.lasers, i)
    end
  end
end

----------------------------
-- Player collision (call from Tick)
----------------------------
function M.DamagePlayerIfHit(player)
  for i = 1, #M.lasers do
    local L = M.lasers[i]

    if not L.didHit then
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

----------------------------
-- Draw lasers
----------------------------
function M.Draw(Engine, colors)
  Engine:SetColor(colors.LASER)
  for i = 1, #M.lasers do
    local L = M.lasers[i]
    Engine:FillRect(L.x, L.y, L.x + L.w, L.y + L.h)
  end
end

return M
