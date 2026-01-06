-- lua/meleeManager.lua
local M = {}

-- one active hitbox at a time
M.active = false
M.ticksLeft = 0
M.durationTicks = 12      -- how long it stays visible/active
M.cooldownTicksMax = 20
M.cooldownTicks = 0

M.radius = 60             -- round rect corner radius
M.padding = 25            -- extra size around player

M.prevSpaceDown = false

-- computed each update
M.x = 0
M.y = 0
M.size = 0

function M.TryStart(Engine, keys)
  if M.cooldownTicks > 0 then
    M.cooldownTicks = M.cooldownTicks - 1
  end

  local spaceDown = Engine:IsKeyDown(keys.SPACE)
  local spacePressed = (spaceDown and not M.prevSpaceDown)
  M.prevSpaceDown = spaceDown

  if spacePressed and (not M.active) and M.cooldownTicks == 0 then
    M.active = true
    M.ticksLeft = M.durationTicks
    M.cooldownTicks = M.cooldownTicksMax
  end
end

function M.Update(Engine, keys, player)
  M.TryStart(Engine, keys)

  if not M.active then return end

  -- follow the player every tick
  M.size = player.playerRectSize + M.padding * 2
  M.x = player.x - M.padding
  M.y = player.y - M.padding

  -- lifetime
  M.ticksLeft = M.ticksLeft - 1
  if M.ticksLeft <= 0 then
    M.active = false
  end
end

function M.Draw(Engine, color)
  if not M.active then return end
  Engine:SetColor(color)
  --Engine:DrawRoundRect(M.x, M.y, M.x + M.size, M.y + M.size, M.radius)
  Engine:FillRoundRect(M.x, M.y, M.x + M.size, M.y + M.size, M.radius)
end

function M.Reset()
  M.active = false
  M.ticksLeft = 0
  M.cooldownTicks = 0
  M.prevSpaceDown = false
end

-- MELEE ATTACK COLLIDER
function M.GetRect()
  if not M.active then 
    return nil end

  return M.x, M.y, M.size, M.size
end

return M
