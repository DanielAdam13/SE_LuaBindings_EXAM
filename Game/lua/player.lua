local Player = {}

Player.__index = Player

function Player.new()
  local self = setmetatable({}, Player)
  -- Position / size
  self.x = 100
  self.y = 100
  self.playerRectSize = 40

  -- Movement
  self.walkSpeed = 3
  self.runSpeed  = 7
  self.dashSpeed = 20
  self.speed     = self.walkSpeed

  -- Dash
  self.dashTickMax      = 8
  self.dashCooldownMax = 30
  self.dashTicks       = 0
  self.dashCooldown    = 0
  self.prevAltDown     = false

  -- Health
  self.hp = 10

  return self
end

-- Module Methods...
function Player:SetBounds(windowWidth, windowHeight)
  if self.x < 0 then self.x = 0 end
  if self.y < 0 then self.y = 0 end

  if self.x > windowWidth - self.playerRectSize then
    self.x = windowWidth - self.playerRectSize
  end

  if self.y > windowHeight - self.playerRectSize then
    self.y = windowHeight - self.playerRectSize
  end
end

function Player:DashLogic(Engine, keys)
  if self.dashCooldown > 0 then
    self.dashCooldown = self.dashCooldown - 1
  end

  local altDown = Engine:IsKeyDown(keys.ALT)
  local altPressed = altDown and not self.prevAltDown
  self.prevAltDown = altDown

  if altPressed and self.dashCooldown == 0 and self.dashTicks == 0 then
    self.dashTicks    = self.dashTickMax
    self.dashCooldown = self.dashCooldownMax
  end
end

function Player:Update(Engine, keys)
  self:DashLogic(Engine, keys)

  self.speed = self.walkSpeed

  if Engine:IsKeyDown(keys.SHIFT) then
    self.speed = self.runSpeed
  end

  if self.dashTicks > 0 then
    self.speed = self.dashSpeed
  end

  if Engine:IsKeyDown(keys.LEFT)  then self.x = self.x - self.speed end
  if Engine:IsKeyDown(keys.RIGHT) then self.x = self.x + self.speed end
  if Engine:IsKeyDown(keys.UP)    then self.y = self.y - self.speed end
  if Engine:IsKeyDown(keys.DOWN)  then self.y = self.y + self.speed end

  if self.dashTicks > 0 then
    self.dashTicks = self.dashTicks - 1
  end
end

function Player:IsDashing()
  return self.dashTicks > 0
end

return Player