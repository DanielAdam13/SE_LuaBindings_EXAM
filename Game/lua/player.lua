-- lua/player.lua
local M = {}

M.player = {
  x = 100,
  y = 100,
  playerRectSize = 40,
  walkSpeed = 3,
  runSpeed = 7,
  speed = walkSpeed,
  hp = 10,
  dashSpeed = 20,
  dashTickMax = 8,
  dashCooldownMax = 30
}

-- Dash state variables
M.dashTicks = 0
M.dashCooldown = 0
M.prevAltDown = false

function M.SetBounds(windowWidth, windowHeight)
  local p = M.player
  if p.x < 0 then p.x = 0 end
  if p.x > windowWidth - p.playerRectSize then p.x = windowWidth - p.playerRectSize end
  if p.y < 0 then p.y = 0 end
  if p.y > windowHeight - p.playerRectSize then p.y = windowHeight - p.playerRectSize end
end

function M.DashLogic(Engine, keys)
  if M.dashCooldown > 0 then M.dashCooldown = M.dashCooldown - 1 end

  local altDown = Engine:IsKeyDown(keys.ALT)
  local altPressed = (altDown and not M.prevAltDown)
  M.prevAltDown = altDown

  if altPressed and M.dashCooldown == 0 and M.dashTicks == 0 then
    M.dashTicks = M.player.dashTickMax
    M.dashCooldown = M.player.dashCooldownMax
  end
end

function M.Update(Engine, keys)
  M.DashLogic(Engine, keys)

  local p = M.player
  p.speed = p.walkSpeed

  if Engine:IsKeyDown(keys.SHIFT) then p.speed = p.runSpeed end
  if M.dashTicks > 0 then p.speed = p.dashSpeed end

  if Engine:IsKeyDown(keys.LEFT)  then p.x = p.x - p.speed end
  if Engine:IsKeyDown(keys.RIGHT) then p.x = p.x + p.speed end
  if Engine:IsKeyDown(keys.UP)    then p.y = p.y - p.speed end
  if Engine:IsKeyDown(keys.DOWN)  then p.y = p.y + p.speed end

  if M.dashTicks > 0 then M.dashTicks = M.dashTicks - 1 end
end

function M.IsDashing()
    return M.dashTicks > 0
end

return M
