local MeleeManager = {}
MeleeManager.__index = MeleeManager

------------------------------------------------
-- Constructor
------------------------------------------------
function MeleeManager.new()
  local self = setmetatable({}, MeleeManager)

  -- state
  self.active = false
  self.ticksLeft = 0

  -- tuning
  self.durationTicks     = 12
  self.cooldownTicksMax  = 20
  self.cooldownTicks     = 0

  self.radius  = 60
  self.padding = 25

  self.prevSpaceDown = false

  -- computed per update
  self.x = 0
  self.y = 0
  self.size = 0

  return self
end

------------------------------------------------
-- Input / activation
------------------------------------------------
function MeleeManager:TryStart(Engine, keys)
  if self.cooldownTicks > 0 then
    self.cooldownTicks = self.cooldownTicks - 1
  end

  local spaceDown = Engine:IsKeyDown(keys.SPACE)
  local spacePressed = spaceDown and not self.prevSpaceDown
  self.prevSpaceDown = spaceDown

  if spacePressed and not self.active and self.cooldownTicks == 0 then
    self.active = true
    self.ticksLeft = self.durationTicks
    self.cooldownTicks = self.cooldownTicksMax
  end
end

------------------------------------------------
-- Update
------------------------------------------------
function MeleeManager:Update(Engine, keys, player)
  self:TryStart(Engine, keys)

  if not self.active then return end

  -- follow player
  self.size = player.playerRectSize + self.padding * 2
  self.x = player.x - self.padding
  self.y = player.y - self.padding

  -- lifetime
  self.ticksLeft = self.ticksLeft - 1
  if self.ticksLeft <= 0 then
    self.active = false
  end
end

------------------------------------------------
-- Draw
------------------------------------------------
function MeleeManager:Draw(Engine, color)
  if not self.active then return end

  Engine:SetColor(color)
  Engine:FillRoundRect(
    self.x,
    self.y,
    self.x + self.size,
    self.y + self.size,
    self.radius
  )
end

------------------------------------------------
-- Collision rect
------------------------------------------------
function MeleeManager:GetRect()
  if not self.active then return nil end
  return self.x, self.y, self.size, self.size
end

------------------------------------------------
-- Reset
------------------------------------------------
function MeleeManager:Reset()
  self.active = false
  self.ticksLeft = 0
  self.cooldownTicks = 0
  self.prevSpaceDown = false
end

return MeleeManager
