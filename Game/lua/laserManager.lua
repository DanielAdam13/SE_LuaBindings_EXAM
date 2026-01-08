local LaserManager = {}
LaserManager.__index = LaserManager

function LaserManager.new()
  local self = setmetatable({}, LaserManager)

  self.lasers = {} -- Table

  self.thinThickness  = 10
  self.thickThickness = 25

  self.telegraphTicksMax = 100
  self.activeTicksMax    = 25

  return self
end

------------------------------------------------
-- Helpers
------------------------------------------------
local function Clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function AABB(ax, ay, aw, ah, bx, by, bw, bh)
  return ax < bx + bw and ax + aw > bx and
         ay < by + bh and ay + ah > by
end

------------------------------------------------
-- Spawn
------------------------------------------------
function LaserManager:Spawn(enemy, player, w, h)
  local px = math.floor(player.x + player.playerRectSize / 2)
  local py = math.floor(player.y + player.playerRectSize / 2)

  local ex = enemy.x + enemy.size / 2
  local ey = enemy.y + enemy.size / 2

  -- Decide state
  local horizontal = math.abs(px - ex) >= math.abs(py - ey)
  local x, y, lw, lh

  if horizontal then
    x = 0
    y = Clamp(py - self.thinThickness // 2, 0, h - self.thinThickness)
    lw = w; lh = self.thinThickness
  else
    x = Clamp(px - self.thinThickness // 2, 0, w - self.thinThickness)
    y = 0
    lw = self.thinThickness; lh = h
  end

  -- Add new laser to the table
  self.lasers[#self.lasers + 1] = {
    ownerId = enemy.id,
    x = x, y = y,
    w = lw, h = lh,
    horizontal = horizontal,
    telegraphTicks = self.telegraphTicksMax,
    activeTicks = self.activeTicksMax,
    isActive = false,
    didHit = false
  }
end

function LaserManager:Update(w, h)
  for i = #self.lasers, 1, -1 do
    local L = self.lasers[i]

    if not L.isActive then
      L.telegraphTicks = L.telegraphTicks - 1
      if L.telegraphTicks <= 0 then
        L.isActive = true

        if L.horizontal then
          local cy = L.y + L.h // 2
          L.h = self.thickThickness
          L.y = Clamp(cy - L.h // 2, 0, h - L.h)
        else
          local cx = L.x + L.w // 2
          L.w = self.thickThickness
          L.x = Clamp(cx - L.w // 2, 0, w - L.w)
        end
      end
    else
      L.activeTicks = L.activeTicks - 1
      if L.activeTicks <= 0 then
        table.remove(self.lasers, i)
      end
    end
  end
end


function LaserManager:DamagePlayerIfHit(player, isInvulnerable)
  if isInvulnerable then return false end -- isInvulnerable is a boolean

  for _, L in ipairs(self.lasers) do
    if L.isActive and not L.didHit then
      if AABB(player.x, player.y,
              player.playerRectSize, player.playerRectSize,
              L.x, L.y, L.w, L.h) then
        L.didHit = true
        return true
      end
    end
  end
  return false
end

function LaserManager:Draw(Engine, colors)
  for _, L in ipairs(self.lasers) do
    if L.isActive then
    Engine:SetColor(colors.LASER)
    else
    Engine:SetColor(0x808080)
    end
    Engine:FillRect(L.x, L.y, L.x + L.w, L.y + L.h)
  end
end

function LaserManager:RemoveLasersByOwner(id)
  for i = #self.lasers, 1, -1 do
    if self.lasers[i].ownerId == id then
      table.remove(self.lasers, i)
    end
  end
end

function LaserManager:ResetAllLasers()
  self.lasers = {}
end

return LaserManager