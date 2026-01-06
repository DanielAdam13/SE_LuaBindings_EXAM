local M = {}

M.lasers = {}

-- tweakables
M.laserThickness = 12
M.laserTicksMax = 25

-- utility
local function Clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

-- ============================================================
-- Spawn laser (called by enemyManager)
-- ============================================================
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
    ticks = M.laserTicksMax
  }
end

-- ============================================================
-- Update lasers
-- ============================================================
function M.Update()
  for i = #M.lasers, 1, -1 do
    local L = M.lasers[i]
    L.ticks = L.ticks - 1
    if L.ticks <= 0 then
      table.remove(M.lasers, i)
    end
  end
end

-- ============================================================
-- Draw lasers
-- ============================================================
function M.Draw(Engine, colors)
  Engine:SetColor(colors.LASER)
  for i = 1, #M.lasers do
    local L = M.lasers[i]
    Engine:FillRect(L.x, L.y, L.x + L.w, L.y + L.h)
  end
end

return M
